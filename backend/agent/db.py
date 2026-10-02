"""
DynamoDB Operations for Agent

Provides database operations for:
- Cases: radiology cases with findings and impressions
- EditHistory: tracks user edits for analysis
- Preferences: learned style preferences with context embeddings
"""

import json
import logging
import time
import uuid
from decimal import Decimal

import boto3

from utils import decimals_to_float, embedding_to_decimals, embedding_to_floats

from config import (
    AWS_REGION,
    CASES_TABLE,
    EDIT_HISTORY_TABLE,
    PREFERENCES_TABLE,
    REJECTED_PREFERENCES_TABLE,
)

# Re-export embed_text for backward compatibility
# (some modules import it from db)
from embeddings import embed_text, EmbeddingError  # noqa: F401


# Configure logging
logger = logging.getLogger(__name__)

# DynamoDB resource (reused across invocations)
dynamodb = boto3.resource("dynamodb", region_name=AWS_REGION)


# =============================================================================
# Cases Table Operations
# =============================================================================


def get_cases(user_id: str) -> dict:
    """
    Get all cases for a user.

    Args:
        user_id: User identifier

    Returns:
        Dict with user_id, count, and list of case summaries
    """
    logger.debug(f"Fetching cases for user={user_id}")
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

    logger.info(f"Found {len(cases)} cases for user={user_id}")
    return {
        "user_id": user_id,
        "count": len(cases),
        "cases": cases,
    }


def get_case_detail(user_id: str, case_id: str) -> dict:
    """
    Get full details for a specific case.

    Args:
        user_id: User identifier
        case_id: Case identifier

    Returns:
        Dict with full case details or error if not found
    """
    logger.debug(f"Fetching case detail: user={user_id}, case={case_id}")
    table = dynamodb.Table(CASES_TABLE)

    response = table.get_item(Key={"user_id": user_id, "case_id": case_id})
    case = response.get("Item")

    if not case:
        logger.warning(f"Case not found: user={user_id}, case={case_id}")
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
    return result


def update_case_impression(
    user_id: str,
    case_id: str,
    generated_impression: str = None,
    edited_impression: str = None,
    preferences_applied: list = None,
    base_impression: str = None,
    base_impression_model: str = None,
    refinement_model: str = None,
) -> None:
    """
    Update case with generated or edited impression.

    Args:
        user_id: User identifier
        case_id: Case identifier
        generated_impression: AI-generated impression (optional)
        edited_impression: User-edited impression (optional)
        preferences_applied: List of preferences used during generation (optional)
        base_impression: Impression before preferences applied (optional)
        base_impression_model: Model ID used for base impression generation (optional)
        refinement_model: Model ID used for style refinement (optional)
    """
    table = dynamodb.Table(CASES_TABLE)

    update_expr_parts = []
    expr_values = {}

    if generated_impression is not None:
        update_expr_parts.append("generated_impression = :gen")
        expr_values[":gen"] = generated_impression
        # Store generation timestamp
        update_expr_parts.append("generated_at = :gen_at")
        expr_values[":gen_at"] = int(time.time())
    if edited_impression is not None:
        update_expr_parts.append("edited_impression = :edit")
        expr_values[":edit"] = edited_impression
        # Store edit timestamp
        update_expr_parts.append("edited_at = :edit_at")
        expr_values[":edit_at"] = int(time.time())
    if preferences_applied is not None:
        # Store as JSON string for DynamoDB
        update_expr_parts.append("preferences_applied = :prefs")
        expr_values[":prefs"] = json.dumps(preferences_applied)
    if base_impression is not None:
        update_expr_parts.append("base_impression = :base")
        expr_values[":base"] = base_impression
    if base_impression_model is not None:
        update_expr_parts.append("base_impression_model = :base_model")
        expr_values[":base_model"] = base_impression_model
    if refinement_model is not None:
        update_expr_parts.append("refinement_model = :ref_model")
        expr_values[":ref_model"] = refinement_model

    if update_expr_parts:
        logger.debug(f"Updating case impression: user={user_id}, case={case_id}")
        table.update_item(
            Key={"user_id": user_id, "case_id": case_id},
            UpdateExpression="SET " + ", ".join(update_expr_parts),
            ExpressionAttributeValues=expr_values
        )


# =============================================================================
# Preferences Table Operations
# =============================================================================


def get_user_preferences(user_id: str) -> list[dict]:
    """
    Query all preferences for a user from DynamoDB.

    Returns full preference data including embeddings for k-NN retrieval.

    Args:
        user_id: User identifier

    Returns:
        List of preference dicts with embeddings converted to floats
    """
    logger.debug(f"Fetching preferences for user={user_id}")
    table = dynamodb.Table(PREFERENCES_TABLE)

    response = table.query(
        KeyConditionExpression="user_id = :uid",
        ExpressionAttributeValues={":uid": user_id}
    )

    items = response.get("Items", [])
    for item in items:
        if "context_embedding" in item:
            item["context_embedding"] = embedding_to_floats(item["context_embedding"])

    logger.info(f"Found {len(items)} preferences for user={user_id}")
    return items


