"""
Lambda Handler Unit Tests

Tests routing, Pydantic validation, and error handling in the Lambda handler.
All external dependencies (DynamoDB, AgentCore, Step Functions) are mocked.

Run with:
    cd backend/lambda
    uv run pytest tests/test_handler.py -v
"""

import json
import sys
from pathlib import Path
from unittest.mock import patch, MagicMock

import pytest

# Add lambda directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))


# =============================================================================
# Helpers
# =============================================================================


def make_event(route_key: str, body: dict = None, path_params: dict = None,
               user_email: str = "test@example.com") -> dict:
    """Create a mock API Gateway v2 event."""
    event = {
        "routeKey": route_key,
        "requestContext": {
            "http": {"method": route_key.split(" ")[0]},
            "authorizer": {
                "jwt": {
                    "claims": {"email": user_email, "sub": "user-123"}
                }
            }
        },
        "pathParameters": path_params or {},
    }
    if body is not None:
        event["body"] = json.dumps(body)
    return event


def make_event_no_auth(route_key: str, body: dict = None) -> dict:
    """Create a mock event without authorization."""
    event = {
        "routeKey": route_key,
        "requestContext": {
            "http": {"method": route_key.split(" ")[0]},
        },
    }
    if body is not None:
        event["body"] = json.dumps(body)
    return event


# =============================================================================
# Test: Missing/Invalid Body Fields → 400
# =============================================================================


class TestRequestValidation:
    """Tests for Pydantic-based request validation."""

    @patch("routes.generation.get_settings", return_value={})
    @patch("routes.generation.invoke_agent", return_value={"impression": "test"})
    def test_generate_missing_findings(self, mock_agent, mock_settings):
        """POST /generate with missing findings → 400."""
        from handler import handler
        event = make_event("POST /generate", body={"case_id": "Case_001"})
        result = handler(event, None)
        assert result["statusCode"] == 400
        body = json.loads(result["body"])
        assert "error" in body

    @patch("routes.generation.get_settings", return_value={})
    @patch("routes.generation.invoke_agent", return_value={"impression": "test"})
    def test_generate_missing_case_id(self, mock_agent, mock_settings):
        """POST /generate with missing case_id → 400."""
        from handler import handler
        event = make_event("POST /generate", body={"findings": "Heart normal."})
        result = handler(event, None)
        assert result["statusCode"] == 400

    @patch("routes.generation.get_settings", return_value={})
    @patch("routes.generation.invoke_agent", return_value={"impression": "test"})
    def test_generate_empty_findings(self, mock_agent, mock_settings):
        """POST /generate with empty findings → 400."""
        from handler import handler
        event = make_event("POST /generate", body={"case_id": "C1", "findings": ""})
        result = handler(event, None)
        assert result["statusCode"] == 400

    def test_edit_missing_required_fields(self):
        """POST /edit with missing fields → 400."""
        from handler import handler
        event = make_event("POST /edit", body={"case_id": "C1"})
        result = handler(event, None)
        assert result["statusCode"] == 400

    def test_update_case_missing_findings(self):
        """PUT /cases/{caseId} with empty body → 400."""
        from handler import handler
        event = make_event("PUT /cases/{caseId}", body={},
                          path_params={"caseId": "Case_001"})
        result = handler(event, None)
        assert result["statusCode"] == 400

    def test_update_preference_missing_text(self):
        """PUT /preferences/{id} with empty body → 400."""
        from handler import handler
        event = make_event("PUT /preferences/{preferenceId}", body={},
                          path_params={"preferenceId": "pref_001"})
        result = handler(event, None)
        assert result["statusCode"] == 400

    def test_generate_invalid_json_body(self):
        """POST /generate with invalid JSON → 400."""
        from handler import handler
        event = make_event("POST /generate")
        event["body"] = "not valid json{{"
        result = handler(event, None)
        assert result["statusCode"] == 400
        body = json.loads(result["body"])
        assert "Invalid JSON" in body["error"]["message"]


# =============================================================================
# Test: Valid Requests → Correct Routing
# =============================================================================


