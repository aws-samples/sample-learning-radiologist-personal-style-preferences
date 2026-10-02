"""
Agent 1: Base Impression Generator

Generates a grounded radiology impression from findings ONLY.
No knowledge of user preferences - ensures output is purely based on clinical content.

This is the first stage of the two-stage generation pipeline.
"""

from strands import Agent
from strands.models import BedrockModel

from config import MODEL_ID, get_model_id, AVAILABLE_MODELS, supports_temperature


# Strict grounding mode - no interpretations beyond what's stated
SYSTEM_PROMPT_STRICT = """You are an expert radiologist generating impressions from radiology findings.

Your task is to synthesize the findings into a concise impression.

STRICT GROUNDING RULES:
=======================
1. Use ONLY words, terms, and concepts that appear in the findings
2. Do NOT add clinical interpretations or inferences
3. Do NOT explain the significance of findings
4. Do NOT mention conditions/diseases unless explicitly named in findings
5. Do NOT add treatment recommendations
6. Do NOT add follow-up suggestions
7. Do NOT add differential diagnoses

EXAMPLES OF VIOLATIONS (DO NOT DO THIS):
- Findings say "No focal consolidation" → Do NOT write "No consolidation to suggest pneumonia"
- Findings say "Bilateral effusions" → Do NOT write "Bilateral effusions, possibly infectious"
- Findings say "Cardiomegaly" → Do NOT write "Cardiomegaly suggesting heart failure"

CORRECT APPROACH:
- Restate the findings in impression format without adding interpretation
- "No focal consolidation" → "No focal consolidation" (keep as-is)
- Summarize and organize, but do not interpret

Your output will be refined for style in a later step, so focus purely on:
- Accuracy (use only what's in the findings)
- Completeness (don't omit significant findings)
- Standard radiology terminology (but only terms from findings)
- Logical organization (most significant findings first)

Output only the impression text, no preamble or explanation."""


# Clinical interpretation mode - allows standard radiological inferences
SYSTEM_PROMPT_INTERPRETATION = """You are an expert radiologist generating impressions from radiology findings.

Your task is to synthesize the findings into a concise, clinically relevant impression.

RULES:
======
1. Generate from the provided findings
2. You MAY add standard clinical interpretations (e.g., "no consolidation to suggest pneumonia")
3. You MAY note clinical significance of findings
4. Include all clinically significant findings
5. Do NOT add treatment recommendations
6. Do NOT add follow-up suggestions unless explicitly in findings
7. Do NOT add differential diagnoses unless clearly supported by findings
8. Use standard radiology terminology

Your output will be refined for style in a later step, so focus purely on:
- Clinical accuracy
- Completeness (don't omit significant findings)
- Appropriate medical terminology
- Logical organization (most significant findings first)

Output only the impression text, no preamble or explanation."""


# Cache for agents by model_id + mode
_agents: dict[tuple[str, bool], Agent] = {}


def get_base_impression_agent(clinical_interpretation: bool = False, model_id: str = None) -> Agent:
    """Get or create the base impression generation agent.

    Args:
        clinical_interpretation: Whether to allow clinical inferences
        model_id: Optional Bedrock model ID. If not provided, uses default.

    Returns:
        Agent configured for base impression generation
    """
    global _agents

    # Use provided model_id or default
    actual_model_id = model_id or MODEL_ID

    # Cache key includes both model and mode
    cache_key = (actual_model_id, clinical_interpretation)

    if cache_key not in _agents:
        model_kwargs = {"model_id": actual_model_id, "max_tokens": 2048}
        if supports_temperature(actual_model_id):
            model_kwargs["temperature"] = 0.2  # Low temperature for consistent generation
        model = BedrockModel(**model_kwargs)
        system_prompt = SYSTEM_PROMPT_INTERPRETATION if clinical_interpretation else SYSTEM_PROMPT_STRICT
        _agents[cache_key] = Agent(
            model=model,
            system_prompt=system_prompt,
            callback_handler=None,
        )

    return _agents[cache_key]


def generate_base_impression(
    findings: str,
    clinical_interpretation: bool = False,
    model_id: str = None
) -> tuple[str, str]:
    """
    Generate a base impression from findings only.

    This impression is grounded purely in the findings with no style preferences.
    It will be refined by the Style Refinement Agent in the next stage.

    Args:
        findings: Radiology findings text
        clinical_interpretation: If True, allow standard clinical inferences
        model_id: Optional Bedrock model ID to use

    Returns:
        Tuple of (base_impression_text, model_id_used)
    """
    # Determine which model to use
    actual_model_id = model_id or MODEL_ID

    prompt = f"""Generate a radiology impression from these findings.

**Findings:**
{findings}

**Impression:**"""

    agent = get_base_impression_agent(clinical_interpretation, model_id=actual_model_id)
    response = agent(prompt)

    # Clean up the response
    impression = str(response).strip()

    # Remove common prefixes
    prefixes = ["impression:", "**impression:**", "**impression**:"]
    impression_lower = impression.lower()
    for prefix in prefixes:
        if impression_lower.startswith(prefix):
            impression = impression[len(prefix):].strip()
            impression_lower = impression.lower()

    return impression, actual_model_id
