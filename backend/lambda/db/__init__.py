"""
Database operations package.

Re-exports all public functions for backward compatibility.
"""

from db.cases import get_cases, get_case_detail, update_case, generate_image_urls
from db.edit_history import (
    get_case_edit_history,
    save_edit_job,
    get_edit_job_status,
    update_edit_job_status,
)
from db.preferences import get_preferences, delete_preference, update_preference
from db.settings import (
    get_settings,
    update_settings,
    delete_user_settings,
    DEFAULT_AGENT_MODELS,
    AVAILABLE_MODEL_KEYS,
    DEFAULT_DATA_SOURCE,
    VALID_DATA_SOURCES,
)
from db.rejected import get_rejected_preferences
from db.data_ops import (
    reset_user_data,
    load_synthetic_cases,
    load_mimic_cases,
    validate_mimic_bucket_access,
)
from db.idempotency import (
    check_idempotency,
    claim_idempotency_key,
    store_idempotency_result,
)

__all__ = [
    # cases
    "get_cases",
    "get_case_detail",
    "update_case",
    "generate_image_urls",
    # edit_history
    "get_case_edit_history",
    "save_edit_job",
    "get_edit_job_status",
    "update_edit_job_status",
    # preferences
    "get_preferences",
    "delete_preference",
    "update_preference",
    # settings
    "get_settings",
    "update_settings",
    "delete_user_settings",
    "DEFAULT_AGENT_MODELS",
    "AVAILABLE_MODEL_KEYS",
    "DEFAULT_DATA_SOURCE",
    "VALID_DATA_SOURCES",
    # rejected
    "get_rejected_preferences",
    # data_ops
    "reset_user_data",
    "load_synthetic_cases",
    "load_mimic_cases",
    "validate_mimic_bucket_access",
    # idempotency
    "check_idempotency",
    "claim_idempotency_key",
    "store_idempotency_result",
]
