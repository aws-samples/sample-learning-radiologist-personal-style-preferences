# Full Deployment Guide

> **Related Documentation:**
> - [Architecture](architecture.md) - System design, data flows, API specs
> - [Agent Architecture](agent-architecture.md) - Five-agent pipeline details
> - [Security Requirements](security-requirements.md) - Security requirements
> - [Data Management](../data/README.md) - Data source setup

Complete steps to deploy the CIPHER Radiology Preference Learning system from scratch in a new AWS account.

## Prerequisites

1. **AWS Account** with Bedrock model access enabled (Claude Opus 4.8, Sonnet 4.6, Haiku 4.5, Cohere Embed v4)
2. **Python 3.12+** with `uv` package manager (the AgentCore runtime is Python 3.13; the CDK app targets 3.14)
3. **Node.js** (for CDK CLI)
4. **Flutter SDK** (for building the web app)
5. **AWS CLI** configured with appropriate credentials

**Verify AWS Account** before deploying:
```bash
aws sts get-caller-identity
```

**Bootstrap CDK** (once per account/region):
```bash
cd cdk
uv run cdk bootstrap
```

## Step 1: Deploy Base CDK Stacks

Deploy authentication and data infrastructure first. ApiStack is deployed later in Step 4 after configuring the AgentCore agent (it requires the Agent ARN). WebStack is deployed separately in Step 8 after building the Flutter app.

First, ensure `synthetic_cases.json` is available for the Lambda bundle (needed for the in-app reset feature):
```bash
cp data/synthetic_cases.json backend/lambda/
```

Then deploy:
```bash
cd cdk
uv run cdk deploy AuthStack DataStack AgentStack --require-approval never
```

