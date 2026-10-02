"""
User Settings Operations for Agent

Provides settings retrieval for model selection and other user preferences.
Settings are stored in the UserSettings DynamoDB table.
"""

import logging
import os

import boto3

from config import AWS_REGION, DEFAULT_MODELS


logger = logging.getLogger(__name__)

# Table name - defaults provided for agent context
USER_SETTINGS_TABLE = os.environ.get("USER_SETTINGS_TABLE", "radiologist-user-settings")

# DynamoDB resource (reused across invocations)
dynamodb = boto3.resource("dynamodb", region_name=AWS_REGION)


def get_user_model_settings(user_id: str) -> dict:
    """
    Get user's model settings for each agent.

    Args:
        user_id: User identifier

    Returns:
        Dict mapping agent names to model keys (e.g., {"base_impression": "claude-sonnet-4.5"})
    """
    logger.debug(f"Fetching model settings for user={user_id}")
    table = dynamodb.Table(USER_SETTINGS_TABLE)

    try:
        response = table.get_item(Key={"user_id": user_id})
        item = response.get("Item")

        if not item or "model_settings" not in item:
            logger.debug(f"No model settings found for user={user_id}, using defaults")
            return DEFAULT_MODELS.copy()

        # Merge stored settings with defaults (in case new agents are added)
        stored = item.get("model_settings", {})
        settings = DEFAULT_MODELS.copy()
        settings.update(stored)

        logger.debug(f"Loaded model settings for user={user_id}: {settings}")
        return settings

    except Exception as e:
        logger.warning(f"Error loading model settings for user={user_id}: {e}, using defaults")
        return DEFAULT_MODELS.copy()
