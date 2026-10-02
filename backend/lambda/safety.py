"""
Safety layer for prompt injection detection and content-adding preference filtering.

Patterns are imported from the shared module (backend/shared/) which is the single
source of truth for both Lambda and Agent deployments.
"""

import re

from shared.security_patterns import (
    INJECTION_PATTERNS,
    CONTENT_ADDING_KEYWORDS,
    normalize_for_detection,
)


def detect_prompt_injection(text: str) -> tuple[bool, str]:
    """Detect potential prompt injection attempts in user input.

    Args:
        text: User-provided text to analyze.

    Returns:
        Tuple of (is_injection, matched_pattern).
    """
    if not text:
        return False, ""

    # Normalize first so Unicode/whitespace tricks can't slip past the blocklist.
    text_lower = normalize_for_detection(text).lower()
    for pattern in INJECTION_PATTERNS:
        match = re.search(pattern, text_lower, re.IGNORECASE)
        if match:
            return True, pattern

    return False, ""


def is_content_adding_preference(preference_text: str) -> tuple[bool, str]:
    """Fast heuristic check for content-adding preferences.

    Args:
        preference_text: Preference text to analyze.

    Returns:
        Tuple of (is_content_adding, matched_keyword).
    """
    if not preference_text:
        return False, ""

    text_lower = normalize_for_detection(preference_text).lower()
    for keyword in CONTENT_ADDING_KEYWORDS:
        if keyword in text_lower:
            return True, keyword

    return False, ""
