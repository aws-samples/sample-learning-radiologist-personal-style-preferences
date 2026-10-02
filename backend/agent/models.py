"""
Pydantic models for API requests and responses.

Provides type safety, validation, and documentation for all API operations.
"""

from pydantic import BaseModel, Field
from typing import Literal, Optional


# Safe preference categories - ONLY stylistic preferences are allowed
SAFE_CATEGORIES = Literal["terminology", "formatting", "detail_level", "phrasing", "priority"]


# =============================================================================
# Preference Inference (Structured Output from LLM)
# =============================================================================

class InferredPreference(BaseModel):
    """Structured output model for LLM preference inference.

    Used with Strands structured_output to get rich preference metadata.
    Category is restricted to safe stylistic categories only.
    """
    preference_text: str = Field(
        description="A clear, actionable STYLISTIC preference statement (terminology, formatting, phrasing only)"
    )
    category: SAFE_CATEGORIES = Field(
        description="Category of preference - MUST be one of: terminology, formatting, detail_level, phrasing, priority"
    )
    confidence: float = Field(
        description="Confidence level from 0.0 to 1.0 that this preference is intentional",
        ge=0.0,
        le=1.0
    )
    inference_explanation: str = Field(
        description="Explanation of HOW this preference was derived from the edit - what specific changes were observed and why they indicate this preference"
    )


class ExtractedChange(BaseModel):
    """A single change identified in an edit.

    Each edit may contain multiple changes - some stylistic (safe) and some
    content-adding (unsafe). This model captures each atomic change.
    """
    change_description: str = Field(
        description="Description of what changed (e.g., 'Changed from prose to bullet points')"
    )
    is_stylistic: bool = Field(
        description="True if this is a STYLISTIC change (formatting, terminology, phrasing), False if it ADDS or CHANGES clinical content"
    )
    category: Optional[SAFE_CATEGORIES] = Field(
        default=None,
        description="Category if stylistic (terminology, formatting, detail_level, phrasing, priority), None if content-adding"
    )
    preference_text: Optional[str] = Field(
        default=None,
        description="Actionable preference statement if stylistic, None if content-adding"
    )
    rejection_reason: Optional[str] = Field(
        default=None,
        description="Reason for rejection if content-adding (e.g., 'Adds clinical interpretation not in findings')"
    )
    confidence: float = Field(
        description="Confidence that this classification is correct (0.0-1.0)",
        ge=0.0,
        le=1.0
    )


class ExtractedChanges(BaseModel):
    """Collection of all changes identified in an edit.

    Allows extracting MULTIPLE preferences from a single edit, keeping only
    the stylistic ones while explaining why others were rejected.
    """
    changes: list[ExtractedChange] = Field(
        description="List of all atomic changes identified in the edit"
    )
    summary: str = Field(
        description="Brief summary of the overall edit (e.g., '2 stylistic changes identified, 1 clinical change rejected')"
    )


class ValidationResult(BaseModel):
    """Result from preference validation - determines if a preference is safe to store.

    Used by the preference validator agent to check if preferences are stylistic-only.
    """
    is_stylistic: bool = Field(
        description="True if the preference is purely about style (safe), False if it adds clinical content (dangerous)"
    )
    reason: str = Field(
        description="Explanation of why the preference was classified as stylistic or content-adding"
    )
    risk_level: Literal["none", "low", "medium", "high"] = Field(
        description="Risk level: none/low for safe preferences, medium/high for potentially dangerous ones"
    )


# =============================================================================
# API Response Models
# =============================================================================

class AppliedPreference(BaseModel):
    """A preference that was applied during generation."""
    preference_id: str = Field(description="Unique identifier for the preference")
    preference_text: str = Field(description="The preference statement that was applied")


# =============================================================================
# Generation Trace Models (X4 — AI Reasoning panel)
# =============================================================================

class RetrievedPreferenceTrace(BaseModel):
    """A single preference retrieved by k-NN, with similarity score."""
    preference_id: str
    preference_text: str
    similarity_score: float  # cosine similarity 0-1
    source_case_id: Optional[str] = None
    category: Optional[str] = None


class RetrievalTrace(BaseModel):
    """Trace of the k-NN preference retrieval step."""
    total_preferences: int    # all user preferences
    k_requested: int          # k setting
    k_returned: int           # actual count returned
    retrieved: list[RetrievedPreferenceTrace] = Field(default_factory=list)


class RefinementTrace(BaseModel):
    """Trace of the style refinement step."""
    was_applied: bool         # False if no preferences
    base_length: int          # chars in base impression
    refined_length: int       # chars in refined impression
    edit_distance: float      # normalized Levenshtein 0-1
    model_id: Optional[str] = None


class GenerationTrace(BaseModel):
    """Full trace of the generation pipeline for the AI Reasoning panel."""
    retrieval: Optional[RetrievalTrace] = None
    base_generation_model: Optional[str] = None
    refinement: Optional[RefinementTrace] = None