class TestRouting:
    """Tests for correct request routing."""

    @patch("routes.generation.get_settings", return_value={})
    @patch("routes.generation.invoke_agent")
    def test_generate_routes_correctly(self, mock_agent, mock_settings):
        """Valid POST /generate → calls invoke_agent with 'generate_impression'."""
        mock_agent.return_value = {
            "impression": "No acute findings.",
            "base_impression": "No acute findings.",
            "preferences_used": 0,
            "case_id": "C1",
        }
        from handler import handler
        event = make_event("POST /generate", body={
            "case_id": "Case_001",
            "findings": "Heart size normal. Lungs clear.",
        })
        result = handler(event, None)
        assert result["statusCode"] == 200
        mock_agent.assert_called_once()
        call_args = mock_agent.call_args
        assert call_args[0][0] == "generate_impression"

    @patch("routes.edit.save_edit_job", return_value={"edit_id": "edit_001"})
    @patch("routes.edit.boto3")
    def test_edit_routes_correctly(self, mock_boto3, mock_save_job):
        """Valid POST /edit → saves job and returns processing status."""
        mock_sfn_client = MagicMock()
        mock_boto3.client.return_value = mock_sfn_client

        from handler import handler
        event = make_event("POST /edit", body={
            "case_id": "Case_001",
            "original_impression": "Heart normal.",
            "edited_impression": "Heart is normal.",
            "findings": "Heart: normal size.",
        })
        result = handler(event, None)
        assert result["statusCode"] == 200
        body = json.loads(result["body"])
        assert body["status"] == "processing"
        assert "edit_id" in body

    @patch("routes.cases.get_cases", return_value={"cases": [], "count": 0})
    def test_get_cases_routes_correctly(self, mock_get_cases):
        """GET /cases → calls get_cases."""
        from handler import handler
        event = make_event("GET /cases")
        result = handler(event, None)
        assert result["statusCode"] == 200
        mock_get_cases.assert_called_once_with("test@example.com")


# =============================================================================
# Test: Authorization
# =============================================================================


class TestAuthorization:
    """Tests for JWT-based authorization."""

    def test_missing_auth_returns_401(self):
        """Request without Authorization → 401."""
        from handler import handler
        event = make_event_no_auth("GET /cases")
        result = handler(event, None)
        assert result["statusCode"] == 401
        body = json.loads(result["body"])
        assert body["error"]["code"] == "UNAUTHORIZED"


# =============================================================================
# Test: Unknown Route → 404
# =============================================================================


class TestUnknownRoute:
    """Tests for unknown route handling."""

    def test_unknown_route_returns_404(self):
        """Unknown route → 404."""
        from handler import handler
        event = make_event("GET /nonexistent")
        result = handler(event, None)
        assert result["statusCode"] == 404
        body = json.loads(result["body"])
        assert body["error"]["code"] == "NOT_FOUND"


# =============================================================================
# Test: Pydantic Catches Oversized Fields
# =============================================================================


class TestFieldSizeLimits:
    """Tests for Pydantic field size validation."""

    def test_findings_over_50000_chars_rejected(self):
        """Findings > 50,000 chars → 400."""
        from handler import handler
        event = make_event("POST /generate", body={
            "case_id": "Case_001",
            "findings": "x" * 50001,
        })
        result = handler(event, None)
        assert result["statusCode"] == 400

    def test_case_id_over_64_chars_rejected(self):
        """case_id > 64 chars → 400."""
        from handler import handler
        event = make_event("POST /generate", body={
            "case_id": "x" * 65,
            "findings": "Heart normal.",
        })
        result = handler(event, None)
        assert result["statusCode"] == 400

    def test_impression_over_10000_chars_rejected(self):
        """original_impression > 10,000 chars → 400."""
        from handler import handler
        event = make_event("POST /edit", body={
            "case_id": "C1",
            "original_impression": "x" * 10001,
            "edited_impression": "Heart normal.",
            "findings": "Heart normal.",
        })
        result = handler(event, None)
        assert result["statusCode"] == 400

    @patch("routes.generation.get_settings", return_value={})
    @patch("routes.generation.invoke_agent", return_value={"impression": "ok"})
    def test_valid_size_accepted(self, mock_agent, mock_settings):
        """Fields within limits → accepted (200)."""
        from handler import handler
        event = make_event("POST /generate", body={
            "case_id": "Case_001",
            "findings": "Heart normal. Lungs clear.",
        })
        result = handler(event, None)
        assert result["statusCode"] == 200


# =============================================================================
# Test: CORS Headers
# =============================================================================


class TestCorsHeaders:
    """Tests for CORS header presence."""

    def test_error_response_has_cors(self):
        """Error responses should include CORS headers."""
        from handler import handler
        event = make_event_no_auth("GET /cases")
        result = handler(event, None)
        assert result["headers"]["Access-Control-Allow-Origin"] == "*"

    @patch("routes.cases.get_cases", return_value={"cases": [], "count": 0})
    def test_success_response_has_cors(self, mock_get):
        """Success responses should include CORS headers."""
        from handler import handler
        event = make_event("GET /cases")
        result = handler(event, None)
        assert result["headers"]["Access-Control-Allow-Origin"] == "*"
