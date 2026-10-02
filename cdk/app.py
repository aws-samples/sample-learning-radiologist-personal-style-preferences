#!/usr/bin/env python3
import os

import aws_cdk as cdk

from cdk.auth_stack import AuthStack
from cdk.data_stack import DataStack
from cdk.agent_stack import AgentStack
from cdk.api_stack import ApiStack
from cdk.web_stack import WebStack


def get_allowed_mimic_bucket_paths() -> list[str]:
    """Return validated S3 bucket roots configured for the API role."""
    raw_paths = os.environ.get("MIMIC_BUCKET_PATHS", "")
    paths = [value.strip().removeprefix("s3://").rstrip("/")
             for value in raw_paths.split(",") if value.strip()]
    forbidden_characters = {"*", "?", "[", "]"}
    for path in paths:
        segments = path.split("/")
        if not segments[0] or ".." in segments or forbidden_characters.intersection(path):
            raise ValueError("MIMIC_BUCKET_PATHS contains an invalid bucket path")
    return paths


app = cdk.App()

# Authentication stack (Cognito User Pool)
auth_stack = AuthStack(app, "AuthStack")

# Data stack (DynamoDB tables)
data_stack = DataStack(app, "DataStack")

# Agent stack (IAM role for CIPHER agent)
agent_stack = AgentStack(app, "AgentStack", data_stack=data_stack)

# API stack (API Gateway + Lambda proxy)
# - Direct DynamoDB access for GET operations (fast path)
# - AgentCore invocation for POST operations requiring LLM
api_stack = ApiStack(
    app,
    "ApiStack",
    auth_stack=auth_stack,
    data_stack=data_stack,
    agent_runtime_arn=os.environ.get("AGENT_RUNTIME_ARN", "arn:aws:bedrock-agentcore:us-east-1:XXXXXXXXXXXX:runtime/cipher_agent-XXXXXXXXXX"),
    allowed_mimic_bucket_paths=get_allowed_mimic_bucket_paths(),
)
api_stack.add_dependency(auth_stack)
api_stack.add_dependency(data_stack)

# Web stack (CloudFront + S3 for Flutter web app)
# Note: Build Flutter web before deploying: flutter build web --release
web_stack = WebStack(app, "WebStack")

app.synth()
