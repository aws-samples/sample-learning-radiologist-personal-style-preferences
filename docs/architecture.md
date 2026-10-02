# Architecture: Radiology Report Preference Learning System

> **Related Documentation:**
> - [Agent Architecture](agent-architecture.md) - Five-agent pipeline details, safety guardrails
> - [Data Architecture](data-architecture.md) - DynamoDB schema and data flows
> - [State Management](state-management.md) - Frontend Riverpod provider graph
> - [Security Requirements](security-requirements.md) - 20 security requirements in 3 tiers
> - [Deployment Guide](deployment-guide.md) - Step-by-step deployment instructions
> - [Model Upgrade Guide](model-upgrade-guide.md) - Changing Claude/embedding models
> - [Roadmap](roadmap.md) & [Changelog](CHANGELOG.md) - Open items / completed work

## Overview
  
A multi-user system that learns radiologist style preferences from their edits, using the CIPHER algorithm (Gao et al., NeurIPS 2024). Built on AWS Bedrock AgentCore Runtime with Strands framework for serverless agent deployment.

## High-Level Architecture

```
┌─────────────────────────────────┐
│  Flutter Web App                │
│  (CloudFront + S3)              │
│  - Login with Cognito           │
│  - Display cases & findings     │
│  - Generate impressions         │
│  - Edit impressions             │
│  - View learned preferences     │
└────────────┬────────────────────┘
             │
             │ 1. Auth ──────────────────┐
             │                           ▼
             │              ┌────────────────────────┐
             │              │  Cognito User Pool     │
             │              │  - User authentication │
             │              │  - JWT token issuance  │
             │              │  - Password policies   │
             │              └────────────────────────┘
             │
             │ 2. HTTPS + JWT Token
             │
┌────────────▼────────────────────┐
│  API Gateway (HTTP API)         │
│  - Cognito JWT Authorizer       │
│  - Lambda proxy integration     │
└────────────┬────────────────────┘
             │
             │ Lambda invocation
             │
┌────────────▼────────────────────┐
│  Lambda Function (Python)       │
│  - Validate request             │
│  - GET ops: Direct DynamoDB     │◄── Fast path (<500ms)
│  - POST ops: AgentCore invoke   │◄── LLM path (3-15s)
└───────┬───────────────┬─────────┘
        │               │
   GET  │          POST │ InvokeAgentRuntime
        │               │
        │     ┌─────────▼─────────────────┐
        │     │  Bedrock AgentCore Runtime│
        │     │  ┌────────────────────┐   │
        │     │  │  Strands Agent     │   │
        │     │  │  - CIPHER algorithm│   │
        │     │  │  - k-NN retrieval  │   │
        │     │  │  - Pref inference  │   │
        │     │  └─┬──────────────┬───┘   │
        │     └───┼──────────────┼───────┘
        │         │              │
        │    ┌────▼────┐   ┌─────▼──────┐
        │    │ Bedrock │   │  Bedrock   │
        │    │ Claude  │   │ Embeddings │
        │    │ Sonnet  │   │ (Cohere)   │
        │    └─────────┘   └────────────┘
        │
┌───────▼────────────────────────────────┐
│              DynamoDB                   │
│  - Cases (user findings)               │
│  - EditHistory (user edits)            │
│  - Preferences (learned prefs)         │
│  - UserSettings (per-user config)      │
│  - RejectedPreferences (audit trail)   │
│  - Idempotency (request dedup)         │
└─────────────────────────────────────────┘
```

**Why API Gateway + Lambda?**
API Gateway with a Lambda proxy provides standard HTTP endpoints with JWT authentication, decoupling the frontend from AWS-specific APIs and avoiding manual SigV4 signing.

**Fast Path Optimization:**
GET operations (`/cases`, `/cases/{id}`, `/preferences`) access DynamoDB directly from Lambda, bypassing AgentCore Runtime cold starts. This reduces latency from 5-15 seconds to <500ms for data retrieval. Only POST operations (`/generate`, `/edit`) that require LLM inference go through AgentCore.

**Async Pattern for Preference Learning:**
POST /edit uses an async polling pattern to avoid API Gateway's 30-second timeout. Preference extraction with multi-change analysis can take 30-90 seconds for complex edits:

```
┌─────────────────────────────────────────────────────────────────┐
│  Client                          Lambda              Step Fn    │
├─────────────────────────────────────────────────────────────────┤
│  POST /edit ──────────────────► Save job, start ──► State      │
│       ◄───────────────────────  { edit_id,          Machine    │
│                                   status: processing }  │      │
│                                                         │      │
│                                                         ▼      │
│                                              Background Lambda  │
│                                              (pref extraction)  │
│                                                         │      │
│  GET /edit/{id}/status ─────► Check job status          │      │
│       ◄───────────────────────  { status: processing }  │      │
│                                                         │      │
│  (poll every 2 seconds)                                 ▼      │
│                                                                 │
│  GET /edit/{id}/status ─────► Check job status                 │
│       ◄───────────────────────  { status: completed, ... }     │
└─────────────────────────────────────────────────────────────────┘
```

The async flow uses a Step Functions state machine to invoke the Lambda for background preference extraction. The edit job status is stored in DynamoDB (EditHistory table) and includes all results when complete. An idempotency table (`radiologist-idempotency`) prevents duplicate processing of the same edit.

## Interaction Model: Transactional

The system uses a request/response interaction model where each operation is self-contained:

```
1. User views case with findings
2. User clicks "Generate" → receives impression
3. User reviews and manually edits if needed
4. User clicks "Save" → system learns preferences from the diff
```

**Session Strategy: Fresh Session Per Request**

```python
import uuid

# Each request gets a fresh session ID (33+ chars required by AgentCore)
session_id = str(uuid.uuid4()) + "-" + str(uuid.uuid4())[:1]
```

**Why stateless:**
- Each request includes all necessary context (findings, preferences retrieved from DynamoDB)
- Simpler implementation and debugging (fully reproducible requests)
- No session state to manage or expire
- Aligns with CIPHER algorithm's retrieve-aggregate-generate pattern

**Future Enhancement: Conversational Refinement**

User-based sessions could enable multi-turn interactions before saving:
- "Make it more concise" → agent refines the impression
- "Use simpler language" → agent adjusts terminology
- "Why did you phrase it that way?" → agent explains its reasoning

This would require:
- Switching from fresh sessions to user-based session IDs
- Adding a refinement endpoint or modifying the generate flow
- Frontend UI changes to support chat-like refinement
- Consideration of conversation logging for medical auditability

