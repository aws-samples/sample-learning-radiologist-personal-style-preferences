"""
Edit history table operations.

Handles edit job creation, status tracking, and case edit history retrieval.
"""

import json
from datetime import datetime, timezone

from db.common import dynamodb, EDIT_HISTORY_TABLE, logger
from utils import decimals_to_float, floats_to_decimal


def get_case_edit_history(user_id: str, case_id: str) -> list[dict]:
    """Get all edit history entries for a specific case, ordered by timestamp."""
    table = dynamodb.Table(EDIT_HISTORY_TABLE)

    response = table.query(
        KeyConditionExpression="user_id = :uid",
        FilterExpression="case_id = :cid",
        ExpressionAttributeValues={
            ":uid": user_id,
            ":cid": case_id,
        }
    )

    edits = []
    for item in response.get("Items", []):
        # Skip async job tracking records (they have 'status' field but not 'timestamp')
        if "status" in item or "timestamp" not in item:
            continue

        entry = {
            "edit_id": item.get("edit_id"),
            "original_impression": item.get("original_impression"),
            "edited_impression": item.get("edited_impression"),
            "edit_distance": item.get("edit_distance"),
            "timestamp": item.get("timestamp"),
            "source": item.get("source", "user_edit"),
        }
        if "preferences_snapshot" in item:
            try:
                entry["preferences_snapshot"] = json.loads(item.get("preferences_snapshot"))
            except json.JSONDecodeError:
                entry["preferences_snapshot"] = []
        edits.append(entry)

    edits.sort(key=lambda x: x.get("timestamp", 0))
    return edits


def save_edit_job(user_id: str, edit_id: str, case_id: str, original_impression: str, edited_impression: str, findings: str) -> dict:
    """Save an edit job for async processing."""
    table = dynamodb.Table(EDIT_HISTORY_TABLE)
    now = datetime.now(timezone.utc).isoformat()

    item = {
        "user_id": user_id,
        "edit_id": edit_id,
        "case_id": case_id,
        "original_impression": original_impression,
        "edited_impression": edited_impression,
        "findings": findings,
        "status": "processing",
        "created_at": now,
        "updated_at": now,
    }

    try:
        table.put_item(Item=item)
        logger.info(f"Saved edit job {edit_id} for user={user_id}")
        return {
            "edit_id": edit_id,
            "status": "processing",
            "created_at": now,
        }
    except Exception as e:
        logger.error(f"Failed to save edit job: {e}")
        return {"error": str(e)}


def get_edit_job_status(user_id: str, edit_id: str) -> dict:
    """Get the status of an edit job."""
    table = dynamodb.Table(EDIT_HISTORY_TABLE)

    try:
        response = table.get_item(Key={"user_id": user_id, "edit_id": edit_id})
        item = response.get("Item")

        if not item:
            return {"error": "Edit job not found"}

        result = {
            "edit_id": edit_id,
            "status": item.get("status", "unknown"),
            "created_at": item.get("created_at"),
            "updated_at": item.get("updated_at"),
        }

        if item.get("status") == "completed":
            result["edit_distance"] = decimals_to_float(item.get("edit_distance", 0))
            result["preference_inferred"] = item.get("preference_inferred", False)
            result["preferences_saved"] = decimals_to_float(item.get("preferences_saved", []))
            result["changes_rejected"] = decimals_to_float(item.get("changes_rejected", []))
            result["summary"] = item.get("summary", "")
            if "safety_warning" in item:
                result["safety_warning"] = item["safety_warning"]

        elif item.get("status") == "failed":
            result["error"] = item.get("error_message", "Unknown error")

        return result

    except Exception as e:
        logger.error(f"Failed to get edit job status: {e}")
        return {"error": str(e)}


def update_edit_job_status(user_id: str, edit_id: str, status: str, result_data: dict = None) -> dict:
    """Update the status of an edit job."""
    table = dynamodb.Table(EDIT_HISTORY_TABLE)
    now = datetime.now(timezone.utc).isoformat()

    update_expr = "SET #status = :status, updated_at = :updated_at"
    expr_names = {"#status": "status"}
    expr_values = {":status": status, ":updated_at": now}

    if result_data:
        for key, value in result_data.items():
            safe_key = key.replace("-", "_")
            update_expr += f", {safe_key} = :{safe_key}"
            value = floats_to_decimal(value)
            expr_values[f":{safe_key}"] = value

    try:
        table.update_item(
            Key={"user_id": user_id, "edit_id": edit_id},
            UpdateExpression=update_expr,
            ExpressionAttributeNames=expr_names,
            ExpressionAttributeValues=expr_values,
        )
        logger.info(f"Updated edit job {edit_id} status to {status}")
        return {"edit_id": edit_id, "status": status}

    except Exception as e:
        logger.error(f"Failed to update edit job status: {e}")
        return {"error": str(e)}
