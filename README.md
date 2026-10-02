# Radiology Report Style Preferences

A multi-user system that learns radiologist style preferences from their edits, implementing the CIPHER algorithm (Gao et al., NeurIPS 2024) on AWS.

## Overview

When radiologists review AI-generated impressions, they often make edits to match their personal style—terminology choices, formatting preferences, level of detail. This system **learns those preferences automatically** and applies them to future generations, creating a personalized AI assistant that improves over time.

**Key insight**: Preferences are stored as natural language descriptions (not model weights), making them interpretable, editable, and auditable.

## Features

- **Multi-Preference Extraction**: Single edit can yield multiple atomic preferences (stylistic saved, clinical rejected)
- **k-NN Retrieval**: Similar past contexts retrieve relevant preferences (user-configurable k=1-20)
- **Six-Layer Safety Defense**: Prevents learning dangerous content-adding preferences
- **Full Traceability**: Every preference links back to the edit that created it
- **Per-User Model Selection**: Choose Claude Opus/Sonnet/Haiku for each of 5 agents
- **Two Generation Modes**: Clinical interpretation (default) or strict grounding

## Architecture

```
Flutter Web App (CloudFront + S3)
    ↓ HTTPS + JWT
API Gateway (HTTP API)
    ↓ Lambda proxy
Lambda Function
    ├─→ DynamoDB (GET - fast path)
    └─→ AgentCore Runtime (POST - LLM path)
            ├─→ Bedrock Claude (generation)
            ├─→ Bedrock Cohere (embeddings)
            └─→ DynamoDB (storage)
```

**Five-Agent Pipeline**:
1. **Base Impression Agent** - Generates grounded content from findings
2. **Style Refinement Agent** - Applies preferences (cannot add content)
3. **Preference Inference Agent** - Extracts preferences from edits
4. **Preference Validator** - Safety gate for inferred preferences
5. **Preference Edit Validator** - Strict validation for direct edits

## Tech Stack

| Component | Technology |
|-----------|------------|
| Frontend | Flutter/Dart web app (CloudFront + S3) |
| API | API Gateway + Lambda (Python) |
| Agent | Strands on Bedrock AgentCore Runtime |
| LLM | Claude Opus 4.8 / Sonnet 4.6 / Haiku 4.5 via Bedrock |
| Embeddings | Cohere Embed v4 (1024 dims) |
| Auth | Cognito User Pool (JWT) |
| Database | DynamoDB (6 tables) |
| Infrastructure | CDK (Python) |

## Project Structure

```
├── frontend-web/       # Flutter web app
├── backend/
│   ├── agent/          # Strands agent (CIPHER implementation)
│   └── lambda/         # API proxy function
├── cdk/                # Infrastructure as code
├── data/               # Data loading scripts
├── scripts/            # API testing scripts
└── docs/               # Documentation
```

## Quick Start

### Prerequisites

- Python 3.12+ with `uv` (Lambda runtime is 3.12, AgentCore is 3.13; the CDK app targets 3.14)
- Node.js (for CDK and the AgentCore CLI)
- Flutter SDK 3.8+ (for the web app)
- AWS account with Bedrock access (Claude Opus 4.8, Sonnet 4.6, Haiku 4.5, Cohere Embed v4)

### Deployment

See **[docs/deployment-guide.md](docs/deployment-guide.md)** for complete step-by-step instructions.

Quick commands:
```bash
# 1. Deploy infrastructure
cd cdk && uv run cdk deploy --all

# 2. Deploy agent
cd backend/agent && uv run agentcore deploy

# 3. Load test data
cd data && uv run python load_data.py --clear

# 4. Run tests (enter the password without storing it in shell history)
export TEST_USER_EMAIL=user@example.com
read -s TEST_USER_PASSWORD
export TEST_USER_PASSWORD
cd scripts && uv run python test_api.py

# 5. Build web app
cd frontend-web && flutter build web
```

### Creating Users

Create a new Cognito user without embedding passwords in commands or files:
```bash
read -s TEMP_USER_PASSWORD
read -s PERMANENT_USER_PASSWORD

# Create user
aws cognito-idp admin-create-user \
    --user-pool-id <UserPoolId> \
    --username user@example.com \
    --user-attributes Name=email,Value=user@example.com Name=email_verified,Value=true \
    --temporary-password "$TEMP_USER_PASSWORD" \
    --message-action SUPPRESS

# Set permanent password
aws cognito-idp admin-set-user-password \
    --user-pool-id <UserPoolId> \
    --username user@example.com \
    --password "$PERMANENT_USER_PASSWORD" \
    --permanent

# Load test data for the user
cd data && uv run python load_data.py --user-id user@example.com --clear
```

**Note**: Use `@` as the special character in passwords. Characters like `#` and `!` can cause issues with web-based authentication (SRP auth flow).

## Safety Architecture

The system implements six layers of defense to ensure only stylistic preferences are learned:

1. **Prompt Injection Detection** - Pattern matching at API boundary
2. **Multi-Change Extraction** - Classify each atomic change independently
3. **Category Enforcement** - Pydantic Literal types restrict categories
4. **Confidence Threshold** - Low-confidence preferences rejected
5. **Keyword Filtering** - Blocklist for content-adding terms
6. **Validator Agent** - Dedicated LLM safety check

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| Atomic single-item preferences | Each preference captures ONE change for clarity |
| k=10 default (configurable 1-20) | Granular preferences need retrieval coverage |
| Two-agent generation | Structural hallucination prevention |
| DynamoDB for embeddings | Cost-effective for <500 prefs/user |
| Stateless sessions | Simpler debugging, reproducible requests |

## References

- **CIPHER Paper**: Gao et al., "Aligning LLM Agents by Learning Latent Preference from User Edits", NeurIPS 2024 ([arXiv:2404.15269](https://arxiv.org/abs/2404.15269))
- **AWS Bedrock**: [Documentation](https://docs.aws.amazon.com/bedrock/)
- **Strands Framework**: [GitHub](https://github.com/strands-agents/strands-agents)

## License

This project is for demonstration purposes. See individual dependencies for their licenses.
