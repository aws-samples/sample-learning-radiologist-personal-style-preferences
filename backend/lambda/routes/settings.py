"""
Settings route handlers.

GET /settings, PUT /settings, POST /settings/validate-bucket, POST /settings/reset
"""

import json
import logging

from pydantic import ValidationError

from db import (
    get_settings,
    update_settings,
    delete_user_settings,
    validate_mimic_bucket_access,
    reset_user_data,
    load_synthetic_cases,
    load_mimic_cases,
)
from models import UpdateSettingsRequest, ValidateBucketRequest
from utils import create_error_response, create_success_response

logger = logging.getLogger(__name__)


def handle_get_settings(user_email: str, path_params: dict, event: dict) -> dict:
    """GET /settings — get user settings."""
    result = get_settings(user_email)
    return create_success_response(result)


def handle_update_settings(user_email: str, path_params: dict, event: dict) -> dict:
    """PUT /settings — update user settings."""
    try:
        body = json.loads(event.get("body") or "{}")
        UpdateSettingsRequest(**body)
    except json.JSONDecodeError:
        return create_error_response(400, "VALIDATION_ERROR", "Invalid JSON body")
    except ValidationError as e:
        return create_error_response(400, "VALIDATION_ERROR", str(e.errors()[0]["msg"]))

    # If switching to MIMIC, validate bucket access first
    if body.get("data_source") == "mimic":
        mimic_bucket = body.get("mimic_bucket")
        if not mimic_bucket:
            return create_error_response(400, "VALIDATION_ERROR", "mimic_bucket is required when data_source is 'mimic'")

        bucket_validation = validate_mimic_bucket_access(mimic_bucket)
        if not bucket_validation.get("valid"):
            return create_error_response(400, "VALIDATION_ERROR", f"Cannot access MIMIC bucket: {bucket_validation.get('error')}")

    result = update_settings(user_email, body)
    if "error" in result:
        return create_error_response(400, "VALIDATION_ERROR", result["error"])

    # If data source changed, reset user data and reload cases
    if result.get("data_source_changed"):
        new_source = result.get("new_data_source")
        logger.info(f"Data source changed to {new_source} for user={user_email}, resetting data")

        reset_result = reset_user_data(user_email)
        logger.info(f"Reset result: {reset_result}")

        if new_source == "synthetic":
            load_result = load_synthetic_cases(user_email)
            result["data_reset"] = True
            result["cases_loaded"] = load_result.get("cases_loaded", 0)
            if "error" in load_result:
                result["load_warning"] = load_result["error"]
        elif new_source == "mimic":
            mimic_bucket = result.get("mimic_bucket") or body.get("mimic_bucket")
            if mimic_bucket:
                load_result = load_mimic_cases(user_email, mimic_bucket)
                result["data_reset"] = True
                result["cases_loaded"] = load_result.get("cases_loaded", 0)
                if "error" in load_result:
                    result["load_warning"] = load_result["error"]
            else:
                result["data_reset"] = True
                result["cases_loaded"] = 0
                result["note"] = "MIMIC bucket not configured - no cases loaded"

    return create_success_response(result)


def handle_validate_bucket(user_email: str, path_params: dict, event: dict) -> dict:
    """POST /settings/validate-bucket — validate MIMIC bucket access."""
    try:
        body = json.loads(event.get("body", "{}"))
        bucket_request = ValidateBucketRequest(**body)
    except json.JSONDecodeError:
        return create_error_response(400, "VALIDATION_ERROR", "Invalid JSON body")
    except ValidationError as e:
        return create_error_response(400, "VALIDATION_ERROR", str(e.errors()[0]["msg"]))

    result = validate_mimic_bucket_access(bucket_request.bucket)
    return create_success_response(result)


def handle_reset(user_email: str, path_params: dict, event: dict) -> dict:
    """POST /settings/reset — reset app to defaults."""
    logger.info(f"Resetting app to defaults for user={user_email}")

    reset_result = reset_user_data(user_email)
    logger.info(f"Reset result: {reset_result}")

    delete_user_settings(user_email)

    load_result = load_synthetic_cases(user_email)

    return create_success_response({
        "message": "App reset to defaults successfully",
        "data_reset": True,
        "settings_reset": True,
        "cases_loaded": load_result.get("cases_loaded", 0),
    })
