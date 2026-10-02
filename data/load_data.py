#!/usr/bin/env python3
"""
Load radiology cases into DynamoDB from synthetic or MIMIC data sources.

Usage:
    uv run python load_data.py [--user-id USER_ID] [--clear] [--clear-only]
    uv run python load_data.py --data-source mimic --mimic-bucket BUCKET[/PREFIX]

Options:
    --user-id       User ID to load cases for (default: test-user@example.com)
    --clear         Clear all tables before loading data
    --clear-only    Clear all tables without loading data (fresh start)
    --data-source   Data source: 'synthetic' (default) or 'mimic'
    --mimic-bucket  S3 bucket for MIMIC data (required if data-source is mimic)

By default, loads synthetic cases for a test user. Use --data-source mimic with
--mimic-bucket to load MIMIC-CXR cases from your own S3 bucket.
"""

import argparse
import json
import time
from pathlib import Path

import boto3
from botocore.exceptions import ClientError


# All tables and their key schemas
TABLES = [
    ("radiologist-cases", "user_id", "case_id"),
    ("radiologist-edit-history", "user_id", "edit_id"),
    ("radiologist-preferences", "user_id", "preference_id"),
    ("radiologist-rejected-preferences", "user_id", "rejection_id"),
    ("radiologist-user-settings", "user_id", None),  # No sort key
]


def clear_all_tables(user_id: str = None) -> None:
    """
    Clear all DynamoDB tables.

    Args:
        user_id: If provided, only clear data for this user. If None, clear ALL data.
    """
    dynamodb = boto3.resource("dynamodb", region_name="us-east-1")

    print("=" * 60)
    print("CLEARING TABLES")
    if user_id:
        print(f"User: {user_id}")
    else:
        print("WARNING: Clearing ALL data for ALL users!")
    print("=" * 60)

    for table_name, pk, sk in TABLES:
        print(f"\nClearing {table_name}...")
        table = dynamodb.Table(table_name)

        try:
            # Scan items (optionally filtered by user_id)
            if user_id:
                response = table.query(
                    KeyConditionExpression="user_id = :uid",
                    ExpressionAttributeValues={":uid": user_id}
                )
                items = response.get("Items", [])
                # Handle pagination
                while "LastEvaluatedKey" in response:
                    response = table.query(
                        KeyConditionExpression="user_id = :uid",
                        ExpressionAttributeValues={":uid": user_id},
                        ExclusiveStartKey=response["LastEvaluatedKey"]
                    )
                    items.extend(response.get("Items", []))
            else:
                response = table.scan()
                items = response.get("Items", [])
                # Handle pagination
                while "LastEvaluatedKey" in response:
                    response = table.scan(ExclusiveStartKey=response["LastEvaluatedKey"])
                    items.extend(response.get("Items", []))

            print(f"  Found {len(items)} items to delete")

            # Delete each item
            deleted = 0
            for item in items:
                key = {pk: item[pk]}
                if sk and sk in item:
                    key[sk] = item[sk]
                table.delete_item(Key=key)
                deleted += 1

            print(f"  Deleted {deleted} items")

        except ClientError as e:
            if e.response["Error"]["Code"] == "ResourceNotFoundException":
                print(f"  Table does not exist, skipping")
            else:
                raise

    print("\n" + "=" * 60)
    print("All tables cleared!")
    print("=" * 60)


def load_cases(user_id: str, table_name: str = "radiologist-cases", data_source: str = "synthetic", mimic_bucket: str = None) -> None:
    """Load cases into DynamoDB for a given user.

    Args:
        user_id: User ID to load cases for
        table_name: DynamoDB table name
        data_source: 'synthetic' or 'mimic'
        mimic_bucket: S3 bucket for MIMIC data (required if data_source is 'mimic')
    """
    if data_source == "synthetic":
        load_synthetic_cases(user_id, table_name)
    elif data_source == "mimic":
        if not mimic_bucket:
            raise ValueError("--mimic-bucket is required when --data-source is 'mimic'")
        load_mimic_cases(user_id, table_name, mimic_bucket)
    else:
        raise ValueError(f"Unknown data source: {data_source}")


def load_synthetic_cases(user_id: str, table_name: str = "radiologist-cases") -> None:
    """Load synthetic cases into DynamoDB for a given user."""

    # Load synthetic cases from JSON
    data_file = Path(__file__).parent / "synthetic_cases.json"
    with open(data_file) as f:
        data = json.load(f)

    # Connect to DynamoDB
    dynamodb = boto3.resource("dynamodb", region_name="us-east-1")
    table = dynamodb.Table(table_name)

    print(f"\nLoading {len(data['cases'])} synthetic cases for user: {user_id}")
    print(f"Table: {table_name}")
    print("-" * 50)

    # Batch write items
    with table.batch_writer() as batch:
        for case in data["cases"]:
            item = {
                "user_id": user_id,
                "case_id": case["case_id"],
                "findings": case["findings"],
                "reference_impression": case.get("reference_impression", ""),
                # Include image keys for synthetic data
                "s3_image_keys": case.get("s3_image_keys", ["placeholder/chest-xray.png"]),
                # These fields start empty and get populated during usage:
                # generated_impression, edited_impression, generated_at, edited_at
                # base_impression, preferences_applied, base_impression_model, refinement_model
                "timestamp": int(time.time()),
            }
            batch.put_item(Item=item)
            print(f"  Loaded: {case['case_id']}")

    print("-" * 50)
    print(f"Successfully loaded {len(data['cases'])} synthetic cases")


