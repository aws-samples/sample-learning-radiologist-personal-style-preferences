"""
Shared configuration for CIPHER backend.

Centralizes all configuration constants to avoid magic numbers and ensure
consistency across agent modules.
"""

import os

from shared.validation_limits import MAX_FINDINGS_LENGTH, MAX_IMPRESSION_LENGTH, MAX_CASE_ID_LENGTH


# =============================================================================
# Model Configuration
# =============================================================================

# Available Claude models for user selection
# Keys are user-friendly names, values are Bedrock model IDs (global inference profiles)
AVAILABLE_MODELS = {
    "claude-opus-4.8": "global.anthropic.claude-opus-4-8",
    "claude-sonnet-4.6": "global.anthropic.claude-sonnet-4-6",
    "claude-haiku-4.5": "global.anthropic.claude-haiku-4-5-20251001-v1:0",
}

# Aliases for retired model keys still present in stored user settings.
# Maps old key -> current key so saved preferences keep resolving after a bump.
LEGACY_MODEL_ALIASES = {
    "claude-opus-4.6": "claude-opus-4.8",
    "claude-opus-4.5": "claude-opus-4.8",
}

# Default models for each agent (user can override via settings)
DEFAULT_MODELS = {
    "base_impression": "claude-sonnet-4.6",
    "style_refinement": "claude-sonnet-4.6",
    "preference_inference": "claude-opus-4.8",  # Opus for better preference extraction
    "preference_validator": "claude-sonnet-4.6",  # Sonnet for thorough validation
    "preference_edit_validator": "claude-haiku-4.5",
}

# Bedrock model IDs that REJECT sampling params (temperature/top_p/top_k) with a 400.
# Opus 4.7+ and Fable removed these; Sonnet 4.6 / Haiku 4.5 still accept them.
_NO_SAMPLING_PARAM_MARKERS = ("claude-opus-4-7", "claude-opus-4-8", "claude-fable")


def supports_temperature(model_id: str) -> bool:
    """Whether a Bedrock model accepts a `temperature` argument.

    Opus 4.7+ and Fable return a 400 if `temperature`/`top_p`/`top_k` are sent;
    callers must omit those params for these models.

    Args:
        model_id: Full Bedrock model ID / inference-profile ID.

    Returns:
        True if temperature may be passed, False if it must be omitted.
    """
    return not any(marker in model_id for marker in _NO_SAMPLING_PARAM_MARKERS)

# Legacy constant for backward compatibility (uses default base_impression model)
MODEL_ID = AVAILABLE_MODELS[DEFAULT_MODELS["base_impression"]]

# Cohere Embed v4 for embeddings
COHERE_EMBED_MODEL_ID = "cohere.embed-v4:0"

# Embedding dimensions (Cohere supports 256, 512, 1024, 1536)
EMBED_OUTPUT_DIMENSION = 1024


def get_model_id(agent_name: str, user_settings: dict = None) -> str:
    """Get the Bedrock model ID for a given agent.

    Args:
        agent_name: Name of the agent (base_impression, style_refinement, etc.)
        user_settings: Optional user model settings dict with agent_name -> model_key mappings

    Returns:
        Bedrock model ID string
    """
    # Get user's chosen model key, or fall back to default
    if user_settings and agent_name in user_settings:
        model_key = user_settings[agent_name]
    else:
        model_key = DEFAULT_MODELS.get(agent_name, "claude-sonnet-4.6")

    # Resolve retired keys still stored in user settings (e.g. claude-opus-4.6)
    model_key = LEGACY_MODEL_ALIASES.get(model_key, model_key)

    # Convert model key to actual Bedrock model ID
    return AVAILABLE_MODELS.get(model_key, AVAILABLE_MODELS["claude-sonnet-4.6"])


# =============================================================================
# Safety Thresholds
# =============================================================================

# Minimum confidence score for a preference to be accepted
# Below this, the preference is likely content-adding rather than stylistic
CONFIDENCE_REJECTION_THRESHOLD = 0.3

# Maximum ratio of refined impression length to base impression length
# If refinement is >50% longer, it likely added content (safety check)
MAX_REFINEMENT_LENGTH_RATIO = 1.5

# Minimum normalized edit distance to trigger preference inference
# Edits smaller than 2% are likely typo fixes, not style preferences
MIN_EDIT_DISTANCE_FOR_PREFERENCE = 0.02


# =============================================================================
# DynamoDB Table Names
# =============================================================================

def _get_required_env(name: str, default: str = None) -> str:
    """Get environment variable, using default for agent (non-Lambda) context."""
    value = os.environ.get(name, default)
    if value is None:
        raise EnvironmentError(f"Required environment variable {name} not set")
    return value


# Table names - defaults provided for agent context, Lambda sets via environment
CASES_TABLE = _get_required_env("CASES_TABLE", "radiologist-cases")
EDIT_HISTORY_TABLE = _get_required_env("EDIT_HISTORY_TABLE", "radiologist-edit-history")
PREFERENCES_TABLE = _get_required_env("PREFERENCES_TABLE", "radiologist-preferences")
REJECTED_PREFERENCES_TABLE = _get_required_env("REJECTED_PREFERENCES_TABLE", "radiologist-rejected-preferences")


# =============================================================================
# AWS Region
# =============================================================================

AWS_REGION = os.environ.get("AWS_REGION", "us-east-1")


# =============================================================================
# k-NN Retrieval
# =============================================================================

# Default number of similar preferences to retrieve for generation
# User can override via settings (range: 1-20)
DEFAULT_K_NEAREST_PREFERENCES = 10
MIN_K_PREFERENCES = 1
MAX_K_PREFERENCES = 20

# Legacy constant for backward compatibility
K_NEAREST_PREFERENCES = DEFAULT_K_NEAREST_PREFERENCES


def get_k_preferences(user_settings: dict = None) -> int:
    """Get the k value for k-NN preference retrieval.

    Args:
        user_settings: Optional user settings dict with 'k_preferences' key

    Returns:
        Number of preferences to retrieve (clamped to valid range)
    """
    if user_settings and "k_preferences" in user_settings:
        k = int(user_settings["k_preferences"])
        return max(MIN_K_PREFERENCES, min(MAX_K_PREFERENCES, k))
    return DEFAULT_K_NEAREST_PREFERENCES