def get_preferences(user_id: str) -> dict:
    """
    Get all preferences for a user (API response format, without embeddings).

    Args:
        user_id: User identifier

    Returns:
        Dict with user_id, count, and list of preferences (without embeddings)
    """
    preferences = get_user_preferences(user_id)

    # Remove embeddings from response (too large for API)
    # Include all other fields for traceability
    clean_prefs = []
    for p in preferences:
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
        if "inference_explanation" in p:
            pref_item["inference_explanation"] = p.get("inference_explanation")
        # Include user edit tracking fields if present
        if "original_inferred_text" in p:
            pref_item["original_inferred_text"] = p.get("original_inferred_text")
        if "last_edited_at" in p:
            pref_item["last_edited_at"] = p.get("last_edited_at")
        if "user_edit_count" in p:
            pref_item["user_edit_count"] = p.get("user_edit_count")
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
        if "inference_model" in p:
            pref_item["inference_model"] = p.get("inference_model")
        clean_prefs.append(pref_item)

    return {
        "user_id": user_id,
        "count": len(clean_prefs),
        "preferences": clean_prefs,
    }


def store_preference(
    user_id: str,
    preference_text: str,
    context_embedding: list[float],
    source_case_id: str,
    category: str = None,
    confidence: float = None,
    inference_explanation: str = None,
    source_edit_id: str = None,
    original_impression: str = None,
    edited_impression: str = None,
    context_findings: str = None,
    edit_distance: float = None,
    inference_model: str = None,
) -> dict:
    """
    Store a new preference in DynamoDB.

    Args:
        user_id: User identifier
        preference_text: Natural language preference description
        context_embedding: Embedding vector for similarity search
        source_case_id: Case ID that originated this preference
        category: Preference category (terminology, formatting, detail_level, phrasing, priority)
        confidence: Confidence level (0.0-1.0) that this is intentional style preference
        inference_explanation: LLM explanation of HOW this preference was derived from the edit
        source_edit_id: Link to specific edit in EditHistory (for traceability)
        original_impression: The AI-generated text before edit (for traceability)
        edited_impression: The user's edited text (for traceability)
        context_findings: The findings text (for traceability, readable unlike embedding)
        edit_distance: How significant the edit was 0.0-1.0 (for traceability)
        inference_model: Model ID used to infer this preference (for traceability)

    Returns:
        Dict with preference_id and preference_text
    """
    table = dynamodb.Table(PREFERENCES_TABLE)
    preference_id = f"pref_{int(time.time())}_{uuid.uuid4().hex[:8]}"

    embedding_decimals = embedding_to_decimals(context_embedding)

    item = {
        "user_id": user_id,
        "preference_id": preference_id,
        "preference_text": preference_text,
        "context_embedding": embedding_decimals,
        "source_case_id": source_case_id,
        "timestamp": int(time.time()),
    }

    # Add optional structured output fields
    if category is not None:
        item["category"] = category
    if confidence is not None:
        item["confidence"] = Decimal(str(confidence))
    if inference_explanation is not None:
        item["inference_explanation"] = inference_explanation

    # Add traceability fields
    if source_edit_id is not None:
        item["source_edit_id"] = source_edit_id
    if original_impression is not None:
        item["original_impression"] = original_impression
    if edited_impression is not None:
        item["edited_impression"] = edited_impression
    if context_findings is not None:
        item["context_findings"] = context_findings
    if edit_distance is not None:
        item["edit_distance"] = Decimal(str(edit_distance))
    if inference_model is not None:
        item["inference_model"] = inference_model

    logger.info(f"Storing preference: user={user_id}, id={preference_id}, category={category}, model={inference_model}")
    table.put_item(Item=item)

    return {"preference_id": preference_id, "preference_text": preference_text}


# =============================================================================
# Edit History Table Operations
# =============================================================================


def store_edit_history(
    user_id: str,
    case_id: str,
    original: str,
    edited: str,
    edit_distance: float,
    source: str = "user_edit",
    preferences_snapshot: list[dict] = None,
    generation_model: str = None,
) -> str:
    """
    Store edit in history table.

    Args:
        user_id: User identifier
        case_id: Case identifier
        original: Original impression (base for generation, AI-generated for user edit)
        edited: Resulting impression (after preferences for generation, user's edit for user edit)
        edit_distance: Normalized edit distance
        source: Source of this entry - "user_edit" or "generation"
        preferences_snapshot: For generation source, list of preferences used at this point in time
                              Each entry: {"preference_id": str, "preference_text": str}
        generation_model: For "generation" source, the model ID that produced `edited`
                          (style-refinement model, or base model when no preferences applied).
                          None for "user_edit" entries (a human produced the text).

    Returns:
        Edit ID
    """
    table = dynamodb.Table(EDIT_HISTORY_TABLE)
    edit_id = f"edit_{int(time.time())}_{uuid.uuid4().hex[:8]}"

    item = {
        "user_id": user_id,
        "edit_id": edit_id,
        "case_id": case_id,
        "original_impression": original,
        "edited_impression": edited,
        "edit_distance": Decimal(str(edit_distance)),
        "timestamp": int(time.time()),
        "source": source,
    }

    # Store preferences snapshot for generation entries
    if preferences_snapshot:
        item["preferences_snapshot"] = json.dumps(preferences_snapshot)

    # Tag the model that produced this output (generation entries only)
    if generation_model is not None:
        item["generation_model"] = generation_model

    logger.debug(f"Storing edit history: user={user_id}, case={case_id}, edit_id={edit_id}, source={source}")
    table.put_item(Item=item)

    return edit_id


