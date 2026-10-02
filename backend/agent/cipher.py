"""
CIPHER Algorithm Implementation

Based on "Aligning LLM Agents by Learning Latent Preference from User Edits"
(Gao et al., NeurIPS 2024, arXiv:2404.15269)

This module provides the core CIPHER algorithm components:
1. Cosine similarity for embedding comparison
2. k-NN retrieval for finding similar preferences
3. Preference aggregation into prompt instructions
4. Edit distance calculation for significance detection
"""

import logging

import numpy as np

from config import MIN_EDIT_DISTANCE_FOR_PREFERENCE
from utils import embedding_to_floats


logger = logging.getLogger(__name__)


def cosine_similarity(a: list[float], b: list[float]) -> float:
    """
    Compute cosine similarity between two embedding vectors.

    Args:
        a: First embedding vector
        b: Second embedding vector

    Returns:
        Cosine similarity between 0 and 1
    """
    a_arr = np.array(embedding_to_floats(a))
    b_arr = np.array(embedding_to_floats(b))
    dot_product = np.dot(a_arr, b_arr)
    norm_a = np.linalg.norm(a_arr)
    norm_b = np.linalg.norm(b_arr)
    if norm_a == 0 or norm_b == 0:
        return 0.0
    return float(dot_product / (norm_a * norm_b))


def retrieve_similar_preferences(
    query_embedding: list[float],
    preferences: list[dict],
    k: int = 5
) -> list[dict]:
    """
    Retrieve k most similar preferences based on context embedding.

    This implements the k-NN retrieval step of CIPHER: given the current
    context (findings), find preferences learned from similar past contexts.

    Args:
        query_embedding: Embedding of current findings
        preferences: List of preference dicts with 'context_embedding' key
        k: Number of similar preferences to retrieve

    Returns:
        List of k most similar preferences, sorted by similarity (descending)
    """
    if not preferences:
        return []

    # Calculate similarity for each preference
    similarities = []
    for pref in preferences:
        if "context_embedding" in pref and pref["context_embedding"]:
            sim = cosine_similarity(query_embedding, pref["context_embedding"])
            similarities.append((pref, sim))

    # Sort by similarity (descending) and take top k
    similarities.sort(key=lambda x: x[1], reverse=True)

    logger.debug(f"Retrieved {min(k, len(similarities))} similar preferences from {len(preferences)} total")
    result = []
    for pref, sim in similarities[:k]:
        pref_with_score = dict(pref)
        pref_with_score["_similarity_score"] = sim
        result.append(pref_with_score)
    return result


def aggregate_preferences(preferences: list[dict]) -> str:
    """
    Aggregate multiple preferences into a single instruction string.

    This implements the preference aggregation step of CIPHER: combine
    multiple retrieved preferences into a coherent prompt instruction.

    Args:
        preferences: List of preference dicts with 'preference_text' key

    Returns:
        Formatted string of aggregated preferences for prompt injection
    """
    if not preferences:
        return ""

    pref_texts = [p["preference_text"] for p in preferences if "preference_text" in p]
    if not pref_texts:
        return ""

    # Number each preference for clarity, with conditional framing
    numbered = [f"{i+1}. (If applicable) {text}" for i, text in enumerate(pref_texts)]
    return "Apply these style preferences ONLY where the topic is mentioned in findings:\n" + "\n".join(numbered)


def calculate_edit_distance(original: str, edited: str) -> float:
    """
    Calculate normalized Levenshtein edit distance between two strings.

    Uses a simple implementation to avoid external dependencies.

    Args:
        original: Original generated text
        edited: User's edited text

    Returns:
        Value between 0 (identical) and 1 (completely different)
    """
    if original == edited:
        return 0.0

    if not original:
        return 1.0 if edited else 0.0
    if not edited:
        return 1.0

    # Levenshtein distance using dynamic programming
    len_orig = len(original)
    len_edit = len(edited)

    # Create distance matrix
    dp = [[0] * (len_edit + 1) for _ in range(len_orig + 1)]

    # Initialize base cases
    for i in range(len_orig + 1):
        dp[i][0] = i
    for j in range(len_edit + 1):
        dp[0][j] = j

    # Fill the matrix
    for i in range(1, len_orig + 1):
        for j in range(1, len_edit + 1):
            if original[i-1] == edited[j-1]:
                dp[i][j] = dp[i-1][j-1]
            else:
                dp[i][j] = 1 + min(
                    dp[i-1][j],      # deletion
                    dp[i][j-1],      # insertion
                    dp[i-1][j-1]     # substitution
                )

    # Normalize by max length
    max_len = max(len_orig, len_edit)
    return dp[len_orig][len_edit] / max_len


def should_infer_preference(
    original: str,
    edited: str,
    threshold: float = None
) -> bool:
    """
    Determine if an edit is significant enough to warrant preference inference.

    The CIPHER algorithm only infers preferences from edits that indicate
    a meaningful style change, not minor typo corrections.

    Args:
        original: Original generated impression
        edited: User's edited impression
        threshold: Minimum edit distance to trigger inference (default from config)

    Returns:
        True if edit is significant, False otherwise
    """
    if threshold is None:
        threshold = MIN_EDIT_DISTANCE_FOR_PREFERENCE

    distance = calculate_edit_distance(original, edited)
    will_infer = distance > threshold

    logger.info(f"Edit distance: {distance:.4f}, threshold: {threshold}, will_infer: {will_infer}")
    return will_infer
