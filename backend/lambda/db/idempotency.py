"""
Idempotency key management.

Prevents duplicate processing of POST /generate and POST /edit requests
using conditional writes and a TTL-based DynamoDB table.
"""

import json
import time

from botocore.exceptions import ClientError

from db.common import dynamodb, IDEMPOTENCY_TABLE, logger


IDEMPOTENCY_TTL_SECONDS = 86400  # 24 hours


def check_idempotency(user_id: str, client_key: str) -> dict | None:
    """Look up a cached response for an idempotency key.

    Args:
        user_id: The authenticated user's email.
        client_key: The client-provided idempotency key.

    Returns:
        The cached response dict if found and not expired, else None.
    """
    table = dynamodb.Table(IDEMPOTENCY_TABLE)
    composite_key = f"{user_id}#{client_key}"

    try:
        response = table.get_item(Key={"idempotency_key": composite_key})
        item = response.get("Item")

        if not item:
            return None

        # Check TTL (DynamoDB TTL deletion is eventual, so check manually too)
        expires_at = item.get("expires_at", 0)
        if int(time.time()) >= int(expires_at):
            return None

        # Return cached response if processing is complete
        status = item.get("status")
        if status == "completed":
            cached = item.get("cached_response")
            if cached:
                return json.loads(cached) if isinstance(cached, str) else cached

        # If still processing, return a status indicator so caller can decide
        if status == "processing":
            return {"_idempotency_status": "processing"}

        return None

    except Exception as e:
        logger.error(f"Failed to check idempotency key: {e}")
        return None


def claim_idempotency_key(user_id: str, client_key: str) -> bool:
    """Claim an idempotency key using a conditional write.

    Args:
        user_id: The authenticated user's email.
        client_key: The client-provided idempotency key.

    Returns:
        True if the key was successfully claimed, False if it already exists.
    """
    table = dynamodb.Table(IDEMPOTENCY_TABLE)
    composite_key = f"{user_id}#{client_key}"
    now = int(time.time())

    try:
        table.put_item(
            Item={
                "idempotency_key": composite_key,
                "user_id": user_id,
                "status": "processing",
                "created_at": now,
                "expires_at": now + IDEMPOTENCY_TTL_SECONDS,
            },
            ConditionExpression="attribute_not_exists(idempotency_key) OR expires_at < :now",
            ExpressionAttributeValues={":now": now},
        )
        return True

    except ClientError as e:
        if e.response["Error"]["Code"] == "ConditionalCheckFailedException":
            return False
        logger.error(f"Failed to claim idempotency key: {e}")
        raise


def store_idempotency_result(user_id: str, client_key: str, response: dict) -> None:
    """Store the result for an idempotency key.

    Args:
        user_id: The authenticated user's email.
        client_key: The client-provided idempotency key.
        response: The response dict to cache.
    """
    table = dynamodb.Table(IDEMPOTENCY_TABLE)
    composite_key = f"{user_id}#{client_key}"

    try:
        table.update_item(
            Key={"idempotency_key": composite_key},
            UpdateExpression="SET #status = :status, cached_response = :resp",
            ExpressionAttributeNames={"#status": "status"},
            ExpressionAttributeValues={
                ":status": "completed",
                ":resp": json.dumps(response),
            },
        )
    except Exception as e:
        logger.error(f"Failed to store idempotency result: {e}")
