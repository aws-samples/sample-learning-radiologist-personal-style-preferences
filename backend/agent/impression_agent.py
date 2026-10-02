"""
Impression Agent - Orchestrates the two-stage generation pipeline.

Stage 1: Base Impression Agent generates grounded content from findings
Stage 2: Style Refinement Agent applies user preferences (modify only, never add)

This separation ensures preferences cannot cause hallucination of clinical content.
"""

import logging

from config import get_model_id, get_k_preferences
from db import get_user_preferences, update_case_impression, embed_text, store_edit_history
from cipher import retrieve_similar_preferences, calculate_edit_distance
from models import (
    GenerateImpressionResponse, AppliedPreference,
    GenerationTrace, RetrievalTrace, RetrievedPreferenceTrace, RefinementTrace,
)
from base_impression_agent import generate_base_impression
from style_refinement_agent import refine_impression


logger = logging.getLogger(__name__)


def generate_impression(
    user_id: str,
    case_id: str,
    findings: str,
    clinical_interpretation: bool = False,
    model_settings: dict = None
) -> dict:
    """
    Generate an impression using the two-stage CIPHER pipeline.

    Stage 1: Generate base impression from findings (grounded, no preferences)
    Stage 2: Apply user preferences to refine style (modify only, never add)

    This architecture ensures that:
    - Agent 1 only sees findings → output is grounded
    - Agent 2 only sees base impression (not findings) → cannot add clinical content
    - Preferences are shown as examples, not rules → less over-application

    Args:
        user_id: User identifier
        case_id: Case identifier
        findings: Radiology findings text
        clinical_interpretation: If True, allow clinical inferences in impressions
        model_settings: Optional dict mapping agent names to model keys

    Returns:
        Dict with impression, preferences_used count, preferences_applied, case_id, and model info
    """
    logger.info(f"Generating impression for user={user_id}, case={case_id}, clinical_interpretation={clinical_interpretation}")

    # ==========================================================================
    # STAGE 1: Generate base impression from findings only
    # ==========================================================================
    base_model_id = get_model_id("base_impression", model_settings)
    logger.info(f"Stage 1: Generating base impression from findings using {base_model_id}")
    base_impression, base_model_used = generate_base_impression(
        findings,
        clinical_interpretation,
        model_id=base_model_id
    )
    logger.info(f"Base impression generated: {len(base_impression)} chars")

    # ==========================================================================
    # STAGE 2: Retrieve preferences and apply style refinement
    # ==========================================================================
    # Embed findings for similarity search
    findings_embedding = embed_text(findings, input_type="search_query")
    logger.info(f"Findings embedding generated: {len(findings_embedding)} dimensions")

    # Get user's preferences
    all_preferences = get_user_preferences(user_id)
    logger.info(f"Total preferences for user: {len(all_preferences)}")

    # Find similar contexts (k-NN) - use user's K setting
    k_value = get_k_preferences(model_settings)  # model_settings contains all user settings
    similar_prefs = retrieve_similar_preferences(
        findings_embedding,
        all_preferences,
        k=k_value
    )
    logger.info(f"k-NN retrieved {len(similar_prefs)} similar preferences (k={k_value})")
    for i, pref in enumerate(similar_prefs):
        logger.info(f"  Pref {i+1}: {pref.get('preference_text', 'N/A')[:60]}... (similarity: {pref.get('_similarity_score', 'N/A')})")

    # Build retrieval trace
    retrieval_trace = RetrievalTrace(
        total_preferences=len(all_preferences),
        k_requested=k_value,
        k_returned=len(similar_prefs),
        retrieved=[
            RetrievedPreferenceTrace(
                preference_id=p.get("preference_id", "unknown"),
                preference_text=p.get("preference_text", ""),
                similarity_score=round(p.get("_similarity_score", 0.0), 4),
                source_case_id=p.get("source_case_id"),
                category=p.get("category"),
            )
            for p in similar_prefs
        ],
    )

    # Apply style refinement if preferences exist
    refinement_model_used = None
    if similar_prefs:
        refinement_model_id = get_model_id("style_refinement", model_settings)
        logger.info(f"Stage 2: Applying {len(similar_prefs)} preference(s) using {refinement_model_id}")
        final_impression, refinement_model_used = refine_impression(
            base_impression,
            similar_prefs,
            model_id=refinement_model_id
        )
        logger.info(f"Refined impression: {len(final_impression)} chars")
    else:
        logger.info("Stage 2: No preferences to apply, using base impression")
        final_impression = base_impression

    # Build refinement trace
    refinement_edit_distance = calculate_edit_distance(base_impression, final_impression)
    refinement_trace = RefinementTrace(
        was_applied=bool(similar_prefs),
        base_length=len(base_impression),
        refined_length=len(final_impression),
        edit_distance=refinement_edit_distance,
        model_id=refinement_model_used,
    )

    # ==========================================================================
    # Store result and return
    # ==========================================================================

    # Build list of applied preferences for attribution and storage
    applied_prefs = [
        AppliedPreference(
            preference_id=p.get("preference_id", "unknown"),
            preference_text=p.get("preference_text", "")
        )
        for p in similar_prefs
        if p.get("preference_id") and p.get("preference_text")
    ]

    # Store preferences_applied as simple dicts for JSON serialization
    prefs_for_storage = [
        {"preference_id": p.preference_id, "preference_text": p.preference_text}
        for p in applied_prefs
    ]

    # Store result with audit trail on Cases table
    # ALWAYS store base_impression for full traceability (Item 1)
    update_case_impression(
        user_id,
        case_id,
        generated_impression=final_impression,
        preferences_applied=prefs_for_storage if prefs_for_storage else None,
        base_impression=base_impression,  # Always store, not just when preferences applied
        base_impression_model=base_model_used,
        refinement_model=refinement_model_used,
    )

    # ==========================================================================
    # Create EditHistory entry for this generation (audit trail)
    # ==========================================================================
    # Reuse edit distance computed for refinement trace
    generation_edit_distance = refinement_edit_distance

    # The model that produced `final_impression`: the refinement model when
    # preferences were applied, otherwise the base model.
    generation_model = refinement_model_used or base_model_used
    store_edit_history(
        user_id=user_id,
        case_id=case_id,
        original=base_impression,
        edited=final_impression,
        edit_distance=generation_edit_distance,
        source="generation",
        preferences_snapshot=prefs_for_storage if prefs_for_storage else None,
        generation_model=generation_model,
    )
    logger.info(f"Created EditHistory entry for generation: edit_distance={generation_edit_distance:.2f}")

    return GenerateImpressionResponse(
        impression=final_impression,
        base_impression=base_impression,
        preferences_used=len(similar_prefs),
        preferences_applied=applied_prefs,
        case_id=case_id,
        base_impression_model=base_model_used,
        refinement_model=refinement_model_used,
        trace=GenerationTrace(
            retrieval=retrieval_trace,
            base_generation_model=base_model_used,
            refinement=refinement_trace,
        ),
    ).model_dump()