def get_case_edit_history(user_id: str, case_id: str) -> list[dict]:
    """
    Get all edit history entries for a specific case, ordered by timestamp.

    Args:
        user_id: User identifier
        case_id: Case identifier

    Returns:
        List of edit history entries sorted by timestamp (oldest first)
    """
    logger.debug(f"Fetching edit history: user={user_id}, case={case_id}")
    table = dynamodb.Table(EDIT_HISTORY_TABLE)

    # Query all edits for user, then filter by case_id
    # (EditHistory has user_id as partition key, edit_id as sort key)
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
        entry = {
            "edit_id": item.get("edit_id"),
            "original_impression": item.get("original_impression"),
            "edited_impression": item.get("edited_impression"),
            "edit_distance": decimals_to_float(item.get("edit_distance", 0)),
            "timestamp": item.get("timestamp"),
            "source": item.get("source", "user_edit"),  # Default to user_edit for old entries
        }
        # Include preferences snapshot if present (for generation entries)
        if "preferences_snapshot" in item:
            try:
                entry["preferences_snapshot"] = json.loads(item.get("preferences_snapshot"))
            except json.JSONDecodeError:
                entry["preferences_snapshot"] = []
        # Include the generating model if recorded (generation entries only)
        if "generation_model" in item:
            entry["generation_model"] = item.get("generation_model")
        edits.append(entry)

    # Sort by timestamp (oldest first for timeline display)
    edits.sort(key=lambda x: x.get("timestamp", 0))

    logger.info(f"Found {len(edits)} edit history entries for case={case_id}")
    return edits


# =============================================================================
# Rejected Preferences Operations
# =============================================================================

def store_rejected_preference(
    user_id: str,
    change_description: str,
    rejection_reason: str,
    rejection_layer: str,
    source_case_id: str,
    source_edit_id: str = None,
    original_impression: str = None,
    edited_impression: str = None,
    context_findings: str = None,
    risk_level: str = None,
    inference_model: str = None,
) -> dict:
    """
    Store a rejected preference change in DynamoDB for audit trail.

    Args:
        user_id: User identifier
        change_description: Description of the change that was rejected
        rejection_reason: Why the change was rejected
        rejection_layer: Which safety layer caught it (e.g., "keyword_filter", "validator_agent")
        source_case_id: Case ID where this change occurred
        source_edit_id: Link to specific edit in EditHistory
        original_impression: The AI-generated text before edit
        edited_impression: The user's edited text
        context_findings: The findings text
        risk_level: Risk level assigned by validator (low, medium, high)
        inference_model: Model ID used for extraction

    Returns:
        Dict with rejection_id
    """
    table = dynamodb.Table(REJECTED_PREFERENCES_TABLE)
    rejection_id = f"rej_{int(time.time())}_{uuid.uuid4().hex[:8]}"

    item = {
        "user_id": user_id,
        "rejection_id": rejection_id,
        "change_description": change_description,
        "rejection_reason": rejection_reason,
        "rejection_layer": rejection_layer,
        "source_case_id": source_case_id,
        "timestamp": int(time.time()),
    }

    # Add optional traceability fields
    if source_edit_id is not None:
        item["source_edit_id"] = source_edit_id
    if original_impression is not None:
        item["original_impression"] = original_impression
    if edited_impression is not None:
        item["edited_impression"] = edited_impression
    if context_findings is not None:
        item["context_findings"] = context_findings
    if risk_level is not None:
        item["risk_level"] = risk_level
    if inference_model is not None:
        item["inference_model"] = inference_model

    logger.info(f"Storing rejected preference: user={user_id}, id={rejection_id}, layer={rejection_layer}")

    table.put_item(Item=item)

    return {"rejection_id": rejection_id}


def get_rejected_preferences(user_id: str) -> list[dict]:
    """
    Get all rejected preference changes for a user.

    Args:
        user_id: User identifier

    Returns:
        List of rejected preference dicts sorted by timestamp (newest first)
    """
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
        # Include optional fields
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

    # Sort by timestamp (newest first)
    rejections.sort(key=lambda x: x.get("timestamp", 0), reverse=True)

    logger.info(f"Found {len(rejections)} rejected preferences for user={user_id}")
    return rejections