def load_mimic_cases(user_id: str, table_name: str = "radiologist-cases", mimic_bucket: str = None) -> None:
    """Load MIMIC-CXR cases from S3 bucket into DynamoDB.

    Expects the bucket to contain:
    - mimic_cases.json: JSON file with case metadata
    - PNG images converted from DICOM using convert_dicom_to_png.py

    Args:
        user_id: User ID to load cases for
        table_name: DynamoDB table name
        mimic_bucket: S3 bucket name with an optional key prefix
    """
    s3 = boto3.client("s3", region_name="us-east-1")
    dynamodb = boto3.resource("dynamodb", region_name="us-east-1")
    table = dynamodb.Table(table_name)

    # Parse bucket and prefix
    if mimic_bucket.startswith("s3://"):
        bucket_path = mimic_bucket[5:]
    else:
        bucket_path = mimic_bucket

    if "/" in bucket_path:
        bucket_name, prefix = bucket_path.split("/", 1)
        prefix = prefix.rstrip("/") + "/"
    else:
        bucket_name = bucket_path
        prefix = ""

    # Load case metadata from S3
    metadata_key = f"{prefix}mimic_cases.json" if prefix else "mimic_cases.json"
    print(f"\nLoading MIMIC cases from s3://{bucket_name}/{metadata_key}")

    try:
        response = s3.get_object(Bucket=bucket_name, Key=metadata_key)
        data = json.loads(response["Body"].read().decode("utf-8"))
    except ClientError as e:
        if e.response["Error"]["Code"] == "NoSuchKey":
            print(f"Error: mimic_cases.json not found at s3://{bucket_name}/{metadata_key}")
            print("Please ensure you have:")
            print("  1. Downloaded MIMIC-CXR data")
            print("  2. Run convert_dicom_to_png.py to convert images")
            print("  3. Uploaded the data to your S3 bucket")
            print("See data/README.md for detailed instructions.")
            return
        raise

    cases = data.get("cases", [])
    print(f"Found {len(cases)} MIMIC cases")
    print(f"Table: {table_name}")
    print("-" * 50)

    # Batch write items
    loaded = 0
    with table.batch_writer() as batch:
        for case in cases:
            item = {
                "user_id": user_id,
                "case_id": case["case_id"],
                "findings": case["findings"],
                "reference_impression": case.get("reference_impression", ""),
                # MIMIC images - keys are relative to mimic_bucket
                "s3_image_keys": case.get("s3_image_keys", []),
                "timestamp": int(time.time()),
            }
            batch.put_item(Item=item)
            print(f"  Loaded: {case['case_id']}")
            loaded += 1

    print("-" * 50)
    print(f"Successfully loaded {loaded} MIMIC cases")


def verify_load(user_id: str, table_name: str = "radiologist-cases") -> None:
    """Verify cases were loaded by querying DynamoDB."""

    dynamodb = boto3.resource("dynamodb", region_name="us-east-1")
    table = dynamodb.Table(table_name)

    response = table.query(
        KeyConditionExpression="user_id = :uid",
        ExpressionAttributeValues={":uid": user_id},
        Select="COUNT"
    )

    print(f"\nVerification: Found {response['Count']} cases for user {user_id}")


def main():
    parser = argparse.ArgumentParser(
        description="Load radiology cases into DynamoDB",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Load synthetic cases for default test user
  uv run python load_data.py

  # Clear and reload for test user (fresh start)
  uv run python load_data.py --clear

  # Clear all data without reloading
  uv run python load_data.py --clear-only

  # Load for a specific user
  uv run python load_data.py --user-id alice@example.com --clear

  # Load MIMIC cases from your S3 bucket
  uv run python load_data.py --data-source mimic --mimic-bucket <YOUR_BUCKET_NAME>/mimic-cxr --clear
        """
    )
    parser.add_argument(
        "--user-id",
        default="test-user@example.com",
        help="User ID to load cases for (default: test-user@example.com)"
    )
    parser.add_argument(
        "--table",
        default="radiologist-cases",
        help="DynamoDB table name (default: radiologist-cases)"
    )
    parser.add_argument(
        "--clear",
        action="store_true",
        help="Clear all tables for this user before loading data"
    )
    parser.add_argument(
        "--clear-only",
        action="store_true",
        help="Only clear tables, don't load data"
    )
    parser.add_argument(
        "--clear-all-users",
        action="store_true",
        help="Clear data for ALL users (use with caution!)"
    )
    parser.add_argument(
        "--data-source",
        choices=["synthetic", "mimic"],
        default="synthetic",
        help="Data source: 'synthetic' (default) or 'mimic'"
    )
    parser.add_argument(
        "--mimic-bucket",
        help="S3 bucket for MIMIC data (required if --data-source is 'mimic')"
    )
    args = parser.parse_args()

    try:
        # Clear tables if requested
        if args.clear_only or args.clear:
            if args.clear_all_users:
                clear_all_tables(user_id=None)
            else:
                clear_all_tables(user_id=args.user_id)

        # Load data unless clear-only
        if not args.clear_only:
            load_cases(
                args.user_id,
                args.table,
                data_source=args.data_source,
                mimic_bucket=args.mimic_bucket
            )
            verify_load(args.user_id, args.table)

    except ClientError as e:
        print(f"Error: {e.response['Error']['Message']}")
        raise


if __name__ == "__main__":
    main()
