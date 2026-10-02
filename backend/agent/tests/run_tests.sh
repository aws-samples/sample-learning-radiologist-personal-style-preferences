#!/bin/bash
# Run CIPHER backend tests via agentcore invoke
#
# Usage:
#   cd backend/agent
#   ./tests/run_tests.sh
#
# Requires:
#   - agentcore CLI installed (pip install bedrock-agentcore)
#   - DynamoDB tables deployed (via CDK DataStack)
#   - Synthetic data loaded for test-user@example.com
#   - AWS credentials configured

set -e

USER="test-user@example.com"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "========================================"
echo "CIPHER Backend Tests via agentcore invoke"
echo "========================================"

# Test 1: Get Cases
echo ""
echo "Test 1: get_cases"
echo "-----------------------------------------"
RESULT=$(uv run agentcore invoke "{\"operation\": \"get_cases\", \"user_id\": \"$USER\"}")
echo "$RESULT" | jq .
if echo "$RESULT" | jq -e '.cases' > /dev/null 2>&1; then
    COUNT=$(echo "$RESULT" | jq '.count')
    echo -e "${GREEN}[PASS] Retrieved $COUNT cases${NC}"
else
    echo -e "${RED}[FAIL] Could not get cases${NC}"
    exit 1
fi

# Test 2: Get Case Detail
echo ""
echo "Test 2: get_case_detail"
echo "-----------------------------------------"
RESULT=$(uv run agentcore invoke "{\"operation\": \"get_case_detail\", \"user_id\": \"$USER\", \"case_id\": \"case_001\"}")
echo "$RESULT" | jq .
if echo "$RESULT" | jq -e '.findings' > /dev/null 2>&1; then
    echo -e "${GREEN}[PASS] Retrieved case detail${NC}"
else
    echo -e "${RED}[FAIL] Could not get case detail${NC}"
    exit 1
fi

# Test 3: Generate Impression (No Prior Preferences)
echo ""
echo "Test 3: generate_impression (no prefs)"
echo "-----------------------------------------"
FINDINGS="PA and lateral views of the chest. The cardiomediastinal silhouette is within normal limits. The lungs are clear without focal consolidation, pleural effusion, or pneumothorax."
RESULT=$(uv run agentcore invoke "{\"operation\": \"generate_impression\", \"user_id\": \"$USER\", \"case_id\": \"case_001\", \"findings\": \"$FINDINGS\"}")
echo "$RESULT" | jq .
if echo "$RESULT" | jq -e '.impression' > /dev/null 2>&1; then
    IMPRESSION=$(echo "$RESULT" | jq -r '.impression')
    echo -e "${GREEN}[PASS] Generated: ${IMPRESSION:0:80}...${NC}"
else
    echo -e "${RED}[FAIL] Could not generate impression${NC}"
    exit 1
fi

# Test 4: Save Edit (Significant - should infer preference)
echo ""
echo "Test 4: save_edit (significant edit)"
echo "-----------------------------------------"
ORIGINAL="Bilateral airspace opacities concerning for pneumonia."
EDITED="Bilateral lower lobe consolidations consistent with pneumonia. Small bilateral pleural effusions."
RESULT=$(uv run agentcore invoke "{
    \"operation\": \"save_edit\",
    \"user_id\": \"$USER\",
    \"case_id\": \"case_004\",
    \"original_impression\": \"$ORIGINAL\",
    \"edited_impression\": \"$EDITED\",
    \"findings\": \"$FINDINGS\"
}")
echo "$RESULT" | jq .
if echo "$RESULT" | jq -e '.edit_id' > /dev/null 2>&1; then
    PREF_INFERRED=$(echo "$RESULT" | jq '.preference_inferred')
    echo -e "${GREEN}[PASS] Edit saved, preference_inferred: $PREF_INFERRED${NC}"
else
    echo -e "${RED}[FAIL] Could not save edit${NC}"
    exit 1
fi

# Test 5: Get Preferences
echo ""
echo "Test 5: get_preferences"
echo "-----------------------------------------"
RESULT=$(uv run agentcore invoke "{\"operation\": \"get_preferences\", \"user_id\": \"$USER\"}")
echo "$RESULT" | jq .
if echo "$RESULT" | jq -e '.preferences' > /dev/null 2>&1; then
    COUNT=$(echo "$RESULT" | jq '.count')
    echo -e "${GREEN}[PASS] Retrieved $COUNT preferences${NC}"
else
    echo -e "${RED}[FAIL] Could not get preferences${NC}"
    exit 1
fi

echo ""
echo "========================================"
echo "ALL TESTS PASSED"
echo "========================================"
