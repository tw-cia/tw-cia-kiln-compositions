"""
Static Website Composition - S3 + CloudFront

This composition manages a static website hosted on S3 with CloudFront CDN distribution.
It creates:
- S3 bucket for website content
- CloudFront distribution
- Origin access identity for secure S3 access
- Bucket policy to restrict access to CloudFront only
"""

schema StaticSiteSpec:
    """Specification for a static website hosted on S3 with CloudFront."""

    # Basic site information
    siteName: str
    """Name of the website (used for resource naming)."""

    domainName: str
    """Primary domain name for the CloudFront distribution."""

    alternateNames: [str] = []
    """Additional domain names (aliases) for the CloudFront distribution."""

    # S3 configuration
    bucketName: str = ""
    """S3 bucket name. If empty, will use siteName with suffix."""

    enableVersioning: bool = False
    """Enable S3 bucket versioning."""

    enableLogging: bool = True
    """Enable S3 access logging."""

    loggingBucket: str = ""
    """Bucket for S3 access logs. If empty, will create a separate logging bucket."""

    # CloudFront configuration
    defaultRootObject: str = "index.html"
    """Default root object for the distribution."""

    errorResponses: {str: str} = {
        "403": "index.html",
        "404": "404.html",
    }
    """Error responses mapping (HTTP status code -> file path)."""

    viewerProtocolPolicy: str = "redirect-to-https"
    """Viewer protocol policy: allow-all, https-only, or redirect-to-https."""

    cachePolicyId: str = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    """CloudFront cache policy ID. Default: Managed-CachingOptimized."""

    originRequestPolicyId: str = "216adef5-5c7f-47e4-b989-5492eafa07d3"
    """CloudFront origin request policy ID. Default: Managed-CORS-S3Origin."""

    # Tags
    tags: {str: str} = {}
    """Labels for the resources."""


schema StaticSiteStatus:
    """Status of a static website composition."""

    observedGeneration: int = 0
    """Observed generation."""

    s3BucketName: str = ""
    """Name of the created S3 bucket."""

    cloudFrontDomainName: str = ""
    """CloudFront domain name (*.cloudfront.net)."""

    cloudFrontDistributionId: str = ""
    """CloudFront distribution ID."""

    ready: bool = False
    """Whether all resources are ready."""


schema StaticSite:
    """A managed static website on S3 with CloudFront."""

    metadata: {str: str} = {}
    spec: StaticSiteSpec
    status: StaticSiteStatus = {}