See Future Enhancements section for more details.

## Component Responsibilities

### 1. Flutter Web App (CloudFront + S3)

**Responsibilities:**
- User authentication via Cognito (Amplify Dart SDK)
- Display case list and findings
- Initiate impression generation
- Display generated impressions
- Capture user edits
- Display learned preferences
- User settings (clinical interpretation mode, model selection, k_preferences)

**Authentication Flow:**
1. User logs in with Cognito User Pool (via Amplify Dart SDK)
2. App obtains JWT tokens (ID token, access token)
3. Include JWT token in Authorization header for API Gateway requests
4. No manual SigV4 signing required - API Gateway handles auth via JWT authorizer

**API Communication:**
- Uses Dio HTTP client to call API Gateway
- Send JWT token in Authorization header
- Non-streaming (full response)

### 2. API Gateway + Lambda Proxy

**API Gateway (HTTP API):**
- Exposes REST endpoints for the Flutter web app
- Uses Cognito JWT authorizer for authentication
- Routes: GET /cases, GET /cases/{caseId}, PUT /cases/{caseId}, GET /preferences, GET /preferences/rejected, PUT /preferences/{preferenceId}, DELETE /preferences/{preferenceId}, GET /settings, PUT /settings, POST /settings/validate-bucket, POST /settings/reset, POST /generate, POST /edit, GET /edit/{editId}/status

**Lambda Function (Python):**
- Receives validated requests from API Gateway
- Extracts user_id from JWT claims (sub or email)
- GET operations: Direct DynamoDB access (fast path)
- POST operations: Calls InvokeAgentRuntime with user request
- Returns agent response to client

**Lambda Code Structure:**
```
backend/lambda/
├── handler.py          # Thin router — maps routes to handler functions
├── safety.py           # Prompt injection detection, input sanitization
├── agent_client.py     # AgentCore Runtime invocation helper
├── utils.py            # Response helpers, validation
├── db/                 # DynamoDB operations package (modular)
│   ├── common.py       # Shared table references, helpers
│   ├── cases.py        # Cases table operations
│   ├── edit_history.py # EditHistory table operations
│   ├── preferences.py  # Preferences table operations
│   ├── settings.py     # UserSettings table operations
│   ├── rejected.py     # RejectedPreferences table operations
│   ├── data_ops.py     # Bulk data operations (reset)
│   └── idempotency.py  # Idempotency table operations
└── routes/             # Route handler modules
    ├── cases.py        # GET/PUT /cases routes
    ├── preferences.py  # GET/PUT/DELETE /preferences routes
    ├── generation.py   # POST /generate route
    ├── edit.py         # POST /edit, GET /edit/{id}/status routes
    └── settings.py     # GET/PUT /settings, POST /settings/reset routes
```

**Handler overview:**
```python
ROUTE_TABLE = {
    "GET /cases": handle_get_cases,
    "GET /cases/{caseId}": handle_get_case_detail,
    "PUT /cases/{caseId}": handle_update_case,
    "POST /generate": handle_generate,
    "POST /edit": handle_post_edit,
    # ... all routes mapped to handler functions
}

def handler(event, context):
    # 1. Check async_edit_processing / mark_edit_failed flags
    # 2. Extract user_email from JWT claims
    # 3. Dispatch via ROUTE_TABLE[route_key](user_email, path_params, event)
```

### 3. Strands Agent (Python Container on AgentCore Runtime)

**Responsibilities:**
- Implement CIPHER algorithm
- Handle streaming responses
- Manage preference lifecycle

**Core Operations:**

#### a. Generate Impression
```
Input: { user_id, case_id, findings, clinical_interpretation? }

1. Generate base impression from findings using Agent 1
   - If clinical_interpretation=true (user-setting default): Allow standard radiological interpretations
   - If clinical_interpretation=false: Strict grounding, no inferences
   - (The agent's own parameter fallback is false/strict if the flag is omitted entirely — a conservative safety floor.)
2. Embed findings using Bedrock Embeddings
3. Query DynamoDB for user's preference history
4. Calculate k-NN similar contexts (k=user's k_preferences setting, default 10, range 1-20)
5. Apply style refinement with Agent 2 (if preferences exist)
6. Store generated impression in DynamoDB

Output: { impression, base_impression, preferences_used, preferences_applied, case_id }
```

#### b. Save Edit and Infer Preference (Multi-Preference Extraction)

**Async Pattern:** Preference extraction can take 30-90 seconds for complex edits. To avoid API Gateway's 30-second timeout, this operation uses an async polling pattern:

1. **POST /edit** → Returns immediately with `edit_id` and `status: "processing"`
2. **GET /edit/{editId}/status** → Poll for completion (every 2 seconds)
3. When `status: "completed"`, results are available

```
Input: { user_id, case_id, original_impression, edited_impression }

Async Flow:
1. Save job to EditHistory with status="processing"
2. Start Step Functions state machine execution (async background processing)
3. Return immediately: { edit_id, status: "processing", poll_url }

Background Processing:
1. Calculate edit distance
2. If distance > threshold:
   a. Call Claude Opus 4.8 to extract ALL atomic changes in the edit
   b. Classify each change as STYLISTIC or CONTENT-ADDING
   c. For each stylistic change:
      - Run through safety validation (keyword filter, validator agent)
      - If passes: embed context, store preference in DynamoDB
   d. For each content-adding change:
      - Record rejection reason
3. Update job status to "completed" with results

Poll Response (when completed): {
  edit_id: string,
  status: "completed",
  edit_distance: number,
  preferences_saved: [{ preference_id, preference_text, category, confidence }],
  changes_rejected: [{ change_description, rejection_reason }],
  summary: string,
  preference_inferred: bool
}
```

**Why Multi-Preference Extraction?**
A single edit often contains multiple changes—some stylistic (safe to learn) and some clinical (must reject). For example:
- "Use bullet points" → STYLISTIC (save)
- "No acute pulmonary disease" → CONTENT-ADDING (reject)

The system decomposes edits into atomic changes and classifies each independently, ensuring stylistic preferences are captured even when mixed with clinical changes.

#### c. Retrieve Preferences
```
Input: { user_id }

Output: List of learned preferences with timestamps
```

**Tools/Actions:**
- DynamoDB operations (query, put, scan) via boto3
- Bedrock model invocation (Claude Opus 4.8 / Sonnet 4.6 / Haiku 4.5, configurable per-agent)
- Bedrock embeddings (Cohere v4)

