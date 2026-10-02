"""
CDK Stack for deploying Flutter web frontend to CloudFront + S3
"""

from aws_cdk import (
    Stack,
    RemovalPolicy,
    CfnOutput,
    Duration,
    aws_s3 as s3,
    aws_s3_deployment as s3_deployment,
    aws_cloudfront as cloudfront,
    aws_cloudfront_origins as origins,
)
from constructs import Construct


class WebStack(Stack):
    """Stack for deploying Flutter web frontend to CloudFront + S3"""

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # S3 bucket for hosting the Flutter web app
        # Block all public access - CloudFront will use OAC
        website_bucket = s3.Bucket(
            self,
            "WebsiteBucket",
            removal_policy=RemovalPolicy.DESTROY,
            auto_delete_objects=True,
            block_public_access=s3.BlockPublicAccess.BLOCK_ALL,
            encryption=s3.BucketEncryption.S3_MANAGED,
        )

        # CloudFront Origin Access Control for S3
        oac = cloudfront.S3OriginAccessControl(
            self,
            "WebsiteOAC",
            description="OAC for Flutter web app bucket",
        )

        # CloudFront distribution
        distribution = cloudfront.Distribution(
            self,
            "WebsiteDistribution",
            default_behavior=cloudfront.BehaviorOptions(
                origin=origins.S3BucketOrigin.with_origin_access_control(
                    website_bucket,
                    origin_access_control=oac,
                ),
                viewer_protocol_policy=cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
                cache_policy=cloudfront.CachePolicy.CACHING_OPTIMIZED,
                compress=True,
            ),
            default_root_object="index.html",
            # Handle SPA routing - return index.html for 404s
            error_responses=[
                cloudfront.ErrorResponse(
                    http_status=404,
                    response_http_status=200,
                    response_page_path="/index.html",
                    ttl=Duration.seconds(0),
                ),
                cloudfront.ErrorResponse(
                    http_status=403,
                    response_http_status=200,
                    response_page_path="/index.html",
                    ttl=Duration.seconds(0),
                ),
            ],
            price_class=cloudfront.PriceClass.PRICE_CLASS_100,
        )

        # Deploy the Flutter web build to S3
        # Note: Run `flutter build web --release` before deploying
        s3_deployment.BucketDeployment(
            self,
            "DeployWebsite",
            sources=[
                s3_deployment.Source.asset("../frontend-web/build/web")
            ],
            destination_bucket=website_bucket,
            distribution=distribution,
            distribution_paths=["/*"],
            # Flutter web builds are large (~33MB) - need more memory
            memory_limit=512,
        )

        # Outputs
        CfnOutput(
            self,
            "WebsiteUrl",
            value=f"https://{distribution.distribution_domain_name}",
            description="CloudFront URL for the Flutter web app",
        )

        CfnOutput(
            self,
            "BucketName",
            value=website_bucket.bucket_name,
            description="S3 bucket name for the Flutter web app",
        )

        CfnOutput(
            self,
            "DistributionId",
            value=distribution.distribution_id,
            description="CloudFront distribution ID",
        )