class GenerateImpressionResponse(BaseModel):
    """Response from generate_impression operation."""
    impression: str = Field(description="Generated radiology impression text (after preferences applied)")
    base_impression: str = Field(description="Base impression before preferences were applied")
    preferences_used: int = Field(description="Number of preferences applied during generation")
    preferences_applied: list[AppliedPreference] = Field(
        default_factory=list,
        description="List of preferences that were applied during generation"
    )
    case_id: str = Field(description="Case identifier")
    # Model attribution
    base_impression_model: Optional[str] = Field(
        default=None,
        description="Model ID used to generate the base impression"
    )
    refinement_model: Optional[str] = Field(
        default=None,
        description="Model ID used for style refinement (None if no preferences applied)"
    )
    # Generation trace for AI Reasoning panel
    trace: Optional[GenerationTrace] = Field(
        default=None,
        description="Trace data for the AI Reasoning panel"
    )


class SavedPreference(BaseModel):
    """A preference that was successfully saved."""
    preference_id: str = Field(description="Unique identifier for the saved preference")
    preference_text: str = Field(description="The preference statement")
    category: str = Field(description="Category of the preference")
    confidence: float = Field(description="Confidence level")


class RejectedChange(BaseModel):
    """A change that was identified but rejected (content-adding)."""
    change_description: str = Field(description="What was changed")
    rejection_reason: str = Field(description="Why it was rejected")


class SaveEditResponse(BaseModel):
    """Response from save_edit operation.

    Now supports multiple preferences from a single edit.
    """
    edit_id: str = Field(description="Unique identifier for this edit")
    edit_distance: float = Field(description="Normalized edit distance between original and edited")
    # Multiple preferences support
    preferences_saved: list[SavedPreference] = Field(
        default_factory=list,
        description="List of stylistic preferences that were saved"
    )
    changes_rejected: list[RejectedChange] = Field(
        default_factory=list,
        description="List of content-adding changes that were rejected"
    )
    summary: str = Field(
        default="",
        description="Human-readable summary of what was learned/rejected"
    )
    # Legacy fields for backward compatibility
    preference_inferred: bool = Field(description="Whether any preferences were inferred from this edit")
    preference_id: Optional[str] = Field(default=None, description="ID of first inferred preference (legacy)")
    preference_text: Optional[str] = Field(default=None, description="Text of first inferred preference (legacy)")
    preference_category: Optional[str] = Field(default=None, description="Category of first inferred preference (legacy)")
    preference_confidence: Optional[float] = Field(default=None, description="Confidence of first inferred preference (legacy)")
    rejection_reason: Optional[str] = Field(default=None, description="Reason if all preferences were rejected (legacy)")


class PreferenceItem(BaseModel):
    """A single user preference."""
    preference_id: str = Field(description="Unique identifier for the preference")
    preference_text: str = Field(description="The preference statement")
    category: Optional[str] = Field(default=None, description="Category of preference")
    confidence: Optional[float] = Field(default=None, description="Confidence level")
    created_at: str = Field(description="ISO timestamp when preference was created")
    source_case_id: Optional[str] = Field(default=None, description="Case that triggered this preference")


class GetPreferencesResponse(BaseModel):
    """Response from get_preferences operation."""
    user_id: str = Field(description="User identifier")
    preferences: list[PreferenceItem] = Field(description="List of user preferences")
    count: int = Field(description="Total number of preferences")


class CaseItem(BaseModel):
    """A single case in the case list."""
    case_id: str = Field(description="Unique case identifier")
    modality: str = Field(description="Imaging modality (e.g., CT, MRI, X-ray)")
    body_part: str = Field(description="Body part examined")
    created_at: str = Field(description="ISO timestamp when case was created")
    has_impression: bool = Field(description="Whether an impression has been generated")


class GetCasesResponse(BaseModel):
    """Response from get_cases operation."""
    user_id: str = Field(description="User identifier")
    cases: list[CaseItem] = Field(description="List of cases")
    count: int = Field(description="Total number of cases")


class CaseDetail(BaseModel):
    """Full case detail."""
    case_id: str = Field(description="Unique case identifier")
    user_id: str = Field(description="User identifier")
    modality: str = Field(description="Imaging modality")
    body_part: str = Field(description="Body part examined")
    findings: str = Field(description="Radiology findings text")
    generated_impression: Optional[str] = Field(default=None, description="AI-generated impression")
    edited_impression: Optional[str] = Field(default=None, description="User-edited impression")
    created_at: str = Field(description="ISO timestamp when case was created")
    updated_at: Optional[str] = Field(default=None, description="ISO timestamp of last update")


class ErrorResponse(BaseModel):
    """Error response."""
    error: str = Field(description="Error message")