**Deployment:**
- Strands framework on Bedrock AgentCore Runtime
- Direct code deploy (CodeZip), Python 3.13 runtime — see [Deployment Guide](deployment-guide.md)
- Packaged with dependencies (boto3, numpy for similarity)

### 4. Amazon Bedrock

**Models Used:**

The system supports per-user, per-agent model selection with three tiers:

| Model | Tier | Default Use |
|-------|------|-------------|
| Claude Opus 4.8 | Premium | Preference inference (default for best extraction quality) |
| Claude Sonnet 4.6 | Standard | Base impression, style refinement, preference validator (default) |
| Claude Haiku 4.5 | Fast | Preference edit validator |

**Model Configuration** (source of truth: `backend/agent/config.py`; to change models
see the [Model Upgrade Guide](model-upgrade-guide.md)):
```python
AVAILABLE_MODELS = {
    "claude-opus-4.8": "global.anthropic.claude-opus-4-8",
    "claude-sonnet-4.6": "global.anthropic.claude-sonnet-4-6",
    "claude-haiku-4.5": "global.anthropic.claude-haiku-4-5-20251001-v1:0",
}

# Per-agent defaults
DEFAULT_MODELS = {
    "base_impression": "claude-sonnet-4.6",
    "style_refinement": "claude-sonnet-4.6",
    "preference_inference": "claude-opus-4.8",
    "preference_validator": "claude-sonnet-4.6",
    "preference_edit_validator": "claude-haiku-4.5",
}
```

Users can customize model selection in Settings. Model choices are stored in user settings and applied per-request.

**k-NN Preference Retrieval:**
- `k_preferences`: User-configurable number of similar preferences to retrieve (default: 10, range: 1-20)
- Higher k values retrieve more preferences but may include less relevant ones
- Lower k values are more focused but may miss applicable preferences
- Users can adjust via Settings to tune personalization level

**Cohere Embed v4:**
- Embed findings (context) for similarity search
- 1024-dimensional vectors (configurable: 256, 512, 1024, 1536)
- Uses `search_document` for storing, `search_query` for retrieval
- Better trained on diverse domains including medical text
- Cosine similarity for k-NN retrieval

### Design Decision: DynamoDB vs Bedrock Knowledge Base for Embeddings

**Decision:** Store embeddings directly in DynamoDB, perform k-NN in application code.

**Why not Bedrock Knowledge Base?**

Bedrock Knowledge Bases are designed for RAG (Retrieval-Augmented Generation) over large document corpora—think thousands of PDFs, web pages, or knowledge articles that are shared across users. CIPHER has fundamentally different requirements:

| Requirement | Bedrock Knowledge Base | DynamoDB + App-Level k-NN |
|-------------|------------------------|---------------------------|
| **Per-user isolation** | Requires filters or separate KBs per user | Natural with user_id partition key |
| **Data volume** | Designed for 10K-1M+ documents | 50-500 preferences per user |
| **Write pattern** | Batch ingestion, sync delays | Real-time writes, immediate reads |
| **Query pattern** | Semantic search over corpus | k-NN over small user-specific set |
| **Cost** | KB + OpenSearch Serverless (~$170/mo min) | DynamoDB on-demand (~$0.01/mo) |

**How k-NN works in our architecture:**

```python
# 1. Query all preferences for this user (typically 50-200 items)
preferences = dynamodb.query(user_id=user_id)  # ~50ms

# 2. Calculate cosine similarity in memory (trivial for small N)
similarities = [(pref, cosine_sim(query_emb, pref.embedding))
                for pref in preferences]  # ~1ms for 200 items

# 3. Return top k
return sorted(similarities, key=lambda x: x[1], reverse=True)[:k]
```

**Performance characteristics:**
- 200 preferences × 1024 dimensions = 800KB data
- Cosine similarity: O(n × d) = 200 × 1024 = 204,800 operations (~1ms)
- Total retrieval latency: ~50-100ms (dominated by DynamoDB query)

**When to consider alternatives:**

| Scale | Recommendation |
|-------|----------------|
| < 500 prefs/user | DynamoDB (current) ✓ |
| 500-5000 prefs/user | DynamoDB with GSI on embedding hash, or OpenSearch |
| > 5000 prefs/user | OpenSearch Serverless or dedicated vector DB |
| Cross-user search | Bedrock Knowledge Base |

**Migration path to OpenSearch (if needed):**

1. Create OpenSearch Serverless collection with vector search
2. Add OpenSearch writes alongside DynamoDB in `store_preference()`
3. Replace `retrieve_similar_preferences()` with OpenSearch k-NN query
4. Keep DynamoDB as source of truth for preference metadata

For this demo and expected production radiologist workloads (50-200 preferences accumulated over months), DynamoDB provides the simplest, most cost-effective solution.

### 5. DynamoDB Tables

#### Cases Table
```
PK: user_id
SK: case_id

Attributes:
- findings: string
- reference_impression: string (ground truth, if available)
- generated_impression: string
- edited_impression?: string
- timestamp: number

Audit trail fields (added during generation/editing):
- generated_at: number (Unix timestamp of generation)
- edited_at: number (Unix timestamp of last edit)
- base_impression: string (impression before preferences applied)
- base_impression_model: string (model used for base generation)
- refinement_model: string (model used for style refinement, if applied)
- preferences_applied: string (JSON array of {preference_id, preference_text})
```

#### EditHistory Table
```
PK: user_id
SK: edit_id

Attributes:
- case_id: string
- original_impression: string
- edited_impression: string
- edit_distance: number
- timestamp: number

Used for:
- Complete audit trail of all user edits on a case
- Returned in GET /cases/{caseId} as edit_history array
- Timeline display showing each edit with timestamp and change percentage
```

#### Preferences Table
```
PK: user_id
SK: preference_id

Attributes:
- preference_text: string (natural language)
- context_embedding: list (1024 floats)
- source_case_id: string
- timestamp: number
- category: string (terminology|formatting|detail_level|phrasing|priority)
- confidence: number (0.0-1.0)
- inference_explanation: string (LLM explanation of HOW preference was derived)

Traceability fields (for understanding how preference was learned):
- source_edit_id: string (link to EditHistory)
- original_impression: string (AI-generated text before edit)
- edited_impression: string (user's edited text)
- context_findings: string (readable findings text)
- edit_distance: number (0.0-1.0 significance of edit)

User edit tracking fields (when user manually edits preference text):
- original_inferred_text: string (original LLM-inferred text, preserved on first edit)
- last_edited_at: number (timestamp of last user edit)
- user_edit_count: number (how many times user edited this preference)

Model attribution:
- inference_model: string (model used to extract this preference)

GSI: preference_id-index (for quick lookup)
```

