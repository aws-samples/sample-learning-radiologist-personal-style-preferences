"""
ApiStack - API Gateway HTTP API with Lambda Proxy

Creates:
- Lambda function to proxy requests to AgentCore Runtime
- HTTP API with Cognito JWT authorizer
- Rate limiting (5 req/s, burst 10)
- Routes for all CIPHER operations
"""

import shutil
import subprocess
from pathlib import Path

from aws_cdk import (
    Aws,
    Stack,
    CfnOutput,
    Duration,
    BundlingOptions,
    ILocalBundling,
    aws_lambda as lambda_,
    aws_iam as iam,
    aws_apigatewayv2 as apigwv2,
    aws_stepfunctions as sfn,
    aws_stepfunctions_tasks as tasks,
)
from aws_cdk.aws_apigatewayv2_authorizers import HttpUserPoolAuthorizer
from aws_cdk.aws_apigatewayv2_integrations import HttpLambdaIntegration
from constructs import Construct
import jsii


@jsii.implements(ILocalBundling)
class _LocalBundler:
    """Bundle Lambda dependencies and source without Docker."""

    @staticmethod
    def _copy_files(source: Path, destination: Path, pattern: str) -> None:
        for source_file in source.glob(pattern):
            shutil.copy2(source_file, destination / source_file.name)

    @staticmethod
    def _copy_directory(source: Path, destination: Path) -> None:
        if source.exists():
            shutil.copytree(source, destination, dirs_exist_ok=True)

    def try_bundle(self, output_dir: str, *, image, asset_hash=None, bundling_file_access=None,
                   command=None, entrypoint=None, environment=None, local=None, network=None,
                   output_type=None, platform=None, security_opt=None, user=None,
                   volumes=None, volumes_from=None, working_directory=None) -> bool:
        source = Path(__file__).resolve().parent.parent.parent / "backend" / "lambda"
        destination = Path(output_dir)
        subprocess.run(  # nosemgrep: python.lang.security.audit.dangerous-subprocess-use-audit
            [
                "uv", "pip", "install", "pydantic==2.13.4",
                "--target", output_dir,
                "--python-platform", "x86_64-manylinux2014",
                "--python-version", "3.12",
                "--quiet",
            ],
            check=True,
            shell=False,
        )
        self._copy_files(source, destination, "*.py")
        self._copy_files(source, destination, "*.json")
        for subdir in ["db", "routes"]:
            self._copy_directory(source / subdir, destination / subdir)
        self._copy_directory(source.parent / "shared", destination / "shared")
        return True


