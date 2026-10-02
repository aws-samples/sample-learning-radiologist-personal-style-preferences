"""
AgentCore Runtime Entry Point

Uses BedrockAgentCoreApp SDK for deployment to AgentCore Runtime.
Routes requests to:
- Strands agents for LLM operations (generate_impression, save_edit)
- Direct CRUD functions for simple DB operations (get_cases, get_case_detail, get_preferences)
"""

import json
import logging
import traceback

from bedrock_agentcore.runtime import BedrockAgentCoreApp

# Import from agent modules for LLM operations
from impression_agent import generate_impression
from preference_agent import save_edit
from preference_edit_validator import validate_preference_edit

# Import from db.py for CRUD operations
from db import get_cases, get_case_detail, get_preferences
from settings import get_user_model_settings
from utils import DecimalEncoder


# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = BedrockAgentCoreApp()


@app.entrypoint
def invoke(payload: dict) -> dict:
    """
    Main invocation entrypoint for AgentCore Runtime.

    Expects payload dict with:
    - operation: str (generate_impression, save_edit, get_preferences, get_cases, get_case_detail)
    - user_id: str
    - Additional params based on operation

    Routes to:
    - Strands agents for LLM operations (generate_impression, save_edit)
    - Direct DB functions for CRUD operations (get_cases, get_case_detail, get_preferences)
    """
    try:
        operation = payload.get("operation")
        user_id = payload.get("user_id")

        if not operation or not user_id:
            return {"error": "Missing required fields: 'operation' and 'user_id'"}

        logger.info(f"Received invocation: operation={operation}, user={user_id}")

        # Load user's model settings for LLM operations
        model_settings = get_user_model_settings(user_id)

        # Route to appropriate handler
        if operation == "generate_impression":
            # LLM operation - uses Strands agent
            case_id = payload.get("case_id")
            findings = payload.get("findings")
            clinical_interpretation = payload.get("clinical_interpretation", False)
            if not case_id or not findings:
                return {"error": "Missing 'case_id' or 'findings' for generate_impression"}
            result = generate_impression(
                user_id, case_id, findings, clinical_interpretation,
                model_settings=model_settings
            )

        elif operation == "save_edit":
            # LLM operation - uses Strands agent for preference inference
            case_id = payload.get("case_id")
            original_impression = payload.get("original_impression")
            edited_impression = payload.get("edited_impression")
            findings = payload.get("findings")
            if not all([case_id, original_impression, edited_impression, findings]):
                return {"error": "Missing required fields for save_edit"}
            result = save_edit(
                user_id, case_id, original_impression, edited_impression, findings,
                model_settings=model_settings
            )

        elif operation == "get_preferences":
            # CRUD operation - direct DB call
            result = get_preferences(user_id)

        elif operation == "get_cases":
            # CRUD operation - direct DB call
            result = get_cases(user_id)

        elif operation == "get_case_detail":
            # CRUD operation - direct DB call
            case_id = payload.get("case_id")
            if not case_id:
                return {"error": "Missing 'case_id' for get_case_detail"}
            result = get_case_detail(user_id, case_id)

        elif operation == "validate_preference":
            # LLM operation - uses STRICT Validator Agent for direct preference edits
            # This is separate from the inference validator (more paranoid)
            preference_text = payload.get("preference_text")
            if not preference_text:
                return {"error": "Missing 'preference_text' for validate_preference"}
            validation_result = validate_preference_edit(preference_text)
            result = validation_result.model_dump()

        else:
            return {"error": f"Unknown operation: {operation}"}

        logger.info(f"Operation {operation} completed successfully")

        # Convert Decimal types from DynamoDB to JSON-serializable format
        return json.loads(json.dumps(result, cls=DecimalEncoder))

    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        logger.error(traceback.format_exc())
        return {"error": str(e)}


if __name__ == "__main__":
    app.run()