#### RejectedPreferences Table
```
PK: rejection_id (UUID)

Attributes:
- user_id: string
- change_description: string (what the user tried to change)
- rejection_reason: string (why it was rejected)
- rejection_layer: string (which safety layer rejected it)
- source_case_id: string
- source_edit_id: string (link to EditHistory)
- timestamp: number

Traceability fields:
- original_impression: string (AI-generated text before edit)
- edited_impression: string (user's edited text)
- context_findings: string (findings that were being reported on)
- risk_level: string (none|low|medium|high)
- inference_model: string (model that extracted the change)

GSI: user_id-timestamp-index (for querying user's rejected changes)
```

#### UserSettings Table
```
PK: user_id

Attributes:
- clinical_interpretation: boolean (default: true)
- model_settings: map {agent_name: model_key} (per-agent model selection)
- k_preferences: number (1-20, default: 10, how many preferences to retrieve for k-NN)
- updated_at: number (Unix timestamp of last update)
```

#### Idempotency Table
```
PK: idempotency_key (format: "{user_id}#{client_key}")

Attributes:
- response: map (cached response body)
- created_at: string (ISO 8601 timestamp)
- expires_at: number (Unix TTL, 24 hours)
- _idempotency_status: string ("processing" | "completed")
```

### 6. Amazon Cognito

**User Pool:**
- Email + password authentication
- Strong password policy (12 chars, symbols required)
- User attributes: email, name
- Issues JWT tokens for API Gateway authorization

**Note:** No Identity Pool needed - API Gateway uses JWT authorizer directly with Cognito User Pool tokens.

## Preference Management

### Preference Traceability

Every learned preference stores complete traceability data, allowing users to understand HOW and WHY it was inferred:

```
┌─────────────────────────────────────────────────────────────────┐
│  Preference: "Use 'consolidation' instead of 'opacity'"         │
│  Category: terminology | Confidence: 95%                        │
│  From: Case_011 | Jan 30, 2026                                  │
│                                                                 │
│  ▼ Show how this was learned                                    │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │ ┌─ User Edit (if preference was manually modified) ────────┐││
│  │ │ You edited this preference (2 times)                     │││
│  │ │ Originally inferred: "Prefer consolidation terminology"  │││
│  │ │ Last edited: Jan 30, 2026 at 22:45                       │││
│  │ └──────────────────────────────────────────────────────────┘││
│  │                                                              ││
│  │ Original: "Opacity in the right lower lobe..."              ││
│  │ Your edit: "Consolidation in the right lower lobe..."       ││
│  │                                                              ││
│  │ How this was inferred:                                       ││
│  │ "The user changed 'opacity' to 'consolidation', indicating  ││
│  │  a preference for the more specific medical terminology."   ││
│  │                                                              ││
│  │ Findings: "PA and lateral views... increased density..."    ││
│  │ Edit distance: 19%                                          ││
│  └─────────────────────────────────────────────────────────────┘│
│                                           [✏️ Edit] [🗑️ Delete]  │
└─────────────────────────────────────────────────────────────────┘
```

**Stored fields for traceability:**
- `source_edit_id` - Links to specific entry in EditHistory table
- `original_impression` - The AI-generated text before user edited
- `edited_impression` - The user's edited version
- `inference_explanation` - LLM explanation of HOW the preference was derived
- `context_findings` - The original findings (readable, unlike embedding)
- `edit_distance` - How significant the edit was (0.0-1.0)

**User edit tracking fields (when user modifies preference text):**
- `original_inferred_text` - The original LLM-inferred preference text (preserved)
- `last_edited_at` - Timestamp of last user modification
- `user_edit_count` - Number of times user has edited this preference

### Preference Editing

Users can edit preference text to refine what the system learned. Edits go through **super strict safety validation** (stricter than inference validation because direct edits are a higher-risk attack vector):

```
PUT /preferences/{preferenceId}
Authorization: Bearer <JWT>
Content-Type: application/json

{"preference_text": "Use bullet points for formatting"}

Response: {"preference_id": "pref_xxx", "preference_text": "...", "message": "Preference updated successfully"}
```

**Multi-layer safety validation for edits:**
1. **Prompt injection detection** - Pattern matching for injection attempts
2. **Strict keyword blocklist** - Whole-word matching for dangerous keywords (recommend, treatment, differential, etc.)
3. **Pattern matching** - Regex for content-adding phrases
4. **Super strict LLM validator** - Paranoid validation agent (separate from inference validator)

**Edit tracking for audit trail:**
When a preference is edited, the system preserves:
- `original_inferred_text` - What the LLM originally inferred (never changes)
- `last_edited_at` - Timestamp of the most recent edit
- `user_edit_count` - How many times the user has edited this preference

This enables a complete audit trail showing both LLM reasoning and user modifications.

### Case Edit History

The system tracks the complete edit history for each case, enabling a full audit trail of all changes:

```
GET /cases/{caseId}

Response includes:
{
  "case_id": "Case_001",
  "findings": "...",
  "generated_impression": "...",
  "edited_impression": "...",
  "generated_at": 1738339200,
  "edited_at": 1738339500,
  "base_impression": "...",
  "preferences_applied": [
    {"preference_id": "pref_xxx", "preference_text": "..."}
  ],
  "edit_history": [
    {
      "edit_id": "edit_xxx",
      "original_impression": "...",
      "edited_impression": "...",
      "edit_distance": 0.15,
      "timestamp": 1738339500
    }
  ]
}
```

**Timeline display:**
The edit history enables a complete timeline view in the UI:
1. **Base Generated** - Initial AI-generated impression (if preferences were applied)
2. **Preferences Applied** - After style refinement with user preferences
3. **Edit 1, Edit 2, ...** - Each subsequent user edit with timestamp and change percentage

**Significant edits:**
Edits with >5% change are highlighted as "significant" in the UI with a ⚡ indicator.

### Rejected Changes Audit Trail

The system stores all rejected changes for transparency, allowing users to understand why certain edits weren't learned as preferences:

