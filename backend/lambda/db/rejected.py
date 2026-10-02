"""
Rejected preferences table operations.

Handles retrieval of rejected preference changes for the audit trail.
"""

from db.common import dynamodb, REJECTED_PREFERENCES_TABLE, logger


def get_rejected_preferences(user_id: str) -> dict:
    """Get all rejected preference changes for a user (audit trail)."""
    table = dynamodb.Table(REJECTED_PREFERENCES_TABLE)

    response = table.query(
        KeyConditionExpression="user_id = :uid",
        ExpressionAttributeValues={":uid": user_id}
    )

    rejections = []
    for item in response.get("Items", []):
        rejection = {
            "rejection_id": item.get("rejection_id"),
            "change_description": item.get("change_description"),
            "rejection_reason": item.get("rejection_reason"),
            "rejection_layer": item.get("rejection_layer"),
            "source_case_id": item.get("source_case_id"),
            "timestamp": item.get("timestamp"),
        }
        if "source_edit_id" in item:
            rejection["source_edit_id"] = item.get("source_edit_id")
        if "original_impression" in item:
            rejection["original_impression"] = item.get("original_impression")
        if "edited_impression" in item:
            rejection["edited_impression"] = item.get("edited_impression")
        if "context_findings" in item:
            rejection["context_findings"] = item.get("context_findings")
        if "risk_level" in item:
            rejection["risk_level"] = item.get("risk_level")
        if "inference_model" in item:
            rejection["inference_model"] = item.get("inference_model")
        rejections.append(rejection)

    rejections.sort(key=lambda x: x.get("timestamp", 0), reverse=True)

    logger.info(f"Found {len(rejections)} rejected preferences for user={user_id}")
    return {
        "count": len(rejections),
        "rejected_preferences": rejections,
    }
