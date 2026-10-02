"""
User settings table operations.

Handles get/update/delete for per-user settings (model selection, data source, etc.).
"""

import time

from db.common import dynamodb, USER_SETTINGS_TABLE, logger


# Available models for validation
AVAILABLE_MODEL_KEYS = {"claude-opus-4.8", "claude-sonnet-4.6", "claude-haiku-4.5"}

# Retired keys still stored in some user settings -> current key.
# Keeps saved settings valid after a model bump.
_LEGACY_MODEL_ALIASES = {
    "claude-opus-4.6": "claude-opus-4.8",
    "claude-opus-4.5": "claude-opus-4.8",
}

# Short key aliases accepted from the frontend
_MODEL_SHORT_KEYS = {
    "opus": "claude-opus-4.8",
    "sonnet": "claude-sonnet-4.6",
    "haiku": "claude-haiku-4.5",
}


def _normalize_model_key(key: str) -> str:
    """Accept short keys ('sonnet'), retired keys, and full IDs ('claude-sonnet-4.6')."""
    key = _MODEL_SHORT_KEYS.get(key, key)
    return _LEGACY_MODEL_ALIASES.get(key, key)


# Default models for each agent
DEFAULT_AGENT_MODELS = {
    "base_impression": "claude-sonnet-4.6",
    "style_refinement": "claude-sonnet-4.6",
    "preference_inference": "claude-opus-4.8",
    "preference_validator": "claude-sonnet-4.6",
    "preference_edit_validator": "claude-haiku-4.5",
}

# k-NN settings
DEFAULT_K_PREFERENCES = 10
MIN_K_PREFERENCES = 1
MAX_K_PREFERENCES = 20

# Data source settings
VALID_DATA_SOURCES = {"synthetic", "mimic"}
DEFAULT_DATA_SOURCE = "synthetic"


def get_settings(user_id: str) -> dict:
    """Get user settings from DynamoDB. Returns defaults if not set."""
    table = dynamodb.Table(USER_SETTINGS_TABLE)

    response = table.get_item(Key={"user_id": user_id})
    item = response.get("Item")

    if not item:
        return {
            "clinical_interpretation": True,  # default ON for new users
            "model_settings": DEFAULT_AGENT_MODELS.copy(),
            "k_preferences": DEFAULT_K_PREFERENCES,
            "data_source": DEFAULT_DATA_SOURCE,
            "mimic_bucket": None,
        }

    stored_models = item.get("model_settings", {})
    model_settings = DEFAULT_AGENT_MODELS.copy()
    model_settings.update(stored_models)

    return {
        "clinical_interpretation": item.get("clinical_interpretation", True),
        "model_settings": model_settings,
        "k_preferences": int(item.get("k_preferences", DEFAULT_K_PREFERENCES)),
        "data_source": item.get("data_source", DEFAULT_DATA_SOURCE),
        "mimic_bucket": item.get("mimic_bucket"),
    }


def update_settings(user_id: str, settings: dict) -> dict:
    """Update user settings in DynamoDB.

    If data_source is changed, returns a flag indicating reset is needed.
    """
    table = dynamodb.Table(USER_SETTINGS_TABLE)

    update_parts = []
    expr_values = {}
    data_source_changed = False
    new_data_source = None
    new_mimic_bucket = None

    if "clinical_interpretation" in settings:
        update_parts.append("clinical_interpretation = :ci")
        expr_values[":ci"] = bool(settings["clinical_interpretation"])

    if "k_preferences" in settings:
        k = int(settings["k_preferences"])
        if k < MIN_K_PREFERENCES or k > MAX_K_PREFERENCES:
            return {"error": f"k_preferences must be between {MIN_K_PREFERENCES} and {MAX_K_PREFERENCES}"}
        update_parts.append("k_preferences = :kp")
        expr_values[":kp"] = k

    if "model_settings" in settings:
        model_settings = settings["model_settings"]
        if not isinstance(model_settings, dict):
            return {"error": "model_settings must be an object"}

        validated_models = {}
        for agent_name, model_key in model_settings.items():
            if agent_name not in DEFAULT_AGENT_MODELS:
                return {"error": f"Unknown agent: {agent_name}"}
            normalized_key = _normalize_model_key(model_key)
            if normalized_key not in AVAILABLE_MODEL_KEYS:
                return {"error": f"Unknown model: {model_key}. Valid options: {', '.join(sorted(AVAILABLE_MODEL_KEYS))}"}
            validated_models[agent_name] = normalized_key

        if validated_models:
            update_parts.append("model_settings = :ms")
            expr_values[":ms"] = validated_models

    if "data_source" in settings:
        new_data_source = settings["data_source"]
        if new_data_source not in VALID_DATA_SOURCES:
            return {"error": f"Invalid data_source: {new_data_source}. Valid options: {', '.join(sorted(VALID_DATA_SOURCES))}"}

        current_settings = get_settings(user_id)
        if new_data_source != current_settings.get("data_source"):
            data_source_changed = True

        update_parts.append("data_source = :ds")
        expr_values[":ds"] = new_data_source

    if "mimic_bucket" in settings:
        new_mimic_bucket = settings["mimic_bucket"]
        if new_mimic_bucket:
            if new_mimic_bucket.startswith("s3://"):
                bucket_path = new_mimic_bucket[5:]
                if "/" in bucket_path:
                    bucket_name = bucket_path.split("/")[0]
                else:
                    bucket_name = bucket_path
            else:
                bucket_name = new_mimic_bucket.split("/")[0] if "/" in new_mimic_bucket else new_mimic_bucket

            if not bucket_name:
                return {"error": "Invalid mimic_bucket format"}

            update_parts.append("mimic_bucket = :mb")
            expr_values[":mb"] = new_mimic_bucket
        else:
            update_parts.append("mimic_bucket = :mb")
            expr_values[":mb"] = None

    update_parts.append("updated_at = :ts")
    expr_values[":ts"] = int(time.time())

    if len(update_parts) == 1:  # Only timestamp
        return {"error": "No valid settings provided"}

    table.update_item(
        Key={"user_id": user_id},
        UpdateExpression="SET " + ", ".join(update_parts),
        ExpressionAttributeValues=expr_values,
    )

    result = {"message": "Settings updated successfully"}
    if data_source_changed:
        result["data_source_changed"] = True
        result["new_data_source"] = new_data_source
        result["mimic_bucket"] = new_mimic_bucket

    return result


def delete_user_settings(user_id: str) -> dict:
    """Delete user settings to restore defaults."""
    table = dynamodb.Table(USER_SETTINGS_TABLE)

    try:
        table.delete_item(Key={"user_id": user_id})
        logger.info(f"Deleted settings for user={user_id}")
        return {"message": "Settings deleted successfully"}
    except Exception as e:
        logger.error(f"Error deleting settings: {e}")
        return {"error": str(e)}