```
GET /preferences/rejected
Authorization: Bearer <JWT>

Response: [
  {
    "rejection_id": "rej_123",
    "change_description": "Summarize specific negatives as 'no acute pulmonary disease'",
    "rejection_reason": "Abstracts clinical content - replaces specific findings with general statement",
    "rejection_layer": "validator_agent",
    "risk_level": "high",
    "source_case_id": "Case_011",
    "timestamp": 1738339500,
    "original_impression": "No focal consolidation, pleural effusion or pneumothorax.",
    "edited_impression": "No acute pulmonary disease.",
    "inference_model": "claude-sonnet-4.6"
  }
]
```

**Rejection Layers:**
| Layer | Description |
|-------|-------------|
| `confidence_threshold` | Preference confidence below 0.3 |
| `keyword_filter` | Contains content-adding keywords |
| `validator_agent` | Agent 4 classified as content-adding |
| `llm_classification` | Agent 3 classified as non-stylistic |

**Why store rejected changes?**
- **Transparency**: Users understand what the system won't learn
- **Trust**: Users see the safety guardrails working
- **Debugging**: Developers can analyze rejection patterns
- **Compliance**: Audit trail for healthcare applications

### Preference Deletion

Users can delete preferences they no longer want the system to use:

```
DELETE /preferences/{preferenceId}
Authorization: Bearer <JWT>

Response: {"preference_id": "pref_xxx", "message": "Preference deleted successfully"}
```

**Why deletion matters:**
- **User control**: Users should be able to remove preferences they disagree with
- **Error correction**: If a preference was incorrectly inferred, user can remove it
- **Privacy**: Users may want to remove preferences before sharing their account
- **Evolution**: User preferences change over time; old ones may no longer apply

## User Interface Design

The web app follows a modern, polished design with focus on traceability and audit trails.

### Case List View
- **Card-style rows** with status color bar (green = done, gray = new)
- **Filter chips** with SF Symbol icons for quick filtering
- **Search** with live filtering
- **NotificationCenter** integration refreshes list when cases are updated

### Case Detail View
- **Section cards** with icon headers (Findings, Generated Impression)
- **AI gradient header** for generated impression section
- **Impression History** expandable timeline showing:
  - Base generation timestamp
  - Preferences applied (if any)
  - Each edit with timestamp and change percentage
  - Significant edits (>5%) highlighted with ⚡

### Preferences View
- **Sort chips** (Recent, Category, Confidence) for organizing preferences
- **Card rows** with category color bar
- **Expandable traceability** showing:
  - Original AI-generated impression
  - User's edit that triggered learning
  - System's inference explanation (HOW it derived the preference)
  - User edits to the preference (if any)

### Profile Area
- **Compact initials circle** in toolbar (derived from email)
- Full email shown in dropdown menu

### Keyboard Shortcuts

**Available shortcuts:**
| Shortcut | Action |
|----------|--------|
| Ctrl+1 | Go to Cases |
| Ctrl+2 | Go to Preferences |
| Ctrl+3 | Go to Settings |
| Ctrl+G | Generate Impression |
| Ctrl+S | Save Edit |

### Onboarding Walkthrough
First-time users see a 5-page onboarding walkthrough explaining:
1. **Review Radiology Findings** - Browse cases and view findings
2. **AI-Generated Impressions** - Click Generate to create impressions
3. **Edit and Teach** - Edit impressions to teach your preferences
4. **Personalized Over Time** - System learns from your edits
5. **Safe Style Learning** - System only learns style, not clinical content

**Triggers:**
- Automatically shown for new users (no preferences yet)
- Can be re-shown via Help > Show Introduction or Settings > "Show Introduction" button

## Data Flow Examples

### Scenario 1: First Impression Generation (No Preferences Yet)

```
1. User selects case in app
2. App sends POST /generate to API Gateway with:
   - Authorization: Bearer <JWT token>
   - Body: { "case_id": "case_001", "findings": "Mild cardiomegaly. Clear lungs." }

3. API Gateway validates JWT, extracts user_id from claims

4. Lambda proxy:
   a. Receives validated request
   b. Calls InvokeAgentRuntime with user_id + request body

5. Strands agent:
   a. Embeds findings → [0.12, 0.45, ...]
   b. Queries Preferences table (finds 0 matches)
   c. Calls Claude Sonnet 4.6 with base prompt:
      "Generate a radiology impression from these findings..."
   d. Returns response

6. Lambda returns response to app

7. App displays: "Mild cardiomegaly is present..."

8. Agent stores in Cases table:
   - PK: "radiologist@hospital.com"
   - SK: "case_001"
   - generated_impression: "Mild cardiomegaly is present..."
```

### Scenario 2: User Edits Impression (Multi-Preference Extraction, Async)

```
1. User edits impression:
   Original: "Mild cardiomegaly. No focal consolidation, pleural effusion or pneumothorax."
   Edited:   "* Heart size mildly enlarged.\n* No acute pulmonary disease."

2. App sends POST /edit to API Gateway with:
   - Authorization: Bearer <JWT token>
   - Body: { "case_id": "case_001", "original": "...", "edited": "..." }

3. API Gateway validates JWT → Lambda
   a. Lambda saves edit job to EditHistory with status="processing"
   b. Lambda starts Step Functions state machine execution (async)
   c. Returns immediately: { edit_id: "edit_xxx", status: "processing" }

4. Step Functions invokes Lambda → AgentCore Runtime:
   a. Calculates edit distance: 62% changed (above threshold)

   b. Agent 3 (Multi-Change Extraction) decomposes the edit into atomic changes:
      Change 1: Prose → bullet points [STYLISTIC - formatting]
      Change 2: "cardiomegaly" → "heart size enlarged" [STYLISTIC - terminology]
      Change 3: Specific negatives → "No acute pulmonary disease" [CONTENT-ADDING]

   c. Each stylistic change goes through per-change validation pipeline:
      - Confidence threshold check (>0.3)
      - Keyword heuristic filter (with formatting exemptions)
      - Agent 4 (Validator) final safety check

   d. Results:
      - Change 1: SAVED as preference ("Use bullet point formatting")
      - Change 2: SAVED as preference ("Use plain English, e.g. 'heart size enlarged' over 'cardiomegaly'")
      - Change 3: REJECTED ("Abstracts clinical content — replaces specific findings with general statement")
        → Stored in RejectedPreferences table with risk_level, rejection_layer

   e. Embeds the findings context for each saved preference → [0.12, 0.45, ...]
   f. Updates edit job status to "completed"

5. App polls GET /edit/{editId}/status until complete:
   Response: {
     status: "completed",
     preferences_saved: [{ preference_text: "Use bullet point formatting", category: "formatting" }, ...],
     changes_rejected: [{ change_description: "...", rejection_reason: "..." }],
     summary: "Learned 2 preferences. Rejected 1 content-adding change."
   }
```

