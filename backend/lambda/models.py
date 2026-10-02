"""
Pydantic request/response models for Lambda handler.

Provides type safety and validation for all API request bodies.
Reuses SAFE_CATEGORIES concept from the agent models.
"""

from pydantic import BaseModel, Field
from typing import Any, Literal, Optional

from shared.validation_limits import MAX_FINDINGS_LENGTH, MAX_IMPRESSION_LENGTH, MAX_CASE_ID_LENGTH

MAX_PREFERENCE_TEXT_LENGTH = MAX_IMPRESSION_LENGTH


# =============================================================================
# Request Models
# =============================================================================


class GenerateRequest(BaseModel):
    """Request body for POST /generate."""
    findings: str = Field(
        ...,
        min_length=1,
        max_length=MAX_FINDINGS_LENGTH,
        description="Radiology findings text",
    )
    case_id: str = Field(
        ...,
        min_length=1,
        max_length=MAX_CASE_ID_LENGTH,
        description="Case identifier",
    )
    clinical_interpretation: bool = Field(
        default=False,
        description="Whether to allow clinical inferences in impressions",
    )
    idempotency_key: Optional[str] = Field(
        default=None,
        max_length=128,
        description="Client-provided key to prevent duplicate processing on retry",
    )


class EditRequest(BaseModel):
    """Request body for POST /edit."""
    case_id: str = Field(
        ...,
        min_length=1,
        max_length=MAX_CASE_ID_LENGTH,
        description="Case identifier",
    )
    original_impression: str = Field(
        ...,
        min_length=1,
        max_length=MAX_IMPRESSION_LENGTH,
        description="AI-generated impression before edit",
    )
    edited_impression: str = Field(
        ...,
        min_length=1,
        max_length=MAX_IMPRESSION_LENGTH,
        description="User's edited version of the impression",
    )
    findings: str = Field(
        ...,
        min_length=1,
        max_length=MAX_FINDINGS_LENGTH,
        description="Original radiology findings",
    )
    idempotency_key: Optional[str] = Field(
        default=None,
        max_length=128,
        description="Client-provided key to prevent duplicate processing on retry",
    )


class UpdateCaseRequest(BaseModel):
    """Request body for PUT /cases/{caseId}."""
    findings: str = Field(
        ...,
        min_length=1,
        max_length=MAX_FINDINGS_LENGTH,
        description="Updated findings text",
    )


class UpdatePreferenceRequest(BaseModel):
    """Request body for PUT /preferences/{preferenceId}."""
    preference_text: str = Field(
        ...,
        min_length=1,
        max_length=MAX_PREFERENCE_TEXT_LENGTH,
        description="New preference text",
    )


class UpdateSettingsRequest(BaseModel):
    """Request body for PUT /settings."""
    model_settings: Optional[dict] = Field(
        default=None,
        description="Model settings mapping agent names to model keys",
    )
    k_preferences: Optional[int] = Field(
        default=None,
        description="Number of preferences for k-NN retrieval",
    )
    data_source: Optional[str] = Field(
        default=None,
        description="Data source: 'synthetic' or 'mimic'",
    )
    mimic_bucket: Optional[str] = Field(
        default=None,
        description="S3 bucket name for MIMIC data",
    )
    clinical_interpretation: Optional[bool] = Field(
        default=None,
        description="Whether to allow clinical interpretation",
    )


class ValidateBucketRequest(BaseModel):
    """Request body for POST /settings/validate-bucket."""
    bucket: str = Field(
        ...,
        min_length=1,
        description="S3 bucket name to validate",
    )
