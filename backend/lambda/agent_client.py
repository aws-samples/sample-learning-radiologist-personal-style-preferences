"""
AgentCore Runtime client.

Invokes the Strands agent on Bedrock AgentCore Runtime for LLM operations
(generate impression, save edit, validate preference).
"""

import json
import logging
import os
import uuid

import boto3


logger = logging.getLogger(__name__)

AGENT_RUNTIME_ARN = os.environ.get("AGENT_RUNTIME_ARN")


def invoke_agent(operation: str, user_id: str, **kwargs) -> dict:
    """Invoke the AgentCore Runtime agent.

    Args:
        operation: The agent operation (generate_impression, save_edit, validate_preference).
        user_id: The authenticated user's email.
        **kwargs: Additional payload fields for the agent.

    Returns:
        Parsed JSON response from the agent.
    """
    client = boto3.client("bedrock-agentcore")

    payload = {"operation": operation, "user_id": user_id, **kwargs}

    # Generate fresh session ID per request (stateless)
    session_id = str(uuid.uuid4())

    logger.info(f"Invoking agent: operation={operation}, user={user_id}, session={session_id}")

    response = client.invoke_agent_runtime(
        agentRuntimeArn=AGENT_RUNTIME_ARN,
        runtimeSessionId=session_id,
        payload=json.dumps(payload).encode(),
    )

    # Process response - handle both streaming and JSON responses
    content_type = response.get("contentType", "")

    if "text/event-stream" in content_type:
        chunks = []
        for line in response["response"].iter_lines(chunk_size=1024):
            if line:
                line_str = line.decode("utf-8")
                if line_str.startswith("data: "):
                    chunks.append(line_str[6:])
        return json.loads("".join(chunks))

    else:
        chunks = []
        for chunk in response.get("response", []):
            chunks.append(chunk.decode("utf-8"))
        return json.loads("".join(chunks))