### Scenario 3: Generation with Learned Preferences (Two-Agent Pipeline)

```
1. User selects new case: "Moderate pleural effusion on right. Heart size normal."

2. App sends POST /generate to API Gateway
   → Lambda → AgentCore Runtime

3. Stage 1 — Agent 1 (Base Impression Generator):
   a. Receives ONLY the findings (no preferences)
   b. Generates grounded impression:
      "Moderate right-sided pleural effusion. Normal heart size."
   c. Output is purely clinical, based solely on findings

4. Stage 2 — Preference Retrieval:
   a. Embeds findings → [0.18, 0.52, ...]
   b. Queries Preferences table for user_id
   c. Calculates cosine similarity with all user preferences
   d. Retrieves top k similar preferences (k=user's setting, default 10):
      - "Use bullet point formatting" (similarity: 0.85)
      - "Use plain English over medical jargon" (similarity: 0.82)
      - "Keep impressions concise" (similarity: 0.76)

5. Stage 3 — Agent 2 (Style Refinement):
   a. Receives ONLY the base impression (NOT the original findings)
   b. Receives preferences as before/after examples (not abstract rules)
   c. Applies style modifications:
      "* Moderate fluid collection on the right side.\n* Normal heart size."
   d. Safety check: refined length ≤ 1.5× base length → passes (no content added)

6. Returns to app with attribution:
   {
     impression: "* Moderate fluid collection on the right side.\n* Normal heart size.",
     base_impression: "Moderate right-sided pleural effusion. Normal heart size.",
     preferences_used: 3,
     preferences_applied: [{ preference_id: "pref_xxx", preference_text: "Use bullet point formatting" }, ...],
     base_impression_model: "claude-sonnet-4.6",
     refinement_model: "claude-sonnet-4.6"
   }

7. App displays the personalized impression with attribution showing which preferences influenced it.
```

## Agent Architecture

The system implements the CIPHER algorithm using a **five-agent architecture** that structurally prevents hallucination while learning user preferences.

**For detailed agent documentation, see [`docs/agent-architecture.md`](./agent-architecture.md).**

### Five-Agent Overview

| Agent | Purpose | Key Property |
|-------|---------|--------------|
| **Agent 1: Base Impression** | Generate grounded impression from findings | No access to preferences |
| **Agent 2: Style Refinement** | Apply preferences as style modifications | No access to findings (cannot add content) |
| **Agent 3: Preference Inference** | Decompose edits into atomic changes, classify each | Multi-preference extraction with safety prompts |
| **Agent 4: Preference Validator** | Safety gate for inferred preferences | Validates with clinical context |
| **Agent 5: Super Strict Edit Validator** | Safety gate for directly-typed preferences | Extra paranoid — direct edits are a higher-risk attack vector |

### Why Five Agents?

A single agent applying preferences during generation can hallucinate—e.g., a chest X-ray preference like "Use 'consolidation'" might add "No acute cardiopulmonary consolidation" to a wrist X-ray impression.

The five-agent architecture prevents this **structurally**:
- Agent 1 generates from findings only → output is grounded
- Agent 2 refines style but cannot see findings → cannot add clinical content it hasn't seen
- Agent 3 decomposes edits into atomic changes → classifies each independently, maximizing learning from mixed edits
- Agent 4 validates inferred preferences before storage → blocks content-adding preferences
- Agent 5 validates directly-typed preference edits with stricter rules → higher-risk vector gets more paranoid checking

### Code Structure

```
backend/agent/
├── main.py                     # BedrockAgentCoreApp entrypoint
├── impression_agent.py         # Orchestrator: coordinates Agent 1 & 2
├── base_impression_agent.py    # Agent 1: Base Impression Generator
├── style_refinement_agent.py   # Agent 2: Style Refinement Agent
├── preference_agent.py         # Agent 3: Preference Inference Agent
├── preference_validator.py     # Agent 4: Preference Validator (for inferred prefs)
├── preference_edit_validator.py # Agent 5: Super Strict Validator (for direct edits)
├── models.py                   # Pydantic models
├── db.py                       # DynamoDB operations (~450 lines)
├── embeddings.py               # Cohere Embed v4 via Bedrock (~90 lines)
├── cipher.py                   # k-NN retrieval, cosine similarity
├── config.py                   # Shared configuration (models, thresholds, table names)
├── security.py                 # Security functions (prompt injection, content validation)
└── utils.py                    # Shared utilities (DecimalEncoder for JSON)
```

### Safety Guardrails (Summary)

The system implements 6 layers of defense to ensure only stylistic preferences are learned, now with **multi-preference extraction** that classifies each atomic change independently:

1. **Prompt Injection Detection** - Pattern matching at API boundary
2. **Multi-Change Extraction** - Decompose edit into atomic changes, classify each separately
3. **Category Enforcement** - Pydantic Literal types restrict categories
4. **Confidence Threshold** - Low-confidence preferences rejected
5. **Keyword Filtering** - Whole-word blocklist for content-adding terms
6. **Validator Agent** - Dedicated LLM call for final safety check per change

**Key benefit of multi-preference extraction:** Mixed edits containing both stylistic and clinical changes will save the stylistic ones while rejecting the clinical ones. Previously, any clinical content would cause the entire preference to be rejected.

See [`docs/agent-architecture.md`](./agent-architecture.md) for complete implementation details.

### Generation Attribution

The `/generate` endpoint returns the preferences that influenced output and model attribution:

```json
{
  "impression": "Normal chest radiograph. No acute cardiopulmonary abnormality.",
  "base_impression": "No acute cardiopulmonary abnormality. Heart size normal.",
  "preferences_used": 2,
  "preferences_applied": [
    {"preference_id": "pref_123", "preference_text": "Begin with normalcy statement"},
    {"preference_id": "pref_456", "preference_text": "Use concise phrasing"}
  ],
  "base_impression_model": "claude-sonnet-4.6",
  "refinement_model": "claude-sonnet-4.6",
  "case_id": "Case_001"
}
```

**Model Attribution Fields:**
- `base_impression_model`: Model used for base impression generation (Agent 1)
- `refinement_model`: Model used for style refinement (Agent 2), if preferences were applied

## Security & IAM

### Public Identifiers vs Secrets

**Cognito User Pool IDs and Client IDs are NOT secrets.** These identifiers are intentionally committed to the repository and embedded in client applications:

