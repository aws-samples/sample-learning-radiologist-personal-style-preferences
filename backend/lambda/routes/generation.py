"""
Generation route handler.

POST /generate — generate an impression from findings via AgentCore.
Supports optional idempotency keys to prevent duplicate processing.
"""

import json
import logging

from pydantic import ValidationError

from agent_client import invoke_agent
from db import get_settings, check_idempotency, claim_idempotency_key, store_idempotency_result
from models import GenerateRequest
from safety import detect_prompt_injection
from utils import create_error_response, create_success_response

logger = logging.getLogger(__name__)


def handle_generate(user_email: str, path_params: dict, event: dict) -> dict:
    """POST /generate — generate impression from findings."""
    try:
        body = json.loads(event.get("body") or "{}")
        gen_request = GenerateRequest(**body)
    except json.JSONDecodeError:
        return create_error_response(400, "VALIDATION_ERROR", "Invalid JSON body")
    except ValidationError as e:
        return create_error_response(400, "VALIDATION_ERROR", str(e.errors()[0]["msg"]))

    case_id = gen_request.case_id
    findings = gen_request.findings
    clinical_interpretation = gen_request.clinical_interpretation
    idempotency_key = gen_request.idempotency_key

    # Idempotency check (if key provided)
    if idempotency_key:
        cached = check_idempotency(user_email, idempotency_key)
        if cached:
            if cached.get("_idempotency_status") == "processing":
                return create_error_response(409, "CONFLICT", "Request is already being processed")
            logger.info(f"Idempotency cache hit for generate: user={user_email}")
            return create_success_response(cached)

        if not claim_idempotency_key(user_email, idempotency_key):
            return create_error_response(409, "CONFLICT", "Duplicate request")

    # Safety check: prompt injection detection
    is_injection, pattern = detect_prompt_injection(findings)
    if is_injection:
        logger.warning(f"Prompt injection detected in findings: user={user_email}, pattern={pattern}")
        return create_error_response(400, "SAFETY_VIOLATION", "Input rejected by safety filter")

    # Get user settings (model selection, k_preferences)
    user_settings = get_settings(user_email)
    model_settings = user_settings.get("model_settings", {})
    model_settings["k_preferences"] = user_settings.get("k_preferences", 10)

    result = invoke_agent(
        "generate_impression",
        user_email,
        case_id=case_id,
        findings=findings,
        clinical_interpretation=bool(clinical_interpretation),
        model_settings=model_settings,
    )
    if "error" in result:
        return create_error_response(500, "AGENT_ERROR", result["error"])

    # Cache result for idempotency
    if idempotency_key:
        store_idempotency_result(user_email, idempotency_key, result)

    return create_success_response(result)
