"""
Security utilities for CIPHER backend.

Provides security functions used by the Strands agent:
- Prompt injection detection (with word-boundary matching)
- Input sanitization
- Content-adding keyword detection (with formatting exemptions)

Patterns and keywords are imported from the shared module (backend/shared/)
which is the single source of truth for both Lambda and Agent deployments.
"""

import re

from shared.security_patterns import (
    INJECTION_PATTERNS,
    CONTENT_ADDING_KEYWORDS,
    _FORMATTING_EXEMPTION_PATTERNS,
    _is_formatting_exemption,
    normalize_for_detection,
)


def detect_prompt_injection(text: str) -> tuple[bool, str]:
    """
    Detect potential prompt injection attempts in user input.

    Args:
        text: User-provided text to analyze

    Returns:
        Tuple of (is_injection, matched_pattern)
    """
    if not text:
        return False, ""

    # Normalize first so Unicode/whitespace tricks can't slip past the blocklist.
    text_lower = normalize_for_detection(text).lower()
    for pattern in INJECTION_PATTERNS:
        if re.search(pattern, text_lower, re.IGNORECASE):
            return True, pattern

    return False, ""


def sanitize_user_input(text: str) -> str:
    """
    Sanitize user input by escaping XML-like tags that could break prompt structure.

    Args:
        text: User-provided text

    Returns:
        Sanitized text with angle brackets escaped
    """
    if not text:
        return text

    # Escape angle brackets to prevent prompt injection via XML tags
    text = text.replace("<", "&lt;").replace(">", "&gt;")
    return text


# =============================================================================
# Content-Adding Keyword Detection
# =============================================================================


def is_content_adding_preference(preference_text: str) -> tuple[bool, str]:
    """
    Fast heuristic check if a preference appears to add clinical content.

    This is a first-pass filter before calling the more expensive LLM validator.
    Formatting exemptions (e.g. section headers like "Impression:") bypass the
    keyword filter since they describe existing content structure, not new
    clinical information.

    Args:
        preference_text: The inferred preference text

    Returns:
        Tuple of (is_content_adding, matched_keyword)
    """
    if not preference_text:
        return False, ""

    text_lower = normalize_for_detection(preference_text).lower()

    # Check formatting exemptions first — these are safe even if they match keywords
    if _is_formatting_exemption(text_lower):
        return False, ""

    for keyword in CONTENT_ADDING_KEYWORDS:
        if keyword in text_lower:
            return True, keyword

    return False, ""
