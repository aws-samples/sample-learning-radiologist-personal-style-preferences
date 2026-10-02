"""
Preference Agent - Infers style preferences from user edits.

Analyzes the difference between AI-generated impressions and user edits
to extract learnable style preferences for the CIPHER algorithm.

KEY FEATURE: Multi-preference extraction
- A single edit may contain MULTIPLE changes (some stylistic, some clinical)
- This agent extracts ALL atomic changes and classifies each separately
- Only STYLISTIC changes become preferences; clinical changes are rejected
- Example: "bullet points" (stylistic, saved) + "no acute disease" (clinical, rejected)

Uses Strands structured output for type-safe preference inference.
"""

import logging

from strands import Agent
from strands.models import BedrockModel

from config import MODEL_ID, CONFIDENCE_REJECTION_THRESHOLD, get_model_id, supports_temperature
from db import store_preference, update_case_impression, store_edit_history, embed_text, store_rejected_preference
from cipher import calculate_edit_distance, should_infer_preference
from models import ExtractedChanges, SaveEditResponse, SavedPreference, RejectedChange
from preference_validator import validate_preference
from security import (
    detect_prompt_injection,
    is_content_adding_preference,
    sanitize_user_input,
)


logger = logging.getLogger(__name__)


# =============================================================================
# Multi-Preference Extraction System Prompt
# =============================================================================

SYSTEM_PROMPT = """You are an expert at analyzing how radiologists edit AI-generated impressions to identify MULTIPLE distinct changes.

YOUR TASK: Break down an edit into ATOMIC CHANGES and classify each one separately.

A single edit often contains multiple changes:
- Some are STYLISTIC (formatting, terminology, phrasing) - these are SAFE to learn
- Some are CLINICAL (adding/changing medical content) - these are DANGEROUS to learn

EXAMPLE ANALYSIS:
Original: "Mild cardiomegaly. Bibasilar atelectasis. No focal consolidation, pleural effusion or pneumothorax."
Edited: "* Mild cardiomegaly, with Bibasilar atelectasis.\n* No acute pulmonary disease"

Changes identified:
1. FORMAT: Prose → Bullet points [STYLISTIC - formatting]
2. PHRASING: Joined two sentences with comma [STYLISTIC - phrasing]
3. CLINICAL: Replaced specific negatives with general "No acute pulmonary disease" [CONTENT-ADDING - reject]

CLASSIFICATION RULES:
====================

STYLISTIC (is_stylistic=True) - SAFE to learn:
- terminology: Word choice changes that mean the same thing ("opacity" → "consolidation")
- formatting: Structure changes (prose → bullets, paragraph breaks, capitalization, section headers/labels)
- phrasing: Sentence pattern preferences ("no evidence of X" vs "X absent")
- priority: Ordering preferences (acute before chronic)
- detail_level: Verbosity preferences (more/less detail on same content)

NOTE ON SECTION HEADERS: Adding a label or heading that describes the existing content (e.g. "Impression:", "# Impression", "Findings:") is FORMATTING, not content-adding. The header is a structural label, not new clinical information. However, adding a header for content that doesn't exist (e.g. "Treatment Options:", "Differential Diagnosis:") IS content-adding because it implies new clinical sections.

CONTENT-ADDING (is_stylistic=False) - DANGEROUS, must reject:
- Adding diagnoses or clinical interpretations not in findings
- Adding differentials, treatment suggestions, or recommendations
- Summarizing/abstracting clinical content (specific → general)
- Adding clinical correlation or follow-up suggestions
- Adding section headers for clinical content that doesn't exist in the impression (e.g. "Treatment:", "Differential:")

For each change, provide:
1. change_description: What changed
2. is_stylistic: True if safe, False if adds/changes clinical content
3. category: If stylistic, which category (terminology/formatting/detail_level/phrasing/priority)
4. preference_text: If stylistic, a clear actionable preference statement
5. rejection_reason: If not stylistic, why it was rejected
6. confidence: How confident you are in this classification (0.0-1.0)"""


# Cache for agents by model_id
_agents: dict[str, Agent] = {}


def get_agent(model_id: str = None) -> Agent:
    """Get or create the multi-preference extraction agent.

    Args:
        model_id: Optional Bedrock model ID. If not provided, uses default.

    Returns:
        Agent configured for preference extraction
    """
    global _agents

    actual_model_id = model_id or MODEL_ID

    if actual_model_id not in _agents:
        model_kwargs = {"model_id": actual_model_id, "max_tokens": 8192}
        if supports_temperature(actual_model_id):
            model_kwargs["temperature"] = 0.1  # Low temperature for consistent classification
        model = BedrockModel(**model_kwargs)
        _agents[actual_model_id] = Agent(
            model=model,
            system_prompt=SYSTEM_PROMPT,
            callback_handler=None,  # Suppress streaming output
        )

    return _agents[actual_model_id]


