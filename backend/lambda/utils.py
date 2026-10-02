"""
Lambda Utility Functions

Provides common utilities for the Lambda handler:
- Response formatting (success/error)
- Input validation
- JWT claim extraction
- JSON encoding for DynamoDB Decimals
"""

import json
from decimal import Decimal
from typing import Any

from shared.validation_limits import MAX_FINDINGS_LENGTH, MAX_IMPRESSION_LENGTH, MAX_CASE_ID_LENGTH


class DecimalEncoder(json.JSONEncoder):
    """Handle Decimal types from DynamoDB for JSON serialization."""

    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super().default(obj)


def decimals_to_float(obj):
    """Recursively convert DynamoDB Decimal values to Python floats.

    Use when preparing DynamoDB query results for JSON serialization
    or any context that doesn't accept Decimal types.
    """
    if isinstance(obj, Decimal):
        return float(obj)
    elif isinstance(obj, dict):
        return {k: decimals_to_float(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [decimals_to_float(item) for item in obj]
    return obj


def floats_to_decimal(obj):
    """Recursively convert Python floats to Decimal for DynamoDB storage.

    Uses str() intermediary to avoid floating-point precision artifacts.
    """
    if isinstance(obj, float):
        return Decimal(str(obj))
    elif isinstance(obj, dict):
        return {k: floats_to_decimal(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [floats_to_decimal(item) for item in obj]
    return obj


def embedding_to_decimals(embedding: list[float]) -> list[Decimal]:
    """Convert a float embedding vector to Decimals for DynamoDB storage."""
    return [Decimal(str(f)) for f in embedding]


def embedding_to_floats(embedding: list) -> list[float]:
    """Convert a DynamoDB Decimal embedding vector to floats."""
    return [float(d) for d in embedding]


# =============================================================================
# Response Helpers
# =============================================================================


def create_error_response(status_code: int, code: str, message: str) -> dict:
    """Create standardized error response."""
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "Content-Type,Authorization",
            "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE,OPTIONS",
        },
        "body": json.dumps({"error": {"code": code, "message": message}}),
    }


def create_success_response(data: Any) -> dict:
    """Create standardized success response."""
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "Content-Type,Authorization",
            "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE,OPTIONS",
        },
        "body": json.dumps(data),
    }


# =============================================================================
# JWT / Auth Helpers
# =============================================================================


def get_user_email(event: dict) -> str | None:
    """Extract email claim from JWT via API Gateway authorizer context."""
    # HTTP API v2 format with JWT authorizer
    jwt_claims = event.get("requestContext", {}).get("authorizer", {}).get("jwt", {}).get("claims", {})
    email = jwt_claims.get("email")
    if email:
        return email

    # Fallback: REST API format
    authorizer = event.get("requestContext", {}).get("authorizer", {})
    if "claims" in authorizer:
        return authorizer["claims"].get("email")

    return None


# =============================================================================
# Input Validation
# =============================================================================

def validate_string(value: Any, field_name: str, max_length: int, required: bool = True) -> str | None:
    """Validate a string field. Returns error message or None if valid."""
    if value is None:
        if required:
            return f"Missing required field: {field_name}"
        return None

    if not isinstance(value, str):
        return f"Field '{field_name}' must be a string"

    if len(value) == 0 and required:
        return f"Field '{field_name}' cannot be empty"

    if len(value) > max_length:
        return f"Field '{field_name}' exceeds maximum length of {max_length} characters"

    return None
