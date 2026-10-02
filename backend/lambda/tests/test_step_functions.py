"""
Step Functions Integration Tests

Tests that POST /edit triggers Step Functions and mark_edit_failed works.

Run with:
    cd backend/lambda
    uv run pytest tests/test_step_functions.py -v
"""

import json
import sys
from pathlib import Path
from unittest.mock import patch, MagicMock

import pytest

sys.path.insert(0, str(Path(__file__).parent.parent))


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


class TestEditSubmission:
    """Tests that POST /edit triggers Step Functions."""

    @patch("routes.edit.save_edit_job", return_value={"edit_id": "edit_abc123"})
    @patch("routes.edit.boto3")
    @patch("routes.edit.os")
    def test_step_functions_called(self, mock_os, mock_boto3, mock_save_job):
        """POST /edit should call start_execution on Step Functions."""
        mock_os.environ.get.return_value = "arn:aws:states:us-east-1:123456:stateMachine:cipher-edit-processing"
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
        mock_boto3.client.assert_called_with("stepfunctions")
        mock_sfn_client.start_execution.assert_called_once()

        # Verify the Step Functions input payload
        call_kwargs = mock_sfn_client.start_execution.call_args[1]
        sfn_input = json.loads(call_kwargs["input"])
        assert sfn_input["async_edit_processing"] is True
        assert sfn_input["user_id"] == "test@example.com"
        assert sfn_input["case_id"] == "Case_001"

    @patch("routes.edit.save_edit_job", return_value={"edit_id": "edit_abc123"})
    @patch("routes.edit.update_edit_job_status")
    @patch("routes.edit.boto3")
    @patch("routes.edit.os")
    def test_step_functions_failure_marks_failed(self, mock_os, mock_boto3, mock_update, mock_save_job):
        """If Step Functions start_execution fails, job is marked as failed."""
        mock_os.environ.get.return_value = "arn:aws:states:..."
        mock_sfn_client = MagicMock()
        mock_sfn_client.start_execution.side_effect = Exception("SFN error")
        mock_boto3.client.return_value = mock_sfn_client

        from handler import handler
        event = make_event("POST /edit", body={
            "case_id": "Case_001",
            "original_impression": "Heart normal.",
            "edited_impression": "Heart is normal.",
            "findings": "Heart: normal size.",
        })
        result = handler(event, None)

        assert result["statusCode"] == 500
        mock_update.assert_called_once()


class TestMarkFailed:
    """Tests for the mark_edit_failed event handler."""

    @patch("handler.update_edit_job_status")
    def test_mark_edit_failed_updates_status(self, mock_update):
        """mark_edit_failed event should update job status to 'failed'."""
        mock_update.return_value = {"edit_id": "edit_123", "status": "failed"}

        from handler import handler
        event = {
            "mark_edit_failed": True,
            "user_id": "test@example.com",
            "edit_id": "edit_123",
            "error_message": "Lambda task failed",
        }
        result = handler(event, None)

        mock_update.assert_called_once_with(
            "test@example.com", "edit_123", "failed",
            {"error_message": "Lambda task failed"}
        )
