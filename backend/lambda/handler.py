"""
Lambda Proxy for CIPHER Agent on AgentCore Runtime — Thin Router

Dispatches API Gateway requests to route handler modules via a route table.
Handles:
- Async edit processing events (invoked by Step Functions)
- Mark-edit-failed events (invoked by Step Functions catch state)
- CORS preflight
- JWT email claim extraction for user_id
- Route dispatch via ROUTE_TABLE
"""

import json
import logging
from typing import Any

from botocore.exceptions import ClientError

from db import update_edit_job_status
from routes.cases import handle_get_cases, handle_get_case_detail, handle_update_case
from routes.preferences import (
    handle_get_preferences,
    handle_get_rejected_preferences,
    handle_delete_preference,
    handle_update_preference,
)
from routes.generation import handle_generate
from routes.edit import handle_post_edit, handle_get_edit_status, handle_async_edit_processing
from routes.settings import handle_get_settings, handle_update_settings, handle_validate_bucket, handle_reset
from utils import create_error_response, create_success_response, get_user_email

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Route table: maps API Gateway route keys to handler functions
# All handlers have signature: (user_email: str, path_params: dict, event: dict) -> dict
ROUTE_TABLE = {
    "GET /cases": handle_get_cases,
    "GET /cases/{caseId}": handle_get_case_detail,
    "PUT /cases/{caseId}": handle_update_case,
    "GET /preferences": handle_get_preferences,
    "GET /preferences/rejected": handle_get_rejected_preferences,
    "DELETE /preferences/{preferenceId}": handle_delete_preference,
    "PUT /preferences/{preferenceId}": handle_update_preference,
    "POST /generate": handle_generate,
    "POST /edit": handle_post_edit,
    "GET /edit/{editId}/status": handle_get_edit_status,
    "GET /settings": handle_get_settings,
    "PUT /settings": handle_update_settings,
    "POST /settings/validate-bucket": handle_validate_bucket,
    "POST /settings/reset": handle_reset,
}


def handler(event: dict, context: Any) -> dict:
    """Lambda handler for API Gateway HTTP API."""
    try:
        # Handle async edit processing (invoked by Step Functions or Lambda self-invoke)
        if event.get("async_edit_processing"):
            return handle_async_edit_processing(event)

        # Handle mark-edit-failed (invoked by Step Functions catch state)
        if event.get("mark_edit_failed"):
            return update_edit_job_status(
                event["user_id"], event["edit_id"], "failed",
                {"error_message": event.get("error_message", "Processing failed")}
            )

        # Handle CORS preflight
        http_method = event.get("requestContext", {}).get("http", {}).get("method", "")
        if http_method == "OPTIONS":
            return create_success_response({})

        # Extract user email from JWT
        user_email = get_user_email(event)
        if not user_email:
            logger.warning("No email claim found in JWT")
            return create_error_response(401, "UNAUTHORIZED", "Missing email claim in token")

        # Dispatch via route table
        route_key = event.get("routeKey", "")
        path_params = event.get("pathParameters") or {}

        logger.info(f"Request: route={route_key}, user={user_email}")

        route_handler = ROUTE_TABLE.get(route_key)
        if route_handler:
            return route_handler(user_email, path_params, event)

        return create_error_response(404, "NOT_FOUND", f"Unknown route: {route_key}")

    except ClientError as e:
        error_code = e.response.get("Error", {}).get("Code", "Unknown")
        error_message = e.response.get("Error", {}).get("Message", str(e))
        logger.error(f"AWS ClientError: {error_code} - {error_message}")

        if error_code == "ThrottlingException":
            return create_error_response(429, "RATE_LIMITED", "Request rate exceeded. Please retry later.")
        elif error_code == "AccessDeniedException":
            return create_error_response(500, "INTERNAL_ERROR", "Service configuration error")
        else:
            # Do not surface raw AWS error text to clients — it can leak internal
            # detail (table/resource names, ARNs). Full detail is logged above.
            return create_error_response(500, "INTERNAL_ERROR", "An internal error occurred")

    except json.JSONDecodeError as e:
        logger.error(f"JSON decode error from agent: {e}")
        return create_error_response(500, "INTERNAL_ERROR", "Invalid response from agent")

    except Exception as e:
        logger.error(f"Unexpected error: {e}", exc_info=True)
        return create_error_response(500, "INTERNAL_ERROR", "An unexpected error occurred")
