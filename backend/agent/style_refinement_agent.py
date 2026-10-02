"""
Agent 2: Style Refinement Agent

Applies user's style preferences to an existing impression.
Can ONLY modify existing text - cannot add new clinical content.

This is the second stage of the two-stage generation pipeline.
The key safety property: this agent does NOT have access to the original findings,
so it cannot add clinical content - only restyle what's already there.
"""

import logging

from strands import Agent
from strands.models import BedrockModel

from config import MODEL_ID, MAX_REFINEMENT_LENGTH_RATIO, get_model_id, supports_temperature

logger = logging.getLogger(__name__)


SYSTEM_PROMPT = """You are a medical text editor that refines radiology impressions to match a user's style preferences.

CRITICAL RULES - YOU MUST FOLLOW THESE:
=======================================
1. You may ONLY MODIFY existing text in the impression
2. You may NEVER ADD new sentences, findings, or clinical statements
3. You may NEVER REMOVE clinically significant information
4. You may NEVER add content that isn't already in the impression

ALLOWED MODIFICATIONS:
- Terminology changes (e.g., "opacity" → "consolidation")
- Formatting changes (e.g., paragraph → bullet points)
- Phrasing changes (e.g., "no evidence of X" → "X is absent")
- Reordering existing content
- Combining or splitting existing sentences
- Adjusting verbosity (more concise or more detailed) of EXISTING content

NOT ALLOWED:
- Adding new findings or diagnoses
- Adding "No acute cardiopulmonary disease" or similar unless already present
- Adding recommendations or follow-up suggestions
- Adding any clinical content not in the original impression

You will be shown examples of how the user has edited impressions in the past.
Apply similar stylistic changes to the current impression.

IMPORTANT: Formatting preferences (like bullet points, numbered lists) should be applied
to ALL impressions regardless of their specific content. If the user prefers bullet points
in one impression, they want bullet points in all impressions.

Output only the refined impression text, no explanations."""


# Cache for agents by model_id
_agents: dict[str, Agent] = {}


def get_style_refinement_agent(model_id: str = None) -> Agent:
    """Get or create the style refinement agent.

    Args:
        model_id: Optional Bedrock model ID. If not provided, uses default.

    Returns:
        Agent configured for style refinement
    """
    global _agents

    actual_model_id = model_id or MODEL_ID

    if actual_model_id not in _agents:
        model_kwargs = {"model_id": actual_model_id, "max_tokens": 2048}
        if supports_temperature(actual_model_id):
            model_kwargs["temperature"] = 0.2  # Low temperature for consistent output
        model = BedrockModel(**model_kwargs)
        _agents[actual_model_id] = Agent(
            model=model,
            system_prompt=SYSTEM_PROMPT,
            callback_handler=None,
        )

    return _agents[actual_model_id]


def _format_preference_examples(preferences: list[dict]) -> str:
    """
    Format preferences as before/after examples for the refinement agent.

    Args:
        preferences: List of preference dicts with traceability fields

    Returns:
        Formatted string showing original → edited examples
    """
    if not preferences:
        return "No style examples available."

    examples = []
    for i, pref in enumerate(preferences, 1):
        original = pref.get("original_impression")
        edited = pref.get("edited_impression")
        pref_text = pref.get("preference_text", "")

        if original and edited:
            # Show as concrete example
            examples.append(f"""Example {i}:
  Before: "{original[:200]}{'...' if len(original) > 200 else ''}"
  After:  "{edited[:200]}{'...' if len(edited) > 200 else ''}"
  Change: {pref_text}""")
        elif pref_text:
            # Fallback to just the preference text
            examples.append(f"""Example {i}: {pref_text}""")

    if not examples:
        return "No style examples available."

    return "\n\n".join(examples)


def refine_impression(
    base_impression: str,
    preferences: list[dict],
    model_id: str = None
) -> tuple[str, str]:
    """
    Refine an impression to match user's style preferences.

    This agent can only MODIFY the base impression - it cannot ADD content
    because it doesn't have access to the original findings.

    Args:
        base_impression: The grounded impression from Agent 1
        preferences: List of user's past edit examples (with traceability)
        model_id: Optional Bedrock model ID to use

    Returns:
        Tuple of (refined_impression_text, model_id_used)
    """
    actual_model_id = model_id or MODEL_ID

    logger.info(f"=== STYLE REFINEMENT START ===")
    logger.info(f"Base impression ({len(base_impression)} chars): {base_impression[:100]}...")
    logger.info(f"Preferences received: {len(preferences)}")

    if not preferences:
        # No preferences to apply
        logger.info("No preferences to apply - returning base unchanged")
        return base_impression, actual_model_id

    # Log each preference
    for i, pref in enumerate(preferences):
        logger.info(f"Preference {i+1}: {pref.get('preference_text', 'N/A')[:80]}...")
        logger.info(f"  - Has original_impression: {bool(pref.get('original_impression'))}")
        logger.info(f"  - Has edited_impression: {bool(pref.get('edited_impression'))}")

    examples = _format_preference_examples(preferences)
    logger.info(f"Formatted examples:\n{examples[:500]}...")

    prompt = f"""Refine this radiology impression to match the user's style preferences.

**Original Impression to Refine:**
{base_impression}

**User's Style Preferences (shown as past edits):**
{examples}

**Instructions:**
- Apply similar stylistic changes where appropriate
- Do NOT add any new clinical content or findings
- If no changes apply, return the original unchanged

**Refined Impression:**"""

    agent = get_style_refinement_agent(model_id=actual_model_id)
    logger.info(f"Calling style refinement agent with model: {actual_model_id}")
    response = agent(prompt)

    # Clean up the response
    refined = str(response).strip()
    logger.info(f"Raw response ({len(refined)} chars): {refined[:200]}...")

    # Remove common prefixes
    prefixes = ["refined impression:", "**refined impression:**", "impression:"]
    refined_lower = refined.lower()
    for prefix in prefixes:
        if refined_lower.startswith(prefix):
            refined = refined[len(prefix):].strip()
            refined_lower = refined.lower()

    # Safety check: if the refined version is significantly longer, something went wrong
    # (agent might have added content). Fall back to base.
    if len(refined) > len(base_impression) * MAX_REFINEMENT_LENGTH_RATIO:
        logger.warning(f"Refined too long ({len(refined)} > {len(base_impression) * MAX_REFINEMENT_LENGTH_RATIO}) - falling back to base")
        return base_impression, actual_model_id

    # Log comparison
    changed = refined != base_impression
    logger.info(f"=== STYLE REFINEMENT RESULT ===")
    logger.info(f"Changed: {changed}")
    if changed:
        logger.info(f"Base: {base_impression[:100]}...")
        logger.info(f"Refined: {refined[:100]}...")
    logger.info(f"=== STYLE REFINEMENT END ===")

    return refined, actual_model_id
