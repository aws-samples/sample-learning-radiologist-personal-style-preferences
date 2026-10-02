"""
Preferences table operations.

Handles CRUD for learned style preferences with edit tracking.
"""

import time

from db.common import dynamodb, PREFERENCES_TABLE, logger


def get_preferences(user_id: str) -> dict:
    """Get all preferences for a user directly from DynamoDB."""
    table = dynamodb.Table(PREFERENCES_TABLE)
    response = table.query(
        KeyConditionExpression="user_id = :uid",
        ExpressionAttributeValues={":uid": user_id}
    )

    preferences = []
    for p in response.get("Items", []):
        pref_item = {
            "preference_id": p.get("preference_id"),
            "preference_text": p.get("preference_text"),
            "source_case_id": p.get("source_case_id"),
            "timestamp": p.get("timestamp"),
        }
        # Include structured output fields if present
        if "category" in p:
            pref_item["category"] = p.get("category")
        if "confidence" in p:
            pref_item["confidence"] = p.get("confidence")
        # Include traceability fields if present
        if "source_edit_id" in p:
            pref_item["source_edit_id"] = p.get("source_edit_id")
        if "original_impression" in p:
            pref_item["original_impression"] = p.get("original_impression")
        if "edited_impression" in p:
            pref_item["edited_impression"] = p.get("edited_impression")
        if "context_findings" in p:
            pref_item["context_findings"] = p.get("context_findings")
        if "edit_distance" in p:
            pref_item["edit_distance"] = p.get("edit_distance")
        # Include inference explanation if present
        if "inference_explanation" in p:
            pref_item["inference_explanation"] = p.get("inference_explanation")
        # Include model used for inference
        if "inference_model" in p:
            pref_item["inference_model"] = p.get("inference_model")
        # Include user edit tracking fields if present
        if "original_inferred_text" in p:
            pref_item["original_inferred_text"] = p.get("original_inferred_text")
        if "last_edited_at" in p:
            pref_item["last_edited_at"] = p.get("last_edited_at")
        if "user_edit_count" in p:
            pref_item["user_edit_count"] = p.get("user_edit_count")
        preferences.append(pref_item)

    return {
        "count": len(preferences),
        "preferences": preferences,
    }


def delete_preference(user_id: str, preference_id: str) -> dict:
    """Delete a preference from DynamoDB."""
    table = dynamodb.Table(PREFERENCES_TABLE)

    response = table.get_item(Key={"user_id": user_id, "preference_id": preference_id})
    if "Item" not in response:
        return {"error": "Preference not found"}

    table.delete_item(Key={"user_id": user_id, "preference_id": preference_id})
    return {"preference_id": preference_id, "message": "Preference deleted successfully"}


def update_preference(user_id: str, preference_id: str, new_preference_text: str) -> dict:
    """Update preference text in DynamoDB (after safety validation).

    Tracks edit history by preserving original LLM-inferred text and recording edits.
    """
    table = dynamodb.Table(PREFERENCES_TABLE)

    response = table.get_item(Key={"user_id": user_id, "preference_id": preference_id})
    if "Item" not in response:
        return {"error": "Preference not found"}

    item = response["Item"]
    current_text = item.get("preference_text", "")

    if "original_inferred_text" not in item:
        # First edit - save the original LLM-inferred text
        table.update_item(
            Key={"user_id": user_id, "preference_id": preference_id},
            UpdateExpression="SET preference_text = :text, original_inferred_text = :original, last_edited_at = :edited, user_edit_count = :count",
            ExpressionAttributeValues={
                ":text": new_preference_text,
                ":original": current_text,
                ":edited": int(time.time()),
                ":count": 1,
            },
        )
    else:
        # Subsequent edit - just update text and increment count
        current_count = int(item.get("user_edit_count", 0))
        table.update_item(
            Key={"user_id": user_id, "preference_id": preference_id},
            UpdateExpression="SET preference_text = :text, last_edited_at = :edited, user_edit_count = :count",
            ExpressionAttributeValues={
                ":text": new_preference_text,
                ":edited": int(time.time()),
                ":count": current_count + 1,
            },
        )

    return {
        "preference_id": preference_id,
        "preference_text": new_preference_text,
        "message": "Preference updated successfully",
    }
