"""
Edit route handlers.

POST /edit — start async edit processing (preference extraction).
GET /edit/{editId}/status — poll for async edit completion.
handle_async_edit_processing — background processing handler.
"""

import json
import logging
import os
import uuid

import boto3
from pydantic import ValidationError

from agent_client import invoke_agent
from db import (
    save_edit_job,
    get_edit_job_status,
    update_edit_job_status,
    check_idempotency,
    claim_idempotency_key,
    store_idempotency_result,
)
from models import EditRequest
from safety import detect_prompt_injection
from utils import create_error_response, create_success_response

logger = logging.getLogger(__name__)


def handle_post_edit(user_email: str, path_params: dict, event: dict) -> dict:
    """POST /edit — save edit and start async preference extraction."""
    try:
        body = json.loads(event.get("body") or "{}")
        edit_request = EditRequest(**body)
    except json.JSONDecodeError:
        return create_error_response(400, "VALIDATION_ERROR", "Invalid JSON body")
    except ValidationError as e:
        return create_error_response(400, "VALIDATION_ERROR", str(e.errors()[0]["msg"]))

    case_id = edit_request.case_id
    original_impression = edit_request.original_impression
    edited_impression = edit_request.edited_impression
    findings = edit_request.findings
    idempotency_key = edit_request.idempotency_key

    # Idempotency check (if key provided)
    if idempotency_key:
        cached = check_idempotency(user_email, idempotency_key)
        if cached:
            if cached.get("_idempotency_status") == "processing":
                return create_error_response(409, "CONFLICT", "Request is already being processed")
            logger.info(f"Idempotency cache hit for edit: user={user_email}")
            return create_success_response(cached)

        if not claim_idempotency_key(user_email, idempotency_key):
            return create_error_response(409, "CONFLICT", "Duplicate request")

    # Generate unique edit ID
    edit_id = f"edit_{uuid.uuid4().hex[:12]}"

    # Check for prompt injection (flag it but still process)
    has_injection, pattern = detect_prompt_injection(edited_impression)
    if has_injection:
        logger.warning(f"Prompt injection detected in edit: user={user_email}, pattern={pattern}")

    # Save job to DynamoDB with "processing" status
    job_result = save_edit_job(
        user_email, edit_id, case_id,
        original_impression, edited_impression, findings
    )
    if "error" in job_result:
        return create_error_response(500, "DATABASE_ERROR", job_result["error"])

    # Trigger async processing via Step Functions
    sfn_client = boto3.client("stepfunctions")
    state_machine_arn = os.environ.get("EDIT_STATE_MACHINE_ARN")

    # Step Functions input: the Lambda event payload for async processing
    sfn_input = {
        "async_edit_processing": True,
        "user_id": user_email,
        "edit_id": edit_id,
        "case_id": case_id,
        "original_impression": original_impression,
        "edited_impression": edited_impression,
        "findings": findings,
        "has_injection": has_injection,
    }

    try:
        sfn_client.start_execution(
            stateMachineArn=state_machine_arn,
            name=edit_id,  # Use edit_id as execution name for traceability
            input=json.dumps(sfn_input),
        )
        logger.info(f"Started Step Functions execution for edit {edit_id}")
    except Exception as e:
        logger.error(f"Failed to start Step Functions execution: {e}")
        update_edit_job_status(user_email, edit_id, "failed", {"error_message": str(e)})
        return create_error_response(500, "ASYNC_ERROR", f"Failed to start processing: {e}")

    response = {
        "edit_id": edit_id,
        "status": "processing",
        "message": "Edit saved. Preference extraction in progress.",
        "poll_url": f"/edit/{edit_id}/status",
    }

    # Cache response for idempotency
    if idempotency_key:
        store_idempotency_result(user_email, idempotency_key, response)

    return create_success_response(response)


def handle_get_edit_status(user_email: str, path_params: dict, event: dict) -> dict:
    """GET /edit/{editId}/status — poll for async edit completion."""
    edit_id = path_params.get("editId")
    if not edit_id:
        return create_error_response(400, "VALIDATION_ERROR", "editId is required")

    result = get_edit_job_status(user_email, edit_id)
    if "error" in result and "not found" in result["error"].lower():
        return create_error_response(404, "NOT_FOUND", result["error"])
    if "error" in result:
        return create_error_response(500, "DATABASE_ERROR", result["error"])

    return create_success_response(result)


def handle_async_edit_processing(event: dict) -> dict:
    """Handle async edit processing (preference extraction).

    Invoked asynchronously by POST /edit via Step Functions.
    Runs the full preference extraction pipeline and updates the job status.
    """
    user_id = event.get("user_id")
    edit_id = event.get("edit_id")
    case_id = event.get("case_id")
    original_impression = event.get("original_impression")
    edited_impression = event.get("edited_impression")
    findings = event.get("findings")
    has_injection = event.get("has_injection", False)

    logger.info(f"Processing async edit {edit_id} for user={user_id}")

    try:
        result = invoke_agent(
            "save_edit",
            user_id,
            case_id=case_id,
            original_impression=original_impression,
            edited_impression=edited_impression,
            findings=findings,
        )

        if "error" in result:
            logger.error(f"Agent error for edit {edit_id}: {result['error']}")
            update_edit_job_status(user_id, edit_id, "failed", {
                "error_message": result["error"]
            })
            return {"status": "failed", "error": result["error"]}

        if has_injection:
            result["safety_warning"] = "Input contained suspicious patterns - preference learning may be affected"

        update_edit_job_status(user_id, edit_id, "completed", {
            "edit_distance": result.get("edit_distance", 0),
            "preference_inferred": result.get("preference_inferred", False),
            "preferences_saved": result.get("preferences_saved", []),
            "changes_rejected": result.get("changes_rejected", []),
            "summary": result.get("summary", "Edit processed successfully"),
            "safety_warning": result.get("safety_warning"),
        })

        logger.info(f"Completed async edit {edit_id}")
        return {"status": "completed", "edit_id": edit_id}

    except Exception as e:
        logger.error(f"Exception processing edit {edit_id}: {e}")
        update_edit_job_status(user_id, edit_id, "failed", {
            "error_message": str(e)
        })
        return {"status": "failed", "error": str(e)}