Note the outputs - you'll need these later:
- `UserPoolId` - e.g., `us-east-1_XXXXXXXX`
- `UserPoolClientId` - e.g., `XXXXXXXXXXXXXXXXXXXX`
- `AgentStack.AgentRoleArn` - e.g., `arn:aws:iam::XXXXXXXXXXXX:role/cipher-agent-execution-role`
  (the agent's execution role — passed to `agentcore configure` in Step 2)

## Step 2: Configure and Deploy AgentCore Agent

The agent's execution role is created by CDK (`AgentStack`, Step 1) — it already
carries all DynamoDB, Bedrock, logging, and workload-identity permissions the
agent needs. Pass that role's ARN to `agentcore configure` with `--execution-role`
so the runtime uses it instead of auto-creating its own. This keeps IAM defined in
one place (CDK), version-controlled.

```bash
cd backend/agent

# Remove any old config from previous deployments
rm -rf .bedrock_agentcore.yaml .bedrock_agentcore

# Use the AgentRoleArn from Step 1's CDK output
AGENT_ROLE_ARN="arn:aws:iam::XXXXXXXXXXXX:role/cipher-agent-execution-role"

# Configure the agent (non-interactive), pointing at the CDK-managed role
uv run agentcore configure -c -n cipher_agent -e main.py -ni -p HTTP \
  --execution-role "$AGENT_ROLE_ARN"
```

**IMPORTANT**: Edit `.bedrock_agentcore.yaml` before deploying — the `-c` (create) flag
defaults to container deployment, so you must change these settings:
```yaml
deployment_type: direct_code_deploy  # NOT container
runtime_type: PYTHON_3_13            # Supported: PYTHON_3_10 through PYTHON_3_13
platform: linux/amd64
container_runtime: null
source_path: null
```

Also set `memory.mode` to `NO_MEMORY` (the agent manages its own state in DynamoDB).

Confirm the configured execution role matches the CDK role (not an auto-created one):
```bash
grep execution_role backend/agent/.bedrock_agentcore.yaml
# Should show: .../role/cipher-agent-execution-role
```

Then deploy:
```bash
uv run agentcore deploy
```

Note the Agent ARN from the output:
- e.g., `arn:aws:bedrock-agentcore:us-east-1:XXXXXXXXXXXX:runtime/cipher_agent-XXXXXXXXXX`

> **Note:** The CDK role's `aws:SourceArn` trust condition scopes it to AgentCore
> service ARNs in this account/region. The workload-identity statement is scoped to
> `cipher_agent-*`; if you deploy the agent under a different name, update
> `cdk/cdk/agent_stack.py` accordingly and redeploy `AgentStack`.

## Step 3: Execution role (no manual steps)

The agent's permissions are fully defined in `cdk/cdk/agent_stack.py` and were
applied when you deployed `AgentStack` in Step 1. There are **no manual
`aws iam put-role-policy` steps** — to change the agent's permissions, edit
`AgentStack` and re-run `cdk deploy AgentStack`.

If you ever need to inspect what the agent is allowed to do:
```bash
aws iam list-role-policies --role-name cipher-agent-execution-role
aws iam get-role-policy --role-name cipher-agent-execution-role \
    --policy-name <policy-name-from-above>
```

## Step 4: Deploy ApiStack with Agent ARN

Set the Agent ARN from Step 2 and deploy the API stack (API Gateway + Lambda proxy):

```bash
cd cdk
AGENT_RUNTIME_ARN="arn:aws:bedrock-agentcore:us-east-1:XXXXXXXXXXXX:runtime/cipher_agent-XXXXXXXXXX" \
  uv run cdk deploy ApiStack --require-approval never
```

Alternatively, edit `cdk/app.py` and update the `agent_runtime_arn` default value directly.

Note the output:
- `ApiEndpoint` - e.g., `https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com`

## Step 5: Update Configuration Files

Update these files with the resource IDs from Steps 1 and 4:

### Frontend Configuration

**`frontend-web/lib/config/amplify_config.dart`** and **`frontend-web/lib/config/api_constants.dart`**:
Update the Cognito User Pool ID, Client ID, and API Gateway base URL with the values from Step 1.

### Scripts Configuration (Optional)

**`scripts/test_api.py`** and **`scripts/get_token.py`**:
Update default values or use environment variables:
```bash
export COGNITO_USER_POOL_ID=us-east-1_XXXXXXXX
export COGNITO_CLIENT_ID=XXXXXXXXXXXXXXXXXXXX
export API_ENDPOINT=https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com
```

## Step 6: Create Test User and Load Data

```bash
read -s TEMP_USER_PASSWORD
read -s TEST_USER_PASSWORD

# Create test user in Cognito
aws cognito-idp admin-create-user \
    --user-pool-id us-east-1_XXXXXXXX \
    --username test-user@example.com \
    --user-attributes Name=email,Value=test-user@example.com Name=email_verified,Value=true \
    --temporary-password "$TEMP_USER_PASSWORD" \
    --message-action SUPPRESS

# Set permanent password
aws cognito-idp admin-set-user-password \
    --user-pool-id us-east-1_XXXXXXXX \
    --username test-user@example.com \
    --password "$TEST_USER_PASSWORD" \
    --permanent

# Load synthetic test data (25 cases) FOR THIS USER
# --user-id must match the username above, or the cases won't be visible to them.
cd data
uv run python load_data.py --user-id test-user@example.com --clear
```

**Test Account:**
- Email: `test-user@example.com`
- Password: supplied through `TEST_USER_PASSWORD`

## Step 7: Verify Deployment

Run the API test suite. It needs the Cognito + API values from earlier steps —
pass them as flags or env vars. **The env var names are specific** (a common
mistake is `COGNITO_POOL_ID`/`API_BASE_URL` — those are the *frontend* dart-define
names, NOT what the scripts read):

| Flag | Env var | Source (CDK output) |
|------|---------|---------------------|
| `--user-pool-id` | `COGNITO_USER_POOL_ID` | `AuthStack.UserPoolId` |
| `--client-id` | `COGNITO_CLIENT_ID` | `AuthStack.UserPoolClientId` |
| `--api-endpoint` | `API_ENDPOINT` | `ApiStack.ApiEndpoint` |
| `-e / --email` | `TEST_USER_EMAIL` | the test user |
| `-p / --password` | `TEST_USER_PASSWORD` | the test user |

```bash
cd scripts
export TEST_USER_EMAIL=test-user@example.com
export TEST_USER_PASSWORD
uv run python test_api.py \
  --user-pool-id us-east-1_XXXXXXXX \
  --client-id XXXXXXXXXXXXXXXXXXXX \
  --api-endpoint https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com
```

All 21 tests should pass — auth (401), all cases/preferences/settings routes,
input validation, the safety/prompt-injection rejections, `POST /generate`, and
the `POST /edit` async flow.

You can also smoke-test the agent directly (bypassing API Gateway):
```bash
cd backend/agent
uv run agentcore invoke '{"operation": "get_cases", "user_id": "test-user@example.com"}'
uv run agentcore invoke '{"operation": "generate_impression", "user_id": "test-user@example.com", "case_id": "Case_001", "findings": "The lungs are clear. No pleural effusion or pneumothorax."}'
```

## Step 8: Build and Deploy the Web App

1. Build the Flutter web app: `cd frontend-web && flutter build web`
2. Deploy to S3/CloudFront: `cd cdk && uv run cdk deploy WebStack`
3. Open the CloudFront URL in your browser
4. Log in with test credentials
5. Browse cases, generate impressions, and edit to teach preferences

## Teardown / Clean Redeploy

To tear the deployment down (e.g. for a clean redeploy), remove resources in the
**reverse** of deploy order. Two things are NOT managed by `cdk destroy` and must
be handled manually — the **AgentCore runtime** and **orphaned CloudWatch log
groups**.

```bash
# 1. Delete the AgentCore runtime (not a CDK resource).
#    Find the id from the agent config or list:
grep agent_id backend/agent/.bedrock_agentcore.yaml   # e.g. cipher_agent-XXXXXXXXXX
aws bedrock-agentcore-control delete-agent-runtime --agent-runtime-id cipher_agent-XXXXXXXXXX

# 2. Destroy the CDK stacks in reverse dependency order.
#    All tables use RemovalPolicy.DESTROY and WebStack has auto_delete_objects=True,
#    so DynamoDB tables, the website S3 bucket, and the Cognito pool are removed cleanly.
cd cdk
uv run cdk destroy WebStack ApiStack AgentStack DataStack AuthStack --force

# 3. CRITICAL — delete the Lambda's CloudWatch log group.
#    Lambda auto-creates /aws/lambda/cipher-api-proxy on first invocation; it is
#    NOT owned by CloudFormation and SURVIVES `cdk destroy`. On the next deploy,
#    ApiStack tries to CREATE that log group, hits "already exists", and the whole
#    stack rolls back. Delete it before redeploying:
aws logs delete-log-group --log-group-name /aws/lambda/cipher-api-proxy
```

> If a previous ApiStack deploy already failed this way, it will be stuck in
> `ROLLBACK_COMPLETE` and must be deleted before retry:
> `aws cloudformation delete-stack --stack-name ApiStack` (then delete the log
> group above, then redeploy).

**Not deleted by the above (delete separately only if you intend to):** the
`cipher-mimic-images-*` S3 bucket (created outside CDK; may hold licensed
MIMIC-CXR images), and the shared `CDKToolkit` bootstrap stack.

> ⚠️ **Region:** these commands assume `us-east-1`. If your shell has
> `AWS_REGION` set to another region (it overrides `~/.aws/config`), prefix each
> command with `AWS_REGION=us-east-1` or the calls will hit the wrong region.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Reset clears cases but doesn't reload them | Ensure `synthetic_cases.json` is in `backend/lambda/` (copy from `data/`) and redeploy ApiStack |
| ApiStack deploy fails: log group `/aws/lambda/cipher-api-proxy` "already exists" | Orphaned log group from a prior deploy survived `cdk destroy`. Delete it: `aws logs delete-log-group --log-group-name /aws/lambda/cipher-api-proxy`, then (if ApiStack is `ROLLBACK_COMPLETE`) `aws cloudformation delete-stack --stack-name ApiStack`, then redeploy. See Teardown section. |
| `cdk`/`aws` commands hit the wrong region | An `AWS_REGION` env var overrides `~/.aws/config`. Prefix commands with `AWS_REGION=us-east-1`. |
| API test fails: "User Pool ID required" / "API endpoint required" | Wrong env var names. Scripts read `COGNITO_USER_POOL_ID`, `COGNITO_CLIENT_ID`, `API_ENDPOINT` (NOT the frontend's `COGNITO_POOL_ID`/`API_BASE_URL`). See Step 7. |
| Test user sees zero cases | `load_data.py` loaded cases for a different user. Re-run with `--user-id <the-login-email>`. |
| "Auth flow not enabled" | Add `admin_user_password=True` to `auth_stack.py` AuthFlow and redeploy |
| "AccessDeniedException: dynamodb:Query" | Add DynamoDB policy to AgentCore execution role (Step 3) |
| "Case not found" for GET /cases/{id} | Case IDs use `Case_001` format (uppercase C), not `case_001` |
| "Service configuration error" on POST /generate | Check agent ARN in Lambda env vars matches deployed agent |
| AgentCore deploy fails with S3 access denied | Old `.bedrock_agentcore.yaml` from different account - delete and reconfigure |
| Flutter build errors | Run `flutter clean && flutter pub get` then rebuild |

## Using MIMIC-CXR Data (Optional)

To use real MIMIC-CXR chest X-rays instead of synthetic data, see [data/README.md](../data/README.md) for setup instructions.

## Deployed Resources Summary

After successful deployment, you should have:

| Resource | Example Value |
|----------|---------------|
| User Pool ID | `us-east-1_XXXXXXXXX` |
| Client ID | `XXXXXXXXXXXXXXXXXXXXXXXXXX` |
| API Endpoint | `https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com` |
| Agent ARN | `arn:aws:bedrock-agentcore:us-east-1:XXXXXXXXXXXX:runtime/cipher_agent-XXXXXXXXXX` |
