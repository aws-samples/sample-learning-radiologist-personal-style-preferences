"""
Preference route handlers.

GET /preferences, GET /preferences/rejected, DELETE /preferences/{preferenceId},
PUT /preferences/{preferenceId}
"""

import json
import logging

from pydantic import ValidationError

from agent_client import invoke_agent
from db import get_preferences, delete_preference, update_preference, get_rejected_preferences
from models import UpdatePreferenceRequest
from safety import detect_prompt_injection, is_content_adding_preference
from utils import (
    DecimalEncoder,
    create_error_response,
    create_success_response,
    validate_string,
    MAX_CASE_ID_LENGTH,
)

logger = logging.getLogger(__name__)


def handle_get_preferences(user_email: str, path_params: dict, event: dict) -> dict:
    """GET /preferences — list all learned preferences."""
    result = get_preferences(user_email)
    return create_success_response(
        json.loads(json.dumps(result, cls=DecimalEncoder))
    )


def handle_get_rejected_preferences(user_email: str, path_params: dict, event: dict) -> dict:
    """GET /preferences/rejected — list rejected changes (audit trail)."""
    result = get_rejected_preferences(user_email)
    return create_success_response(
        json.loads(json.dumps(result, cls=DecimalEncoder))
    )


def handle_delete_preference(user_email: str, path_params: dict, event: dict) -> dict:
    """DELETE /preferences/{preferenceId} — delete a learned preference."""
    preference_id = path_params.get("preferenceId")
    error = validate_string(preference_id, "preferenceId", MAX_CASE_ID_LENGTH)
    if error:
        return create_error_response(400, "VALIDATION_ERROR", error)

    result = delete_preference(user_email, preference_id)
    if "error" in result:
        return create_error_response(404, "NOT_FOUND", result["error"])
    return create_success_response(result)


def handle_update_preference(user_email: str, path_params: dict, event: dict) -> dict:
    """PUT /preferences/{preferenceId} — update preference text with 3-layer safety validation."""
    preference_id = path_params.get("preferenceId")
    error = validate_string(preference_id, "preferenceId", MAX_CASE_ID_LENGTH)
    if error:
        return create_error_response(400, "VALIDATION_ERROR", error)

    try:
        body = json.loads(event.get("body") or "{}")
        pref_request = UpdatePreferenceRequest(**body)
    except json.JSONDecodeError:
        return create_error_response(400, "VALIDATION_ERROR", "Invalid JSON body")
    except ValidationError as e:
        return create_error_response(400, "VALIDATION_ERROR", str(e.errors()[0]["msg"]))

    new_preference_text = pref_request.preference_text

    # Safety check 1: Prompt injection detection
    is_injection, pattern = detect_prompt_injection(new_preference_text)
    if is_injection:
        logger.warning(f"Prompt injection in preference edit: user={user_email}, pattern={pattern}")
        return create_error_response(400, "SAFETY_VIOLATION", "Edit rejected by safety filter")

    # Safety check 2: Keyword filtering (fast heuristic)
    is_content_adding, keyword = is_content_adding_preference(new_preference_text)
    if is_content_adding:
        logger.warning(f"Content-adding preference edit blocked: user={user_email}, keyword={keyword}")
        return create_error_response(
            400,
            "SAFETY_VIOLATION",
            f"Edit rejected: contains content-adding keyword '{keyword}'. Only stylistic preferences are allowed."
        )

    # Safety check 3: Validator Agent (LLM-based validation)
    result = invoke_agent(
        "validate_preference",
        user_email,
        preference_text=new_preference_text,
    )
    if "error" in result:
        return create_error_response(500, "AGENT_ERROR", result["error"])

    if not result.get("is_stylistic", False):
        reason = result.get("reason", "Preference appears to add clinical content")
        logger.warning(f"Preference edit failed validation: user={user_email}, reason={reason}")
        return create_error_response(
            400,
            "SAFETY_VIOLATION",
            f"Edit rejected: {reason}"
        )

    # All safety checks passed - update the preference
    update_result = update_preference(user_email, preference_id, new_preference_text)
    if "error" in update_result:
        return create_error_response(404, "NOT_FOUND", update_result["error"])
    return create_success_response(update_result)
