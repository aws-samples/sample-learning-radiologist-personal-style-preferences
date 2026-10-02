"""
Data source operations.

Handles user data reset, synthetic case loading, MIMIC case loading,
and S3 bucket validation.
"""

import time

from db.common import (
    dynamodb, s3_client, logger,
    CASES_TABLE, EDIT_HISTORY_TABLE, PREFERENCES_TABLE, REJECTED_PREFERENCES_TABLE,
)


# Table configurations for reset
TABLES_TO_RESET = [
    (CASES_TABLE, "user_id", "case_id"),
    (EDIT_HISTORY_TABLE, "user_id", "edit_id"),
    (PREFERENCES_TABLE, "user_id", "preference_id"),
    (REJECTED_PREFERENCES_TABLE, "user_id", "rejection_id"),
    # Note: USER_SETTINGS_TABLE is NOT reset - we preserve user settings
]


def reset_user_data(user_id: str) -> dict:
    """Reset all user data (cases, edits, preferences) while preserving settings."""
    logger.info(f"Resetting user data for user={user_id}")
    results = {}

    for table_name, pk, sk in TABLES_TO_RESET:
        table = dynamodb.Table(table_name)
        deleted_count = 0

        try:
            response = table.query(
                KeyConditionExpression="user_id = :uid",
                ExpressionAttributeValues={":uid": user_id}
            )
            items = response.get("Items", [])

            while "LastEvaluatedKey" in response:
                response = table.query(
                    KeyConditionExpression="user_id = :uid",
                    ExpressionAttributeValues={":uid": user_id},
                    ExclusiveStartKey=response["LastEvaluatedKey"]
                )
                items.extend(response.get("Items", []))

            for item in items:
                key = {pk: item[pk]}
                if sk and sk in item:
                    key[sk] = item[sk]
                table.delete_item(Key=key)
                deleted_count += 1

            results[table_name] = deleted_count
            logger.info(f"Deleted {deleted_count} items from {table_name}")

        except Exception as e:
            logger.error(f"Error resetting {table_name}: {e}")
            results[table_name] = {"error": str(e)}

    return {
        "message": "User data reset complete",
        "deleted_counts": results,
    }


def load_synthetic_cases(user_id: str) -> dict:
    """Load synthetic cases for a user from the bundled JSON file."""
    import json as json_module
    from pathlib import Path

    try:
        data_file = Path(__file__).parent.parent / "synthetic_cases.json"
        if not data_file.exists():
            logger.warning("synthetic_cases.json not found in Lambda package")
            return {"error": "Synthetic cases not available in this deployment", "cases_loaded": 0}

        with open(data_file) as f:
            data = json_module.load(f)

        table = dynamodb.Table(CASES_TABLE)
        loaded_count = 0

        with table.batch_writer() as batch:
            for case in data.get("cases", []):
                item = {
                    "user_id": user_id,
                    "case_id": case["case_id"],
                    "findings": case["findings"],
                    "reference_impression": case.get("reference_impression", ""),
                    "timestamp": int(time.time()),
                }
                if "s3_image_keys" in case:
                    item["s3_image_keys"] = case["s3_image_keys"]
                batch.put_item(Item=item)
                loaded_count += 1

        logger.info(f"Loaded {loaded_count} synthetic cases for user={user_id}")
        return {"cases_loaded": loaded_count}

    except Exception as e:
        logger.error(f"Error loading synthetic cases: {e}")
        return {"error": str(e), "cases_loaded": 0}


def load_mimic_cases(user_id: str, mimic_bucket: str) -> dict:
    """Load MIMIC cases from S3 bucket for a user."""
    import json as json_module

    try:
        if mimic_bucket.startswith("s3://"):
            bucket_path = mimic_bucket[5:]
        else:
            bucket_path = mimic_bucket

        if "/" in bucket_path:
            bucket_name, prefix = bucket_path.split("/", 1)
        else:
            bucket_name = bucket_path
            prefix = ""

        cases_key = f"{prefix}/mimic_cases.json" if prefix else "mimic_cases.json"
        cases_key = cases_key.lstrip("/")

        logger.info(f"Loading MIMIC cases from s3://{bucket_name}/{cases_key}")

        response = s3_client.get_object(Bucket=bucket_name, Key=cases_key)
        data = json_module.loads(response["Body"].read().decode("utf-8"))

        table = dynamodb.Table(CASES_TABLE)
        loaded_count = 0

        with table.batch_writer() as batch:
            for case in data.get("cases", []):
                item = {
                    "user_id": user_id,
                    "case_id": case["case_id"],
                    "findings": case["findings"],
                    "reference_impression": case.get("reference_impression", ""),
                    "timestamp": int(time.time()),
                }
                if "s3_image_keys" in case:
                    item["s3_image_keys"] = case["s3_image_keys"]
                batch.put_item(Item=item)
                loaded_count += 1

        logger.info(f"Loaded {loaded_count} MIMIC cases for user={user_id}")
        return {"cases_loaded": loaded_count}

    except s3_client.exceptions.NoSuchKey:
        logger.error(f"mimic_cases.json not found in s3://{bucket_name}/{cases_key}")
        return {"error": "mimic_cases.json not found in bucket", "cases_loaded": 0}
    except Exception as e:
        logger.error(f"Error loading MIMIC cases: {e}")
        return {"error": str(e), "cases_loaded": 0}


def validate_mimic_bucket_access(bucket: str) -> dict:
    """Validate that Lambda can read from the specified MIMIC bucket."""
    try:
        if bucket.startswith("s3://"):
            bucket_path = bucket[5:]
        else:
            bucket_path = bucket

        if "/" in bucket_path:
            bucket_name, prefix = bucket_path.split("/", 1)
        else:
            bucket_name = bucket_path
            prefix = ""

        s3_client.list_objects_v2(
            Bucket=bucket_name,
            Prefix=prefix,
            MaxKeys=1
        )

        return {"valid": True, "bucket": bucket_name, "prefix": prefix}

    except Exception as e:
        logger.error(f"Failed to validate MIMIC bucket access: {e}")
        return {"valid": False, "error": str(e)}
