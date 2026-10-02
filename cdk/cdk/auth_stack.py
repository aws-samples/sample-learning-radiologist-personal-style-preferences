from aws_cdk import (
    Stack,
    RemovalPolicy,
    CfnOutput,
    aws_cognito as cognito,
)
from constructs import Construct


class AuthStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # Cognito User Pool for radiologist authentication
        self.user_pool = cognito.UserPool(
            self,
            "RadiologistUserPool",
            user_pool_name="radiologist-preferences-users",
            self_sign_up_enabled=False,  # Admin creates accounts
            sign_in_aliases=cognito.SignInAliases(email=True),
            auto_verify=cognito.AutoVerifiedAttrs(email=True),
            password_policy=cognito.PasswordPolicy(
                min_length=12,
                require_lowercase=True,
                require_uppercase=True,
                require_digits=True,
                require_symbols=True,
            ),
            removal_policy=RemovalPolicy.DESTROY,  # For dev - allows deletion
        )

        # App client for the web application
        self.user_pool_client = self.user_pool.add_client(
            "MacOSAppClient",
            user_pool_client_name="macos-app",
            auth_flows=cognito.AuthFlow(
                user_password=True,       # Allow username/password auth
                user_srp=True,            # Secure Remote Password protocol
                admin_user_password=True, # Allow admin auth for testing scripts
            ),
            generate_secret=False,  # Public client (web app)
        )

        # Output the IDs we'll need for the web app
        CfnOutput(self, "UserPoolId", value=self.user_pool.user_pool_id)
        CfnOutput(self, "UserPoolClientId", value=self.user_pool_client.user_pool_client_id)
