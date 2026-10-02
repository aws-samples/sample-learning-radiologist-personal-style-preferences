"""
Bedrock Embeddings Module

Generates text embeddings using Cohere Embed v4 via AWS Bedrock.
Used for k-NN similarity retrieval in the CIPHER algorithm.
"""

import json
import logging

import boto3
from botocore.exceptions import ClientError

from config import (
    AWS_REGION,
    COHERE_EMBED_MODEL_ID,
    EMBED_OUTPUT_DIMENSION,
)


# Configure logging
logger = logging.getLogger(__name__)

# Bedrock client (reused across invocations)
bedrock_runtime = boto3.client("bedrock-runtime", region_name=AWS_REGION)


class EmbeddingError(Exception):
    """Raised when embedding generation fails."""
    pass


def embed_text(text: str, input_type: str = "search_document") -> list[float]:
    """
    Generate embedding for text using Cohere Embed v4.

    Cohere Embed v4 uses input_type to optimize embeddings for specific use cases:
    - "search_document": Use when storing documents/contexts (e.g., preference contexts)
    - "search_query": Use when embedding queries for retrieval (e.g., findings for k-NN)

    Args:
        text: Text to embed
        input_type: Either "search_document" or "search_query"

    Returns:
        List of floats representing the embedding vector

    Raises:
        EmbeddingError: If the embedding API call fails
    """
    text = text.strip()
    if not text:
        logger.warning("Empty text provided for embedding, returning empty vector")
        return []

    try:
        logger.debug(f"Generating embedding for text of length {len(text)}, type={input_type}")

        response = bedrock_runtime.invoke_model(
            modelId=COHERE_EMBED_MODEL_ID,
            body=json.dumps({
                "texts": [text],
                "input_type": input_type,
                "embedding_types": ["float"],
                "output_dimension": EMBED_OUTPUT_DIMENSION,
                "truncate": "RIGHT",  # Truncate from end if text exceeds limit
            })
        )
        result = json.loads(response["body"].read())

        # Cohere returns embeddings as nested structure when embedding_types specified
        embeddings = result.get("embeddings", {})
        if isinstance(embeddings, dict):
            # Format: {"float": [[...]]}
            embedding = embeddings.get("float", [[]])[0]
        else:
            # Format: [[...]] (legacy)
            embedding = embeddings[0] if embeddings else []

        logger.debug(f"Generated embedding with {len(embedding)} dimensions")
        return embedding

    except ClientError as e:
        error_code = e.response.get("Error", {}).get("Code", "Unknown")
        error_message = e.response.get("Error", {}).get("Message", str(e))
        logger.error(f"Embedding API error: {error_code} - {error_message}")
        raise EmbeddingError(f"Failed to generate embedding: {error_code}") from e
    except Exception as e:
        logger.error(f"Unexpected error generating embedding: {e}")
        raise EmbeddingError(f"Failed to generate embedding: {e}") from e
