from aws_cdk import (
    Stack,
    RemovalPolicy,
    CfnOutput,
    aws_dynamodb as dynamodb,
)
from constructs import Construct


class DataStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # Cases table - stores radiology cases with findings and impressions
        self.cases_table = dynamodb.Table(
            self,
            "CasesTable",
            table_name="radiologist-cases",
            partition_key=dynamodb.Attribute(
                name="user_id", type=dynamodb.AttributeType.STRING
            ),
            sort_key=dynamodb.Attribute(
                name="case_id", type=dynamodb.AttributeType.STRING
            ),
            billing_mode=dynamodb.BillingMode.PAY_PER_REQUEST,
            removal_policy=RemovalPolicy.DESTROY,
        )

        # EditHistory table - tracks all user edits for analysis
        self.edit_history_table = dynamodb.Table(
            self,
            "EditHistoryTable",
            table_name="radiologist-edit-history",
            partition_key=dynamodb.Attribute(
                name="user_id", type=dynamodb.AttributeType.STRING
            ),
            sort_key=dynamodb.Attribute(
                name="edit_id", type=dynamodb.AttributeType.STRING
            ),
            billing_mode=dynamodb.BillingMode.PAY_PER_REQUEST,
            removal_policy=RemovalPolicy.DESTROY,
        )

        # Preferences table - learned style preferences with context embeddings
        self.preferences_table = dynamodb.Table(
            self,
            "PreferencesTable",
            table_name="radiologist-preferences",
            partition_key=dynamodb.Attribute(
                name="user_id", type=dynamodb.AttributeType.STRING
            ),
            sort_key=dynamodb.Attribute(
                name="preference_id", type=dynamodb.AttributeType.STRING
            ),
            billing_mode=dynamodb.BillingMode.PAY_PER_REQUEST,
            removal_policy=RemovalPolicy.DESTROY,
        )

        # UserSettings table - per-user settings (clinical_interpretation, etc.)
        self.user_settings_table = dynamodb.Table(
            self,
            "UserSettingsTable",
            table_name="radiologist-user-settings",
            partition_key=dynamodb.Attribute(
                name="user_id", type=dynamodb.AttributeType.STRING
            ),
            billing_mode=dynamodb.BillingMode.PAY_PER_REQUEST,
            removal_policy=RemovalPolicy.DESTROY,
        )

        # RejectedPreferences table - audit trail of rejected content-adding changes
        self.rejected_preferences_table = dynamodb.Table(
            self,
            "RejectedPreferencesTable",
            table_name="radiologist-rejected-preferences",
            partition_key=dynamodb.Attribute(
                name="user_id", type=dynamodb.AttributeType.STRING
            ),
            sort_key=dynamodb.Attribute(
                name="rejection_id", type=dynamodb.AttributeType.STRING
            ),
            billing_mode=dynamodb.BillingMode.PAY_PER_REQUEST,
            removal_policy=RemovalPolicy.DESTROY,
        )

        # Idempotency table - deduplicates POST requests (24-hour TTL)
        self.idempotency_table = dynamodb.Table(
            self,
            "IdempotencyTable",
            table_name="radiologist-idempotency",
            partition_key=dynamodb.Attribute(
                name="idempotency_key", type=dynamodb.AttributeType.STRING
            ),
            billing_mode=dynamodb.BillingMode.PAY_PER_REQUEST,
            removal_policy=RemovalPolicy.DESTROY,
            time_to_live_attribute="expires_at",
        )

        # Outputs for reference
        CfnOutput(self, "CasesTableName", value=self.cases_table.table_name)
        CfnOutput(self, "CasesTableArn", value=self.cases_table.table_arn)
        CfnOutput(self, "EditHistoryTableName", value=self.edit_history_table.table_name)
        CfnOutput(self, "EditHistoryTableArn", value=self.edit_history_table.table_arn)
        CfnOutput(self, "PreferencesTableName", value=self.preferences_table.table_name)
        CfnOutput(self, "PreferencesTableArn", value=self.preferences_table.table_arn)
        CfnOutput(self, "UserSettingsTableName", value=self.user_settings_table.table_name)
        CfnOutput(self, "UserSettingsTableArn", value=self.user_settings_table.table_arn)
        CfnOutput(self, "RejectedPreferencesTableName", value=self.rejected_preferences_table.table_name)
        CfnOutput(self, "RejectedPreferencesTableArn", value=self.rejected_preferences_table.table_arn)
        CfnOutput(self, "IdempotencyTableName", value=self.idempotency_table.table_name)
        CfnOutput(self, "IdempotencyTableArn", value=self.idempotency_table.table_arn)
