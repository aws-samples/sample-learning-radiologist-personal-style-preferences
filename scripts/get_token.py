#!/usr/bin/env python3
"""
Get Cognito JWT Token

Authenticates with Cognito and prints the JWT token for manual API testing.
Set TEST_USER_EMAIL and TEST_USER_PASSWORD before running this command.

Usage:
    cd scripts
    uv run python get_token.py

    # Use with curl:
    TOKEN=$(uv run python get_token.py)
    curl -H "Authorization: Bearer $TOKEN" https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com/cases
"""

import argparse
import os
import sys

import boto3


def parse_args() -> argparse.Namespace:
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description="Get Cognito JWT token for API testing",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
    export TEST_USER_EMAIL=user@example.com
    export TEST_USER_PASSWORD
    uv run python get_token.py

Environment variables (used if args not provided):
    TEST_USER_EMAIL     - User email address
    TEST_USER_PASSWORD  - User password
    COGNITO_USER_POOL_ID - Cognito User Pool ID
    COGNITO_CLIENT_ID    - Cognito App Client ID
    AWS_REGION          - AWS region
        """,
    )
    parser.add_argument(
        "-e", "--email",
        default=os.environ.get("TEST_USER_EMAIL"),
        help="User email address (or set TEST_USER_EMAIL env var)",
    )
    parser.add_argument(
        "-p", "--password",
        default=os.environ.get("TEST_USER_PASSWORD"),
        help="User password (or set TEST_USER_PASSWORD env var)",
    )
    parser.add_argument(
        "--user-pool-id",
        default=os.environ.get("COGNITO_USER_POOL_ID"),
        help="Cognito User Pool ID (or set COGNITO_USER_POOL_ID env var)",
    )
    parser.add_argument(
        "--client-id",
        default=os.environ.get("COGNITO_CLIENT_ID"),
        help="Cognito App Client ID (or set COGNITO_CLIENT_ID env var)",
    )
    parser.add_argument(
        "--region",
        default=os.environ.get("AWS_REGION", "us-east-1"),
        help="AWS region (default: us-east-1)",
    )
    return parser.parse_args()


def get_config() -> dict:
    """Get configuration from command line args and environment variables."""
    args = parse_args()

    # Validate required credentials
    if not args.email:
        print("Error: Email required. Use --email or set TEST_USER_EMAIL env var.", file=sys.stderr)
        sys.exit(1)
    if not args.password:
        print("Error: Password required. Use --password or set TEST_USER_PASSWORD env var.", file=sys.stderr)
        sys.exit(1)
    if not args.user_pool_id:
        print("Error: User Pool ID required. Use --user-pool-id or set COGNITO_USER_POOL_ID env var.", file=sys.stderr)
        sys.exit(1)
    if not args.client_id:
        print("Error: Client ID required. Use --client-id or set COGNITO_CLIENT_ID env var.", file=sys.stderr)
        sys.exit(1)

    return {
        "user_pool_id": args.user_pool_id,
        "cognito_client_id": args.client_id,
        "region": args.region,
        "test_user_email": args.email,
        "test_user_password": args.password,
    }


def get_token(config: dict) -> str:
    """Authenticate with Cognito and return JWT ID token."""
    client = boto3.client("cognito-idp", region_name=config["region"])

    try:
        # Use admin_initiate_auth since we have AWS credentials
        response = client.admin_initiate_auth(
            UserPoolId=config["user_pool_id"],
            ClientId=config["cognito_client_id"],
            AuthFlow="ADMIN_USER_PASSWORD_AUTH",
            AuthParameters={
                "USERNAME": config["test_user_email"],
                "PASSWORD": config["test_user_password"],
            },
        )
        return response["AuthenticationResult"]["IdToken"]

    except client.exceptions.NotAuthorizedException:
        print("Error: Invalid credentials", file=sys.stderr)
        sys.exit(1)
    except client.exceptions.UserNotFoundException:
        print("Error: User not found", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    config = get_config()
    token = get_token(config)
    print(token)
