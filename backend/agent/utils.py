"""
Shared utilities for CIPHER backend.

Provides common utilities used across agent and Lambda code.
"""

import json
from decimal import Decimal


class DecimalEncoder(json.JSONEncoder):
    """
    Handle Decimal types from DynamoDB for JSON serialization.

    DynamoDB returns numeric values as Decimal to preserve precision.
    This encoder converts them to float for JSON serialization.
    """

    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super().default(obj)


def decimals_to_float(obj):
    """Recursively convert DynamoDB Decimal values to Python floats.

    Use when preparing DynamoDB query results for JSON serialization
    or any context that doesn't accept Decimal types.
    """
    if isinstance(obj, Decimal):
        return float(obj)
    elif isinstance(obj, dict):
        return {k: decimals_to_float(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [decimals_to_float(item) for item in obj]
    return obj


def floats_to_decimal(obj):
    """Recursively convert Python floats to Decimal for DynamoDB storage.

    Uses str() intermediary to avoid floating-point precision artifacts.
    """
    if isinstance(obj, float):
        return Decimal(str(obj))
    elif isinstance(obj, dict):
        return {k: floats_to_decimal(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [floats_to_decimal(item) for item in obj]
    return obj


def embedding_to_decimals(embedding: list[float]) -> list[Decimal]:
    """Convert a float embedding vector to Decimals for DynamoDB storage."""
    return [Decimal(str(f)) for f in embedding]


def embedding_to_floats(embedding: list) -> list[float]:
    """Convert a DynamoDB Decimal embedding vector to floats."""
    return [float(d) for d in embedding]
