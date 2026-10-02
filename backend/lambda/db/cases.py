"""
Cases table operations.

Handles CRUD for radiology cases including image URL generation.
"""

import json
import time

from db.common import dynamodb, s3_client, CASES_TABLE, PRESIGNED_URL_EXPIRY, logger
from db.settings import get_settings, DEFAULT_DATA_SOURCE


def get_cases(user_id: str) -> dict:
    """Get all cases for a user directly from DynamoDB."""
    table = dynamodb.Table(CASES_TABLE)
    response = table.query(
        KeyConditionExpression="user_id = :uid",
        ExpressionAttributeValues={":uid": user_id}
    )

    cases = []
    for item in response.get("Items", []):
        # Truncate findings for list view
        findings_preview = item.get("findings", "")
        if len(findings_preview) > 200:
            findings_preview = findings_preview[:200] + "..."

        cases.append({
            "case_id": item.get("case_id"),
            "findings": findings_preview,
            "has_generated": bool(item.get("generated_impression")),
            "has_edited": bool(item.get("edited_impression")),
        })

    return {
        "count": len(cases),
        "cases": cases,
    }


def get_case_detail(user_id: str, case_id: str) -> dict:
    """Get full details for a specific case directly from DynamoDB."""
    from db.edit_history import get_case_edit_history

    table = dynamodb.Table(CASES_TABLE)
    response = table.get_item(Key={"user_id": user_id, "case_id": case_id})
    case = response.get("Item")

    if not case:
        return {"error": "Case not found"}

    result = {
        "case_id": case.get("case_id"),
        "findings": case.get("findings"),
        "reference_impression": case.get("reference_impression"),
        "generated_impression": case.get("generated_impression"),
        "edited_impression": case.get("edited_impression"),
    }
    # Include audit trail fields if present
    if "generated_at" in case:
        result["generated_at"] = case.get("generated_at")
    if "edited_at" in case:
        result["edited_at"] = case.get("edited_at")
    if "base_impression" in case:
        result["base_impression"] = case.get("base_impression")
    if "base_impression_model" in case:
        result["base_impression_model"] = case.get("base_impression_model")
    if "refinement_model" in case:
        result["refinement_model"] = case.get("refinement_model")
    if "preferences_applied" in case:
        # Parse JSON string back to list
        prefs_str = case.get("preferences_applied")
        if prefs_str:
            try:
                result["preferences_applied"] = json.loads(prefs_str)
            except json.JSONDecodeError:
                result["preferences_applied"] = []

    # Include full edit history from EditHistory table
    edit_history = get_case_edit_history(user_id, case_id)
    if edit_history:
        result["edit_history"] = edit_history

    # Generate image URLs if case has image keys
    s3_image_keys = case.get("s3_image_keys", [])
    if s3_image_keys:
        # Get user settings for data source
        settings = get_settings(user_id)
        data_source = settings.get("data_source", DEFAULT_DATA_SOURCE)
        mimic_bucket = settings.get("mimic_bucket")

        image_urls = generate_image_urls(user_id, s3_image_keys, data_source, mimic_bucket)
        if image_urls:
            result["image_urls"] = image_urls

    return result


def update_case(user_id: str, case_id: str, findings: str) -> dict:
    """Update case findings directly in DynamoDB."""
    table = dynamodb.Table(CASES_TABLE)

    # Check case exists first
    response = table.get_item(Key={"user_id": user_id, "case_id": case_id})
    if "Item" not in response:
        return {"error": "Case not found"}

    # Update findings
    table.update_item(
        Key={"user_id": user_id, "case_id": case_id},
        UpdateExpression="SET findings = :f",
        ExpressionAttributeValues={":f": findings}
    )

    return {"case_id": case_id, "message": "Case updated successfully"}


def generate_image_urls(user_id: str, s3_image_keys: list, data_source: str, mimic_bucket: str = None) -> list:
    """Generate presigned URLs for case images.

    For synthetic data source, returns a marker to use bundled placeholder image.
    For MIMIC data source, generates presigned S3 URLs.
    """
    if not s3_image_keys:
        return []

    image_urls = []
    expires_at = int(time.time()) + PRESIGNED_URL_EXPIRY

    if data_source == "synthetic":
        for idx, key in enumerate(s3_image_keys):
            image_urls.append({
                "url": "bundled://placeholder-xray",
                "expires_at": None,
                "view_type": f"Image {idx + 1}",
                "is_placeholder": True,
            })
    elif data_source == "mimic" and mimic_bucket:
        # Parse bucket and prefix
        if mimic_bucket.startswith("s3://"):
            bucket_path = mimic_bucket[5:]
        else:
            bucket_path = mimic_bucket

        if "/" in bucket_path:
            bucket_name, bucket_prefix = bucket_path.split("/", 1)
        else:
            bucket_name = bucket_path
            bucket_prefix = ""

        for idx, key in enumerate(s3_image_keys):
            try:
                full_key = f"{bucket_prefix}/{key}" if bucket_prefix else key
                full_key = full_key.lstrip("/")

                url = s3_client.generate_presigned_url(
                    "get_object",
                    Params={"Bucket": bucket_name, "Key": full_key},
                    ExpiresIn=PRESIGNED_URL_EXPIRY
                )

                key_lower = key.lower()
                if "lateral" in key_lower:
                    view_type = "Lateral"
                elif "frontal" in key_lower or "pa" in key_lower or "ap" in key_lower:
                    view_type = "Frontal"
                else:
                    view_type = f"Image {idx + 1}"

                image_urls.append({
                    "url": url,
                    "expires_at": expires_at,
                    "view_type": view_type,
                    "is_placeholder": False,
                })
            except Exception as e:
                logger.error(f"Failed to generate presigned URL for {key}: {e}")
                image_urls.append({
                    "url": None,
                    "error": str(e),
                    "view_type": f"Image {idx + 1}",
                    "is_placeholder": False,
                })

    return image_urls