def save_edit(
    user_id: str,
    case_id: str,
    original_impression: str,
    edited_impression: str,
    findings: str,
    model_settings: dict = None
) -> dict:
    """
    Save an edit and extract MULTIPLE preferences if present.

    Key difference from previous version:
    - Extracts ALL atomic changes in an edit
    - Saves only the stylistic ones as preferences
    - Reports which changes were rejected and why

    Args:
        user_id: User identifier
        case_id: Case identifier
        original_impression: AI-generated impression
        edited_impression: User's edited version
        findings: Original radiology findings (for context embedding)
        model_settings: Optional dict mapping agent names to model keys

    Returns:
        Dict with edit_id, preferences_saved, changes_rejected, and summary
    """
    # Step 0: Check for prompt injection in user inputs
    is_injection, pattern = detect_prompt_injection(edited_impression)
    if is_injection:
        logger.warning(f"Prompt injection detected in edit: user={user_id}, pattern={pattern}")
        edit_distance = calculate_edit_distance(original_impression, edited_impression)
        edit_id = store_edit_history(
            user_id, case_id, original_impression, edited_impression, edit_distance,
            source="user_edit",
        )
        update_case_impression(user_id, case_id, edited_impression=edited_impression)

        return SaveEditResponse(
            edit_id=edit_id,
            edit_distance=edit_distance,
            preference_inferred=False,
            summary="Edit saved. Preference learning disabled due to safety filter.",
            rejection_reason="Input rejected by safety filter",
        ).model_dump()

    # Step 1: Calculate edit distance
    edit_distance = calculate_edit_distance(original_impression, edited_impression)

    # Step 2: Store in edit history
    edit_id = store_edit_history(
        user_id, case_id, original_impression, edited_impression, edit_distance,
        source="user_edit",
    )

    # Step 3: Update case with edited impression
    update_case_impression(user_id, case_id, edited_impression=edited_impression)

    # Initialize response tracking
    preferences_saved: list[SavedPreference] = []
    changes_rejected: list[RejectedChange] = []

    # Step 4: Check if edit is significant enough for preference inference
    if should_infer_preference(original_impression, edited_impression):
        # Build multi-change extraction prompt
        prompt = f"""Analyze this edit and identify ALL distinct changes. Classify each as stylistic or content-adding.

**Original AI-generated impression:**
<original>
{sanitize_user_input(original_impression)}
</original>

**Radiologist's edited version:**
<edited>
{sanitize_user_input(edited_impression)}
</edited>

**Context (findings for reference):**
<findings>
{sanitize_user_input((findings or "")[:2000])}
</findings>

Break down ALL changes in this edit. For each change:
- Identify what specifically changed
- Classify as stylistic (safe) or content-adding (dangerous)
- If stylistic, provide an actionable preference statement
- If content-adding, explain why it cannot be learned

Remember: The same edit can have BOTH stylistic changes (learn them) AND clinical changes (reject them)."""

        # Get the model to use for preference inference
        inference_model_id = get_model_id("preference_inference", model_settings)

        # Extract changes with Strands agent using structured output
        agent = get_agent(model_id=inference_model_id)
        response = agent(prompt, structured_output_model=ExtractedChanges)
        extracted: ExtractedChanges = response.structured_output

        logger.info(f"Extracted {len(extracted.changes)} changes from edit using model {inference_model_id}")

        # Get embedding once for all preferences
        context_embedding = embed_text(findings, input_type="search_document")

        # Process each extracted change
        for change in extracted.changes:
            if change.is_stylistic and change.preference_text:
                # Additional safety checks on stylistic preferences
                # Check confidence threshold
                if change.confidence < CONFIDENCE_REJECTION_THRESHOLD:
                    rejection_reason = f"Low confidence ({change.confidence:.2f})"
                    logger.info(f"Low confidence change skipped: {change.change_description}")
                    changes_rejected.append(RejectedChange(
                        change_description=change.change_description,
                        rejection_reason=rejection_reason
                    ))
                    # Store in rejected preferences table for audit
                    store_rejected_preference(
                        user_id=user_id,
                        change_description=change.change_description,
                        rejection_reason=rejection_reason,
                        rejection_layer="confidence_threshold",
                        source_case_id=case_id,
                        source_edit_id=edit_id,
                        original_impression=original_impression,
                        edited_impression=edited_impression,
                        context_findings=findings,
                        inference_model=inference_model_id,
                    )
                    continue

                # Fast heuristic check
                is_content_adding, keyword = is_content_adding_preference(change.preference_text)
                if is_content_adding:
                    rejection_reason = f"Contains content-adding keyword: {keyword}"
                    logger.warning(f"Content keyword detected: {change.preference_text}")
                    changes_rejected.append(RejectedChange(
                        change_description=change.change_description,
                        rejection_reason=rejection_reason
                    ))
                    # Store in rejected preferences table for audit
                    store_rejected_preference(
                        user_id=user_id,
                        change_description=change.change_description,
                        rejection_reason=rejection_reason,
                        rejection_layer="keyword_filter",
                        source_case_id=case_id,
                        source_edit_id=edit_id,
                        original_impression=original_impression,
                        edited_impression=edited_impression,
                        context_findings=findings,
                        inference_model=inference_model_id,
                    )
                    continue

                # Validator agent check (uses Haiku by default for speed)
                validation = validate_preference(
                    change.preference_text,
                    original_impression,
                    edited_impression,
                    findings,
                    model_settings=model_settings
                )

                if not validation.is_stylistic:
                    logger.warning(f"Validator rejected: {change.preference_text}")
                    changes_rejected.append(RejectedChange(
                        change_description=change.change_description,
                        rejection_reason=validation.reason
                    ))
                    # Store in rejected preferences table for audit
                    store_rejected_preference(
                        user_id=user_id,
                        change_description=change.change_description,
                        rejection_reason=validation.reason,
                        rejection_layer="validator_agent",
                        source_case_id=case_id,
                        source_edit_id=edit_id,
                        original_impression=original_impression,
                        edited_impression=edited_impression,
                        context_findings=findings,
                        risk_level=validation.risk_level,
                        inference_model=inference_model_id,
                    )
                    continue

                # All checks passed - store the preference
                pref_result = store_preference(
                    user_id,
                    change.preference_text,
                    context_embedding,
                    case_id,
                    category=change.category,
                    confidence=change.confidence,
                    inference_explanation=change.change_description,
                    source_edit_id=edit_id,
                    original_impression=original_impression,
                    edited_impression=edited_impression,
                    context_findings=findings,
                    edit_distance=edit_distance,
                    inference_model=inference_model_id,
                )

                preferences_saved.append(SavedPreference(
                    preference_id=pref_result["preference_id"],
                    preference_text=change.preference_text,
                    category=change.category or "unknown",
                    confidence=change.confidence
                ))

                logger.info(f"Preference saved: {change.category} - {change.preference_text[:50]}...")

            else:
                # Content-adding change - record why it was rejected
                rejection_reason = change.rejection_reason or "Classified as content-adding"
                changes_rejected.append(RejectedChange(
                    change_description=change.change_description,
                    rejection_reason=rejection_reason
                ))
                # Store in rejected preferences table for audit
                store_rejected_preference(
                    user_id=user_id,
                    change_description=change.change_description,
                    rejection_reason=rejection_reason,
                    rejection_layer="llm_classification",
                    source_case_id=case_id,
                    source_edit_id=edit_id,
                    original_impression=original_impression,
                    edited_impression=edited_impression,
                    context_findings=findings,
                    inference_model=inference_model_id,
                )
                logger.info(f"Change rejected (content-adding): {change.change_description}")

    # Build summary
    saved_count = len(preferences_saved)
    rejected_count = len(changes_rejected)

    if saved_count > 0 and rejected_count > 0:
        summary = f"Learned {saved_count} stylistic preference(s). Rejected {rejected_count} content-adding change(s)."
    elif saved_count > 0:
        summary = f"Learned {saved_count} stylistic preference(s)."
    elif rejected_count > 0:
        summary = f"Edit saved. {rejected_count} change(s) were content-adding and not learned."
    else:
        summary = "Edit saved. No significant style changes detected."

    # Build response with backward compatibility
    return SaveEditResponse(
        edit_id=edit_id,
        edit_distance=edit_distance,
        preferences_saved=preferences_saved,
        changes_rejected=changes_rejected,
        summary=summary,
        # Legacy fields (first preference if any)
        preference_inferred=len(preferences_saved) > 0,
        preference_id=preferences_saved[0].preference_id if preferences_saved else None,
        preference_text=preferences_saved[0].preference_text if preferences_saved else None,
        preference_category=preferences_saved[0].category if preferences_saved else None,
        preference_confidence=preferences_saved[0].confidence if preferences_saved else None,
        rejection_reason=changes_rejected[0].rejection_reason if changes_rejected and not preferences_saved else None,
    ).model_dump()
