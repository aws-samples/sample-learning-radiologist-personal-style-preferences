"""
AgentStack - IAM Role for CIPHER Agent

Creates an IAM role with permissions for:
- DynamoDB: GetItem, PutItem, Query, UpdateItem on Cases, EditHistory, Preferences, RejectedPreferences tables
- Bedrock: InvokeModel for Claude Opus 4.8 / Sonnet 4.6 / Haiku 4.5 + Cohere Embed v4
  (global cross-region inference profiles)

This role is used when deploying the agent to AgentCore Runtime.
"""

from aws_cdk import (
    Stack,
    CfnOutput,
    aws_iam as iam,
)
from constructs import Construct


class AgentStack(Stack):
    def __init__(
        self,
        scope: Construct,
        construct_id: str,
        data_stack=None,
        **kwargs
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)

        region = Stack.of(self).region
        account = Stack.of(self).account

        # Execution role assumed by AgentCore Runtime to run the agent.
        # Pass this role's ARN to the agent at deploy time:
        #   agentcore configure ... --execution-role <AgentRoleArn output>
        # so the runtime uses THIS role (defined in CDK) rather than a
        # toolkit-auto-created one. This keeps IAM as a single source of truth.
        #
        # Trust policy per AgentCore Runtime requirements:
        #  - principal MUST be bedrock-agentcore.amazonaws.com (NOT bedrock.amazonaws.com)
        #  - confused-deputy conditions scope the trust to this account + the
        #    AgentCore service ARNs in this region.
        self.agent_role = iam.Role(
            self,
            "CipherAgentRole",
            role_name="cipher-agent-execution-role",
            assumed_by=iam.ServicePrincipal(
                "bedrock-agentcore.amazonaws.com",
                conditions={
                    "StringEquals": {"aws:SourceAccount": account},
                    "ArnLike": {
                        "aws:SourceArn": f"arn:aws:bedrock-agentcore:{region}:{account}:*"
                    },
                },
            ),
            description="Execution role for CIPHER preference learning agent",
        )

        # DynamoDB permissions - specific tables, specific actions

        tables = [
            f"arn:aws:dynamodb:{region}:{account}:table/radiologist-cases",
            f"arn:aws:dynamodb:{region}:{account}:table/radiologist-edit-history",
            f"arn:aws:dynamodb:{region}:{account}:table/radiologist-preferences",
            f"arn:aws:dynamodb:{region}:{account}:table/radiologist-rejected-preferences",
        ]

        self.agent_role.add_to_policy(
            iam.PolicyStatement(
                sid="DynamoDBAccess",
                effect=iam.Effect.ALLOW,
                actions=[
                    "dynamodb:GetItem",
                    "dynamodb:PutItem",
                    "dynamodb:Query",
                    "dynamodb:UpdateItem",
                ],
                resources=tables,
            )
        )

        # Bedrock permissions - specific models only (least privilege).
        #
        # The agent invokes GLOBAL cross-region inference profiles (model IDs are
        # prefixed `global.`, see backend/agent/config.py). Invoking a global
        # inference profile requires BOTH:
        #   1. the inference-profile ARN (regional resource, account-scoped), and
        #   2. the underlying foundation-model ARNs the profile routes to
        #      (account-less; a `global.` profile can route to any region, so the
        #      region segment is wildcarded).
        # Granting only the profile ARN (the previous bug) yields AccessDenied at
        # invocation time. The previous ARNs were also malformed (`us::` region
        # segment) and used the wrong `us.` prefix for `global.` profiles.
        bedrock_profile_ids = [
            "global.anthropic.claude-opus-4-8",
            "global.anthropic.claude-sonnet-4-6",
            "global.anthropic.claude-haiku-4-5-20251001-v1:0",
            "global.cohere.embed-v4:0",
        ]
        bedrock_foundation_models = [
            "anthropic.claude-opus-4-8",
            "anthropic.claude-sonnet-4-6",
            "anthropic.claude-haiku-4-5-20251001-v1:0",
            "cohere.embed-v4:0",
        ]
        self.agent_role.add_to_policy(
            iam.PolicyStatement(
                sid="BedrockModelInvoke",
                effect=iam.Effect.ALLOW,
                actions=[
                    "bedrock:InvokeModel",
                    "bedrock:InvokeModelWithResponseStream",
                ],
                resources=[
                    f"arn:aws:bedrock:{region}:{account}:inference-profile/{profile_id}"
                    for profile_id in bedrock_profile_ids
                ]
                + [
                    f"arn:aws:bedrock:*::foundation-model/{model_id}"
                    for model_id in bedrock_foundation_models
                ],
            )
        )

        # CloudWatch Logs - AgentCore Runtime writes to /aws/bedrock-agentcore/runtimes/*.
        # DescribeLogGroups requires a log-group:* resource (it can't be scoped tighter).
        self.agent_role.add_to_policy(
            iam.PolicyStatement(
                sid="CloudWatchLogsWrite",
                effect=iam.Effect.ALLOW,
                actions=[
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:DescribeLogStreams",
                ],
                resources=[
                    f"arn:aws:logs:{region}:{account}:log-group:/aws/bedrock-agentcore/runtimes/*",
                    f"arn:aws:logs:{region}:{account}:log-group:/aws/bedrock-agentcore/runtimes/*:log-stream:*",
                ],
            )
        )
        self.agent_role.add_to_policy(
            iam.PolicyStatement(
                sid="CloudWatchLogsDescribe",
                effect=iam.Effect.ALLOW,
                actions=["logs:DescribeLogGroups"],
                resources=[f"arn:aws:logs:{region}:{account}:log-group:*"],
            )
        )

        # X-Ray + CloudWatch metrics for AgentCore Observability.
        self.agent_role.add_to_policy(
            iam.PolicyStatement(
                sid="Observability",
                effect=iam.Effect.ALLOW,
                actions=[
                    "xray:PutTraceSegments",
                    "xray:PutTelemetryRecords",
                    "xray:GetSamplingRules",
                    "xray:GetSamplingTargets",
                ],
                resources=["*"],
            )
        )
        self.agent_role.add_to_policy(
            iam.PolicyStatement(
                sid="CloudWatchMetrics",
                effect=iam.Effect.ALLOW,
                actions=["cloudwatch:PutMetricData"],
                resources=["*"],
                conditions={"StringEquals": {"cloudwatch:namespace": "bedrock-agentcore"}},
            )
        )

        # AgentCore workload identity - required for the runtime to issue the
        # workload access token the agent runs under.
        self.agent_role.add_to_policy(
            iam.PolicyStatement(
                sid="AgentCoreWorkloadIdentity",
                effect=iam.Effect.ALLOW,
                actions=[
                    "bedrock-agentcore:GetWorkloadAccessToken",
                    "bedrock-agentcore:GetWorkloadAccessTokenForJWT",
                    "bedrock-agentcore:GetWorkloadAccessTokenForUserId",
                ],
                resources=[
                    f"arn:aws:bedrock-agentcore:{region}:{account}:workload-identity-directory/default",
                    f"arn:aws:bedrock-agentcore:{region}:{account}:workload-identity-directory/default/workload-identity/cipher_agent-*",
                ],
            )
        )

        # Outputs
        CfnOutput(self, "AgentRoleArn", value=self.agent_role.role_arn)
        CfnOutput(self, "AgentRoleName", value=self.agent_role.role_name)
