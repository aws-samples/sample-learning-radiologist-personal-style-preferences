# API Testing Scripts

> **Related Documentation:**
> - [Deployment Guide](../docs/deployment-guide.md) - Full deployment instructions
> - [Architecture](../docs/architecture.md) - API endpoint specifications

Scripts for testing the CIPHER Preference Learning API with Cognito JWT authentication.

## Prerequisites

- Python 3.14+ (managed via `uv`)
- AWS credentials configured (`aws configure` or environment variables)
- A valid test user in the Cognito User Pool

## Setup

```bash
cd scripts
uv sync
```

This installs the required dependencies (`boto3`, `requests`).

## Scripts

### get_token.py

Authenticates with Cognito and outputs a JWT token for manual API testing.

**Usage:**
```bash
export TEST_USER_EMAIL=user@example.com
read -s TEST_USER_PASSWORD
export TEST_USER_PASSWORD
uv run python get_token.py
```

**Using the token with curl:**
```bash
TOKEN=$(uv run python get_token.py)
curl -H "Authorization: Bearer $TOKEN" https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com/cases
```

### test_api.py

Runs a comprehensive test suite against all API endpoints.

**Usage:**
```bash
export TEST_USER_EMAIL=user@example.com
read -s TEST_USER_PASSWORD
export TEST_USER_PASSWORD
uv run python test_api.py
```

**Tests performed:**
- Unauthorized access (401 response without token)
- `GET /cases` - List all cases for user
- `GET /cases/{caseId}` - Get case details
- `GET /preferences` - List learned preferences
- `POST /generate` - Generate impression from findings
- Input validation (400 response for invalid inputs)

## Configuration

### Required Arguments

These must be provided via command line or environment variable:

| Argument | Env Variable | Description |
|----------|--------------|-------------|
| `-e, --email` | `TEST_USER_EMAIL` | Cognito user email |
| `-p, --password` | `TEST_USER_PASSWORD` | Cognito user password |

### Deployment-Specific Arguments

These must be set per deployment (from CDK outputs):

| Argument | Env Variable | Description |
|----------|--------------|-------------|
| `--user-pool-id` | `COGNITO_USER_POOL_ID` | From CDK output `UserPoolId` |
| `--client-id` | `COGNITO_CLIENT_ID` | From CDK output `UserPoolClientId` |
| `--api-endpoint` | `API_ENDPOINT` | From CDK output `ApiEndpoint` |
| `--region` | `AWS_REGION` | Default: `us-east-1` |

**Tip**: Set environment variables in your shell profile:
```bash
export COGNITO_USER_POOL_ID=us-east-1_XXXXXXXX
export COGNITO_CLIENT_ID=XXXXXXXXXXXXXXXXXXXX
export API_ENDPOINT=https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com
```

## Help

View all options:
```bash
uv run python get_token.py --help
uv run python test_api.py --help
```

## Example Output

```
$ uv run python test_api.py -e test@example.com -p 'MyPassword!'

============================================================
CIPHER API Test Suite
============================================================

📍 API Endpoint: https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com
👤 Test User: test@example.com
🔐 Authenticating with Cognito...
   ✅ Token obtained (length: 1234)

🔒 Testing unauthorized access...
   ✅ Correctly rejected with 401

📋 Testing GET /cases...
   ✅ Status: 200
   📊 Cases found: 25
   📝 First case: case_001

...

============================================================
Test Summary
============================================================
   ✅ PASS: Unauthorized Access
   ✅ PASS: GET /cases
   ✅ PASS: GET /cases/{caseId}
   ✅ PASS: GET /preferences
   ✅ PASS: Input Validation
   ✅ PASS: POST /generate

   Total: 6/6 tests passed
```