class ApiStack(Stack):
    @staticmethod
    def _split_bucket_path(bucket_path: str) -> tuple[str, str]:
        bucket_name, separator, prefix = bucket_path.partition("/")
        return bucket_name, prefix.rstrip("/") if separator else ""

    def _grant_mimic_bucket_access(self, bucket_path: str) -> None:
        bucket_name, prefix = self._split_bucket_path(bucket_path)
        bucket_arn = f"arn:{Aws.PARTITION}:s3:::{bucket_name}"
        list_conditions = {}
        if prefix:
            list_conditions = {
                "StringLike": {"s3:prefix": [prefix, f"{prefix}/*"]}
            }
        self.proxy_function.add_to_role_policy(
            iam.PolicyStatement(
                actions=["s3:ListBucket"],
                resources=[bucket_arn],
                conditions=list_conditions,
            )
        )
        object_path = f"{prefix}/*" if prefix else "*"
        self.proxy_function.add_to_role_policy(
            iam.PolicyStatement(
                actions=["s3:GetObject"],
                resources=[f"{bucket_arn}/{object_path}"],
            )
        )

    def __init__(
        self,
        scope: Construct,
        construct_id: str,
        auth_stack,
        data_stack,
        agent_runtime_arn: str,
        allowed_mimic_bucket_paths: list[str],
        **kwargs,
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)

        region = Stack.of(self).region
        account = Stack.of(self).account

        # Lambda function for API requests
        # - Direct DynamoDB access for GET operations (fast path)
        # - AgentCore invocation for POST operations requiring LLM
        self.proxy_function = lambda_.Function(
            self,
            "CipherProxyFunction",
            function_name="cipher-api-proxy",
            runtime=lambda_.Runtime.PYTHON_3_12,
            handler="handler.handler",
            code=lambda_.Code.from_asset(
                "../backend/lambda",
                bundling=BundlingOptions(
                    image=lambda_.Runtime.PYTHON_3_12.bundling_image,
                    command=[
                        "bash", "-c",
                        "pip install pydantic -t /asset-output && cp -au . /asset-output",
                    ],
                    local=_LocalBundler(),
                ),
            ),
            timeout=Duration.seconds(60),  # Increased for LLM operations
            memory_size=256,
            environment={
                "AGENT_RUNTIME_ARN": agent_runtime_arn,
                "CASES_TABLE": data_stack.cases_table.table_name,
                "PREFERENCES_TABLE": data_stack.preferences_table.table_name,
                "EDIT_HISTORY_TABLE": data_stack.edit_history_table.table_name,
                "USER_SETTINGS_TABLE": data_stack.user_settings_table.table_name,
                "REJECTED_PREFERENCES_TABLE": data_stack.rejected_preferences_table.table_name,
                "IDEMPOTENCY_TABLE": data_stack.idempotency_table.table_name,
            },
        )

        # DynamoDB permissions for direct operations (fast path)
        # Cases table needs read/write for GET, PUT, and DELETE (data source reset)
        data_stack.cases_table.grant_read_write_data(self.proxy_function)
        # Preferences table needs read/write for GET, DELETE, and reset
        data_stack.preferences_table.grant_read_write_data(self.proxy_function)
        # Edit history table needs read/write for GET and DELETE (data source reset)
        data_stack.edit_history_table.grant_read_write_data(self.proxy_function)
        # User settings table needs read/write for GET/PUT /settings
        data_stack.user_settings_table.grant_read_write_data(self.proxy_function)
        # Rejected preferences table needs read/write for GET and DELETE (data source reset)
        data_stack.rejected_preferences_table.grant_read_write_data(self.proxy_function)
        # Idempotency table needs read/write for POST deduplication
        data_stack.idempotency_table.grant_read_write_data(self.proxy_function)

        # IAM permissions for Lambda - InvokeAgentRuntime only
        # Note: ARN includes /runtime-endpoint/DEFAULT suffix when invoked
        self.proxy_function.add_to_role_policy(
            iam.PolicyStatement(
                sid="InvokeAgentRuntime",
                effect=iam.Effect.ALLOW,
                actions=["bedrock-agentcore:InvokeAgentRuntime"],
                resources=[
                    agent_runtime_arn,
                    f"{agent_runtime_arn}/*",
                ],
            )
        )

        # Step Functions state machine for async edit processing
        # Replaces Lambda self-invocation with a managed workflow
        invoke_agent_task = tasks.LambdaInvoke(
            self,
            "InvokeAgentForEdit",
            lambda_function=self.proxy_function,
            retry_on_service_exceptions=True,
            result_path="$.taskResult",
        )
        invoke_agent_task.add_retry(
            errors=["Lambda.ServiceException", "Lambda.TooManyRequestsException"],
            interval=Duration.seconds(5),
            max_attempts=2,
            backoff_rate=2,
        )

        mark_failed_task = tasks.LambdaInvoke(
            self,
            "MarkEditFailed",
            lambda_function=self.proxy_function,
            result_path="$.failResult",
        )

        # Wire catch: on failure, mark edit as failed
        invoke_agent_task.add_catch(
            mark_failed_task,
            errors=["States.ALL"],
            result_path="$.error",
        )

        self.edit_state_machine = sfn.StateMachine(
            self,
            "EditProcessingStateMachine",
            state_machine_name="cipher-edit-processing",
            definition_body=sfn.DefinitionBody.from_chainable(invoke_agent_task),
            timeout=Duration.minutes(10),
        )

        # Construct state machine ARN from known name to avoid circular dependency
        # (Lambda env/policy → state machine → Lambda)
        state_machine_arn = f"arn:aws:states:{region}:{account}:stateMachine:cipher-edit-processing"

        # Grant Lambda permission to start Step Functions executions
        self.proxy_function.add_to_role_policy(
            iam.PolicyStatement(
                sid="StartStepFunctions",
                effect=iam.Effect.ALLOW,
                actions=["states:StartExecution"],
                resources=[state_machine_arn],
            )
        )

        # Add state machine ARN as env var
        self.proxy_function.add_environment(
            "EDIT_STATE_MACHINE_ARN", state_machine_arn
        )

        # CloudWatch Logs permissions (Lambda automatically gets this, but explicit is clearer)
        self.proxy_function.add_to_role_policy(
            iam.PolicyStatement(
                sid="CloudWatchLogs",
                effect=iam.Effect.ALLOW,
                actions=[
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                ],
                resources=[
                    f"arn:aws:logs:{region}:{account}:log-group:/aws/lambda/cipher-api-proxy:*",
                ],
            )
        )

        for bucket_path in allowed_mimic_bucket_paths:
            self._grant_mimic_bucket_access(bucket_path)

        # Cognito JWT authorizer
        authorizer = HttpUserPoolAuthorizer(
            "CognitoAuthorizer",
            auth_stack.user_pool,
            user_pool_clients=[auth_stack.user_pool_client],
        )

        # Lambda integration
        integration = HttpLambdaIntegration(
            "LambdaIntegration",
            self.proxy_function,
        )

        # HTTP API with CORS
        self.http_api = apigwv2.HttpApi(
            self,
            "CipherHttpApi",
            api_name="cipher-preferences-api",
            cors_preflight=apigwv2.CorsPreflightOptions(
                allow_origins=["*"],  # Web app may be served from various origins
                allow_methods=[
                    apigwv2.CorsHttpMethod.GET,
                    apigwv2.CorsHttpMethod.POST,
                    apigwv2.CorsHttpMethod.PUT,
                    apigwv2.CorsHttpMethod.DELETE,
                    apigwv2.CorsHttpMethod.OPTIONS,
                ],
                allow_headers=["Content-Type", "Authorization"],
                max_age=Duration.hours(1),
            ),
            # Create default stage with throttling (REQ-008)
            create_default_stage=False,  # We'll create it manually with throttling
        )

        # Create default stage with throttling
        self.default_stage = apigwv2.HttpStage(
            self,
            "DefaultStage",
            http_api=self.http_api,
            stage_name="$default",
            auto_deploy=True,
            throttle=apigwv2.ThrottleSettings(
                rate_limit=5,  # 5 requests per second
                burst_limit=10,  # burst up to 10
            ),
        )

        # Add routes with authorizer
        # GET /cases
        self.http_api.add_routes(
            path="/cases",
            methods=[apigwv2.HttpMethod.GET],
            integration=integration,
            authorizer=authorizer,
        )

        # GET /cases/{caseId}
        self.http_api.add_routes(
            path="/cases/{caseId}",
            methods=[apigwv2.HttpMethod.GET],
            integration=integration,
            authorizer=authorizer,
        )

        # PUT /cases/{caseId}
        self.http_api.add_routes(
            path="/cases/{caseId}",
            methods=[apigwv2.HttpMethod.PUT],
            integration=integration,
            authorizer=authorizer,
        )

        # GET /preferences
        self.http_api.add_routes(
            path="/preferences",
            methods=[apigwv2.HttpMethod.GET],
            integration=integration,
            authorizer=authorizer,
        )

        # DELETE /preferences/{preferenceId}
        self.http_api.add_routes(
            path="/preferences/{preferenceId}",
            methods=[apigwv2.HttpMethod.DELETE],
            integration=integration,
            authorizer=authorizer,
        )

        # PUT /preferences/{preferenceId} - Update with safety validation
        self.http_api.add_routes(
            path="/preferences/{preferenceId}",
            methods=[apigwv2.HttpMethod.PUT],
            integration=integration,
            authorizer=authorizer,
        )

        # GET /preferences/rejected - Get rejected changes (audit trail)
        self.http_api.add_routes(
            path="/preferences/rejected",
            methods=[apigwv2.HttpMethod.GET],
            integration=integration,
            authorizer=authorizer,
        )

        # POST /generate
        self.http_api.add_routes(
            path="/generate",
            methods=[apigwv2.HttpMethod.POST],
            integration=integration,
            authorizer=authorizer,
        )

        # POST /edit (async - returns immediately)
        self.http_api.add_routes(
            path="/edit",
            methods=[apigwv2.HttpMethod.POST],
            integration=integration,
            authorizer=authorizer,
        )

        # GET /edit/{editId}/status - Poll for async edit completion
        self.http_api.add_routes(
            path="/edit/{editId}/status",
            methods=[apigwv2.HttpMethod.GET],
            integration=integration,
            authorizer=authorizer,
        )

        # GET /settings - Get user settings
        self.http_api.add_routes(
            path="/settings",
            methods=[apigwv2.HttpMethod.GET],
            integration=integration,
            authorizer=authorizer,
        )

        # PUT /settings - Update user settings
        self.http_api.add_routes(
            path="/settings",
            methods=[apigwv2.HttpMethod.PUT],
            integration=integration,
            authorizer=authorizer,
        )

        # POST /settings/validate-bucket - Validate MIMIC bucket access
        self.http_api.add_routes(
            path="/settings/validate-bucket",
            methods=[apigwv2.HttpMethod.POST],
            integration=integration,
            authorizer=authorizer,
        )

        # POST /settings/reset - Reset app to defaults
        self.http_api.add_routes(
            path="/settings/reset",
            methods=[apigwv2.HttpMethod.POST],
            integration=integration,
            authorizer=authorizer,
        )

        # Outputs
        CfnOutput(
            self,
            "ApiEndpoint",
            value=f"https://{self.http_api.http_api_id}.execute-api.{region}.amazonaws.com",
            description="HTTP API endpoint URL",
        )
        CfnOutput(
            self,
            "LambdaFunctionArn",
            value=self.proxy_function.function_arn,
        )
