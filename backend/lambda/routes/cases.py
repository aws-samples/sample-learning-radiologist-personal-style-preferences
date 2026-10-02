"""
Case route handlers.

GET /cases, GET /cases/{caseId}, PUT /cases/{caseId}
"""

import json

from pydantic import ValidationError

from db import get_cases, get_case_detail, update_case
from models import UpdateCaseRequest
from utils import (
    DecimalEncoder,
    create_error_response,
    create_success_response,
    validate_string,
    MAX_CASE_ID_LENGTH,
)


def handle_get_cases(user_email: str, path_params: dict, event: dict) -> dict:
    """GET /cases — list all cases for user."""
    result = get_cases(user_email)
    return create_success_response(
        json.loads(json.dumps(result, cls=DecimalEncoder))
    )


def handle_get_case_detail(user_email: str, path_params: dict, event: dict) -> dict:
    """GET /cases/{caseId} — get full case details."""
    case_id = path_params.get("caseId")
    error = validate_string(case_id, "caseId", MAX_CASE_ID_LENGTH)
    if error:
        return create_error_response(400, "VALIDATION_ERROR", error)

    result = get_case_detail(user_email, case_id)
    if "error" in result:
        return create_error_response(404, "NOT_FOUND", result["error"])
    return create_success_response(
        json.loads(json.dumps(result, cls=DecimalEncoder))
    )


def handle_update_case(user_email: str, path_params: dict, event: dict) -> dict:
    """PUT /cases/{caseId} — update case findings."""
    case_id = path_params.get("caseId")
    error = validate_string(case_id, "caseId", MAX_CASE_ID_LENGTH)
    if error:
        return create_error_response(400, "VALIDATION_ERROR", error)

    try:
        body = json.loads(event.get("body") or "{}")
        request = UpdateCaseRequest(**body)
    except json.JSONDecodeError:
        return create_error_response(400, "VALIDATION_ERROR", "Invalid JSON body")
    except ValidationError as e:
        return create_error_response(400, "VALIDATION_ERROR", str(e.errors()[0]["msg"]))

    result = update_case(user_email, case_id, request.findings)
    if "error" in result:
        return create_error_response(404, "NOT_FOUND", result["error"])
    return create_success_response(result)
