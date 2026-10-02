"""
Idempotency Module Unit Tests

Tests idempotency key checking, claiming, and result storage.

Run with:
    cd backend/lambda
    uv run pytest tests/test_idempotency.py -v
"""

import json
import sys
import time
from pathlib import Path
from unittest.mock import patch, MagicMock

import pytest

sys.path.insert(0, str(Path(__file__).parent.parent))


class TestCheckIdempotency:
    """Tests for check_idempotency."""

    @patch("db.idempotency.dynamodb")
    def test_cache_hit_returns_response(self, mock_dynamodb):
        """Completed idempotency entry returns cached response."""
        from db.idempotency import check_idempotency

        cached_response = {"impression": "No acute findings.", "case_id": "C1"}
        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table
        mock_table.get_item.return_value = {
            "Item": {
                "idempotency_key": "user@test.com#key-123",
                "status": "completed",
                "cached_response": json.dumps(cached_response),
                "expires_at": int(time.time()) + 3600,
            }
        }

        result = check_idempotency("user@test.com", "key-123")
        assert result == cached_response

    @patch("db.idempotency.dynamodb")
    def test_cache_miss_returns_none(self, mock_dynamodb):
        """Missing idempotency entry returns None."""
        from db.idempotency import check_idempotency

        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table
        mock_table.get_item.return_value = {}

        result = check_idempotency("user@test.com", "key-123")
        assert result is None

    @patch("db.idempotency.dynamodb")
    def test_expired_entry_returns_none(self, mock_dynamodb):
        """Expired idempotency entry returns None."""
        from db.idempotency import check_idempotency

        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table
        mock_table.get_item.return_value = {
            "Item": {
                "idempotency_key": "user@test.com#key-123",
                "status": "completed",
                "cached_response": json.dumps({"test": True}),
                "expires_at": int(time.time()) - 100,  # expired
            }
        }

        result = check_idempotency("user@test.com", "key-123")
        assert result is None

    @patch("db.idempotency.dynamodb")
    def test_processing_status_returns_indicator(self, mock_dynamodb):
        """Entry still processing returns status indicator."""
        from db.idempotency import check_idempotency

        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table
        mock_table.get_item.return_value = {
            "Item": {
                "idempotency_key": "user@test.com#key-123",
                "status": "processing",
                "expires_at": int(time.time()) + 3600,
            }
        }

        result = check_idempotency("user@test.com", "key-123")
        assert result == {"_idempotency_status": "processing"}


class TestClaimKey:
    """Tests for claim_idempotency_key."""

    @patch("db.idempotency.dynamodb")
    def test_successful_claim(self, mock_dynamodb):
        """New key can be successfully claimed."""
        from db.idempotency import claim_idempotency_key

        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table

        result = claim_idempotency_key("user@test.com", "key-123")
        assert result is True
        mock_table.put_item.assert_called_once()

    @patch("db.idempotency.dynamodb")
    def test_race_condition_returns_false(self, mock_dynamodb):
        """Already claimed key returns False."""
        from botocore.exceptions import ClientError
        from db.idempotency import claim_idempotency_key

        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table
        mock_table.put_item.side_effect = ClientError(
            {"Error": {"Code": "ConditionalCheckFailedException", "Message": "exists"}},
            "PutItem"
        )

        result = claim_idempotency_key("user@test.com", "key-123")
        assert result is False


class TestStoreResult:
    """Tests for store_idempotency_result."""

    @patch("db.idempotency.dynamodb")
    def test_store_and_retrieve_roundtrip(self, mock_dynamodb):
        """Stored result can be retrieved."""
        from db.idempotency import store_idempotency_result

        mock_table = MagicMock()
        mock_dynamodb.Table.return_value = mock_table

        response = {"impression": "No acute findings.", "case_id": "C1"}
        store_idempotency_result("user@test.com", "key-123", response)

        mock_table.update_item.assert_called_once()
        call_kwargs = mock_table.update_item.call_args[1]
        assert call_kwargs["ExpressionAttributeValues"][":status"] == "completed"
        assert json.loads(call_kwargs["ExpressionAttributeValues"][":resp"]) == response
