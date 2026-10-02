"""
Shared security patterns for prompt injection detection and content-adding filtering.

Single source of truth imported by both Lambda (backend/lambda/safety.py)
and Agent (backend/agent/security.py) deployments.
"""

import re
import unicodedata


# =============================================================================
# Input Normalization (run before pattern matching)
# =============================================================================


def normalize_for_detection(text: str) -> str:
    """Normalize text so injection/keyword matching can't be evaded with
    Unicode or spacing tricks.

    Applies, in order:
      1. NFKC normalization — folds compatibility characters (full-width,
         styled, sub/superscript, ligature forms) to their canonical ASCII
         equivalent, e.g. "ＩＧＮＯＲＥ" / "𝐢𝐠𝐧𝐨𝐫𝐞" -> "ignore". This collapses
         the most common "looks-like-ASCII" evasion class into text the
         existing regex blocklist matches.
      2. Whitespace normalization — newlines, tabs, and runs of spaces collapse
         to a single space, so multi-line / tab-padded injections still match
         patterns that expect a single `\\s+` between words.

    This is a hardening pass over the existing regex blocklist, not a complete
    defense. It does NOT defend against:
      - cross-script homoglyphs (e.g. Cyrillic 'а' for Latin 'a'), which NFKC
        does not fold;
      - per-letter spacing (e.g. "i g n o r e"), since spaces can't be stripped
        without breaking the multi-word patterns.
    Closing those requires a semantic filter such as Bedrock Guardrails
    PROMPT_ATTACK (tracked separately as a roadmap item).

    Args:
        text: Raw user-provided text.

    Returns:
        Normalized text suitable for case-insensitive pattern matching.
    """
    if not text:
        return text
    normalized = unicodedata.normalize("NFKC", text)
    normalized = re.sub(r"\s+", " ", normalized)
    return normalized


# =============================================================================
# Prompt Injection Detection
# =============================================================================

# Patterns that indicate prompt injection attempts
INJECTION_PATTERNS = [
    r"ignore\s+(previous|all|prior)\s+instructions?",
    r"disregard\s+(previous|all|prior)",
    r"new\s+instructions?:",
    r"</?(system|user|assistant|prompt)>",
    r"\[ADMIN\]|\[SYSTEM\]|\[OVERRIDE\]",
    r"forget\s+everything",
    r"you\s+are\s+now",
    r"act\s+as\s+(if|a)",
    r"pretend\s+(you|to\s+be)",
    r"from\s+now\s+on",
    r"override\s+safety",
    r"bypass\s+(safety|filter|guardrail)",
]


# =============================================================================
# Content-Adding Keyword Detection
# =============================================================================

# Keywords that indicate content-adding preferences (not allowed)
CONTENT_ADDING_KEYWORDS = [
    # Action verbs that add content
    "add", "include", "mention", "recommend", "suggest", "consider",
    # Clinical content types
    "treatment", "medication", "antibiotic", "therapy", "intervention",
    "differential", "diagnosis", "diagnoses",
    "rule out", "workup", "follow-up", "follow up", "followup",
    "correlation", "clinical correlation",
    "pathology", "prognosis",
    # Recommendation patterns
    "should be", "needs to be", "requires",
]

# Patterns that indicate formatting even if they contain a content-adding keyword.
# These are checked BEFORE the keyword filter to avoid false positives on
# structural/label changes like "Add an 'Impression' header".
_FORMATTING_EXEMPTION_PATTERNS = [
    re.compile(r"\b(add|include|prepend|start with|begin with)\b.{0,20}\b(header|heading|label|title|section label|prefix)\b", re.IGNORECASE),
    re.compile(r"\b(header|heading|label|title|prefix)\b.{0,20}\b(impression|findings|conclusion|summary|report)\b", re.IGNORECASE),
    re.compile(r"\b(impression|findings|conclusion|summary):\s*$", re.IGNORECASE),
]


def _is_formatting_exemption(text: str) -> bool:
    """Check if text matches a known formatting pattern that should bypass keyword filter."""
    return any(p.search(text) for p in _FORMATTING_EXEMPTION_PATTERNS)