| Identifier | Example | Why It's Public |
|------------|---------|-----------------|
| User Pool ID | `us-east-1_XXXXXXXXX` | Required by client apps to authenticate users. Cannot be used alone to access data. |
| App Client ID | `XXXXXXXXXXXXXXXXXXXXXXXXXX` | Identifies the application to Cognito. No secret key in SRP flow. |
| API Gateway URL | `https://xxx.execute-api...` | Public endpoint protected by JWT authorization. |

**What IS secret (never committed):**
- AWS access keys (AKIA...)
- AWS secret access keys
- Cognito client secrets (if configured)
- Database credentials
- API tokens

The `.gitignore` excludes `.env` files and other sensitive patterns. AWS credentials should only exist in `~/.aws/credentials` or environment variables, never in the repository.

### Lambda Execution Role

The Lambda proxy function needs permission to invoke the AgentCore Runtime agent and start Step Functions executions (for async processing):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "InvokeAgentRuntime",
      "Effect": "Allow",
      "Action": "bedrock-agentcore:InvokeAgentRuntime",
      "Resource": [
        "arn:aws:bedrock-agentcore:us-east-1:ACCOUNT:runtime/AGENT_ID",
        "arn:aws:bedrock-agentcore:us-east-1:ACCOUNT:runtime/AGENT_ID/*"
      ]
    },
    {
      "Sid": "StepFunctionsStartExecution",
      "Effect": "Allow",
      "Action": "states:StartExecution",
      "Resource": "arn:aws:states:us-east-1:ACCOUNT:stateMachine:cipher-edit-processing"
    },
    {
      "Sid": "CloudWatchLogs",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:us-east-1:ACCOUNT:log-group:/aws/lambda/cipher-api-proxy:*"
    }
  ]
}
```

**Notes:**
- The InvokeAgentRuntime permission requires both the base runtime ARN and a wildcard suffix (`/*`) because the actual API call includes `/runtime-endpoint/DEFAULT` in the resource path.
- The StepFunctionsStartExecution permission allows the Lambda to start a Step Functions state machine execution for async preference extraction (POST /edit uses async pattern to avoid API Gateway timeout).

### Strands Agent Execution Role

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BedrockModelInvoke",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream"
      ],
      "Resource": [
        "arn:aws:bedrock:us-east-1:ACCOUNT:inference-profile/global.anthropic.claude-opus-4-8",
        "arn:aws:bedrock:us-east-1:ACCOUNT:inference-profile/global.anthropic.claude-sonnet-4-6",
        "arn:aws:bedrock:us-east-1:ACCOUNT:inference-profile/global.anthropic.claude-haiku-4-5-20251001-v1:0",
        "arn:aws:bedrock:us-east-1:ACCOUNT:inference-profile/global.cohere.embed-v4:0",
        "arn:aws:bedrock:*::foundation-model/anthropic.claude-opus-4-8",
        "arn:aws:bedrock:*::foundation-model/anthropic.claude-sonnet-4-6",
        "arn:aws:bedrock:*::foundation-model/anthropic.claude-haiku-4-5-20251001-v1:0",
        "arn:aws:bedrock:*::foundation-model/cohere.embed-v4:0"
      ]
    },
    {
      "Sid": "DynamoDBAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:Query",
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:UpdateItem"
      ],
      "Resource": [
        "arn:aws:dynamodb:us-east-1:ACCOUNT:table/radiologist-cases",
        "arn:aws:dynamodb:us-east-1:ACCOUNT:table/radiologist-edit-history",
        "arn:aws:dynamodb:us-east-1:ACCOUNT:table/radiologist-preferences"
      ]
    }
  ]
}
```

## Deployment

### CDK Stacks

1. **AuthStack** (`cdk/cdk/auth_stack.py`)
   - Cognito User Pool (`us-east-1_XXXXXXXXX`)
   - App client (`XXXXXXXXXXXXXXXXXXXXXXXXXX`)

2. **DataStack** (`cdk/cdk/data_stack.py`)
   - DynamoDB tables (Cases, EditHistory, Preferences, UserSettings, RejectedPreferences, Idempotency)
   - GSI for preference lookups

3. **AgentStack** (`cdk/cdk/agent_stack.py`)
   - IAM execution role for Strands agent
   - Bedrock model access (Claude Opus 4.8, Sonnet 4.6, Haiku 4.5, Cohere Embed v4)

4. **ApiStack** (`cdk/cdk/api_stack.py`)
   - API Gateway HTTP API (`https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com`)
   - Cognito JWT authorizer (HttpUserPoolAuthorizer)
   - Lambda proxy function (`cipher-api-proxy`)
   - Rate limiting: 5 req/s, burst 10 (REQ-008)
   - Input validation and prompt injection detection
   - Routes:
     | Method | Path | Description |
     |--------|------|-------------|
     | GET | `/cases` | List all cases for user |
     | GET | `/cases/{caseId}` | Get case details with full edit history |
     | PUT | `/cases/{caseId}` | Update case findings |
     | GET | `/preferences` | List learned preferences with traceability |
     | GET | `/preferences/rejected` | List rejected changes (audit trail) |
     | PUT | `/preferences/{preferenceId}` | Update preference text (with strict safety validation) |
     | DELETE | `/preferences/{preferenceId}` | Delete a learned preference |
     | GET | `/settings` | Get user settings (clinical interpretation, model selection, k_preferences) |
     | PUT | `/settings` | Update user settings |
     | POST | `/settings/reset` | Reset app to defaults (destructive - clears all data) |
     | POST | `/generate` | Generate impression (returns preferences_applied, model attribution) |
     | POST | `/edit` | Save edit and start async preference learning (returns immediately) |
     | GET | `/edit/{editId}/status` | Poll for async edit completion status |

### Deployment Commands

```bash
cd cdk/
uv run cdk synth
uv run cdk deploy --all
```

## API Protocol

### Lambda → AgentCore Runtime

```python
response = bedrock_agentcore.invoke_agent_runtime(
    agentRuntimeArn='arn:aws:bedrock-agentcore:...',
    payload=json.dumps({
        'operation': 'generate_impression',
        'user_id': 'radiologist@hospital.com',  # from JWT claims
        'case_id': 'case_001',
        'findings': 'Mild cardiomegaly. Clear lungs.'
    }).encode('utf-8')
)

# Collect response (non-streaming for now)
result = b''
for event in response['body']:
    if 'chunk' in event:
        result += event['chunk']['bytes']
return result.decode('utf-8')
```

### Future: Lambda Response Streaming

For real-time streaming in Phase 3+, Lambda response streaming can be enabled:

```python
# Lambda function URL with response streaming
def handler(event, context):
    response_stream = context.response_stream

    for chunk in agent_response['body']:
        if 'chunk' in chunk:
            response_stream.write(chunk['chunk']['bytes'])

    response_stream.close()
```

## Performance Considerations

### Latency Targets
- **Full response**: <5 seconds (API Gateway + Lambda + embedding + retrieval + model call)
- **Preference inference**: <5 seconds (one Claude call via Lambda)
- **Note**: Non-streaming initially; streaming optimization in Phase 3

### Optimization Strategies
- Cache embeddings for frequently accessed cases
- Batch DynamoDB queries where possible
- Use DynamoDB on-demand billing for variable workload
- Consider caching similar context retrievals (if patterns emerge)
- Use Lambda provisioned concurrency if cold starts are an issue
- Future: Lambda response streaming for real-time token display

## Monitoring & Observability

### Key Metrics
- Invocation count per user
- Latency (p50, p95, p99)
- Token usage (input + output)
- Edit rate (% of impressions edited)
- Preference inference rate

### CloudWatch Alarms
- InvokeAgentRuntime errors
- DynamoDB throttling
- Bedrock model throttling

## Cost Estimation (Per User, Monthly)

Assumptions:
- 100 cases/month per user
- 50% edit rate
- Average 200 tokens per impression

**Bedrock:**
- Claude Sonnet 4.6 generation: 100 × 200 tokens × $0.003/1K = $0.06
- Claude Sonnet 4.6 preference inference: 50 × 100 tokens × $0.003/1K = $0.015
- Cohere Embed v4: 150 × $0.0001 = $0.015
- **Subtotal: ~$0.09/month**

**API Gateway + Lambda:**
- API Gateway HTTP API: 150 requests × $1/million = ~$0.00
- Lambda: 150 invocations × 5s × 128MB = negligible
- **Subtotal: ~$0.01/month**

**DynamoDB:**
- On-demand pricing: negligible for 100-200 operations
- **Subtotal: ~$0.01/month**

**AgentCore Runtime:**
- Serverless, pay per invocation
- **Subtotal: ~$0.10/month**

**Total: ~$0.21/user/month**

## Future Enhancements

### Case Ingestion (Out of Scope)

The current architecture does not support adding new cases or findings through the app. Cases are pre-loaded (synthetic data initially, MIMIC-CXR later).

**Rationale:**
- **Demo focus**: The core value proposition is CIPHER preference learning (generate → edit → learn), not case management
- **Production reality**: In real healthcare environments, new cases would arrive from external systems (PACS, RIS, HL7/FHIR integration), not be manually entered by radiologists
- **Scope control**: Adding case creation would increase development scope without demonstrating the preference learning capability

**If needed for a more complete demo:**
- Add `POST /cases` endpoint to API Gateway
- Create Flutter web UI for entering findings text
- Add DynamoDB write operation in Lambda/agent
- Minimal complexity, but expands scope beyond preference learning

### Conversational Refinement (Future Enhancement)

The current transactional model requires users to manually edit generated impressions. A conversational refinement mode would allow natural language adjustments before saving:

```
┌─────────────────────────────────────────────────────────────────┐
│  Current: Transactional                                         │
│  Generate → Manual Edit → Save                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ Future
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Future: Conversational Refinement                              │
│  Generate → "Make it shorter" → "Add prior comparison" → Save   │
│                                                                 │
│  Examples:                                                      │
│  - "Make it more concise"                                       │
│  - "Use simpler language"                                       │
│  - "Add comparison to prior study"                              │
│  - "Why did you phrase it that way?"                            │
└─────────────────────────────────────────────────────────────────┘
```

**Implementation requirements:**
- **Session strategy change**: Switch from fresh sessions to user-based session IDs so the agent maintains conversation context
- **New endpoint**: Add `POST /refine` or extend `/generate` to handle refinement requests
- **Flutter web UI**: Add chat-like interface for sending refinement instructions
- **Agent updates**: Modify agent to handle refinement prompts and maintain context
- **Audit logging**: For medical applications, conversation history should be logged

**Benefits:**
- Reduces manual editing friction
- Natural language is faster than text manipulation for some changes
- Agent can explain its reasoning when asked
- Preferences can be confirmed conversationally

**Trade-offs:**
- More complex implementation
- State-dependent behavior harder to debug
- Requires conversation logging for auditability

### Phase 3: Streaming Support

Streaming requires careful consideration due to authentication constraints:

**Challenge:** API Gateway does not support Lambda response streaming. Lambda response streaming only works with Lambda Function URLs, which lack built-in JWT authorization.

**Options to evaluate:**
- **Lambda Function URL + JWT validation in Lambda**: Unauthenticated requests still invoke (and cost) Lambda before rejection
- **API Gateway WebSocket API**: Supports authorizers, more architectural change, better for bidirectional use cases
- **CloudFront + Lambda@Edge**: Can add JWT validation at the edge before Lambda Function URL
- **Accept non-streaming**: Generation latency is dominated by LLM inference, not response delivery; for short impressions (~100-200 words), buffering adds minimal perceived latency

**If implementing streaming:**
- Evaluate security trade-offs before choosing an approach
- Lambda Function URL with `NONE` auth is not recommended due to exposure risk

### Phase 4+ Considerations
- **Bi-directional streaming**: WebSocket for voice interactions or real-time collaboration
- **Preference editing**: ~~Allow users to manually edit/delete learned preferences~~ ✅ IMPLEMENTED
- **Multi-modal**: Support images (chest X-rays) with Nova models
- **Preference export**: Download preferences as JSON for transparency
- **A/B testing**: Compare CIPHER vs. fine-tuned models
- **Preference effectiveness analytics**: Track if preferences are reducing edit distance over time

## Credential Handling

Credentials must not be committed to source, documentation, examples, or Git history. Enter local test credentials interactively or retrieve them from an approved secret store. CI/CD environments should use AWS Secrets Manager or the CI provider's encrypted secret storage.

If a credential is exposed, rotate it immediately and review repository history and build artifacts before publishing.

## References

- CIPHER Paper: Gao et al., "Aligning LLM Agents by Learning Latent Preference from User Edits", NeurIPS 2024
- AWS Bedrock AgentCore Runtime: https://docs.aws.amazon.com/bedrock-agentcore/
- Strands Framework: (documentation via MCP server)
- MIMIC-CXR Dataset: https://physionet.org/content/mimic-cxr/2.1.0/
