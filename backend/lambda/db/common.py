"""
Shared resources for db package.

Provides DynamoDB resource, S3 client, table name constants, and logger
used across all db modules.
"""

import logging
import os

import boto3


# Configure logging
logger = logging.getLogger(__name__)

# DynamoDB resource (reused across invocations)
dynamodb = boto3.resource("dynamodb")

# S3 client for presigned URLs
s3_client = boto3.client("s3")

# Environment variables for table names
CASES_TABLE = os.environ.get("CASES_TABLE", "radiologist-cases")
PREFERENCES_TABLE = os.environ.get("PREFERENCES_TABLE", "radiologist-preferences")
EDIT_HISTORY_TABLE = os.environ.get("EDIT_HISTORY_TABLE", "radiologist-edit-history")
USER_SETTINGS_TABLE = os.environ.get("USER_SETTINGS_TABLE", "radiologist-user-settings")
REJECTED_PREFERENCES_TABLE = os.environ.get("REJECTED_PREFERENCES_TABLE", "radiologist-rejected-preferences")
IDEMPOTENCY_TABLE = os.environ.get("IDEMPOTENCY_TABLE", "radiologist-idempotency")

# Presigned URL expiry (15 minutes)
PRESIGNED_URL_EXPIRY = 900
