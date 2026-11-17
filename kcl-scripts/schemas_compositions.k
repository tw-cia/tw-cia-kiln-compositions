# Composite resource (XR) spec schemas

schema S3StaticWebsiteSpec:
    """Static website hosted on S3 with CloudFront distribution"""

    # Basic site configuration
    siteName: str
    """Name of the website (used as S3 bucket prefix)"""

    domainName?: str
    """Domain name for Route53 record (optional)"""

    certificateArn?: str
    """ACM certificate ARN for HTTPS (optional)"""

    # S3 configuration
    indexDocument: str = "index.html"
    """Main index document"""

    errorDocument?: str
    """Error document (e.g., 404.html)"""

    enableVersioning: bool = False
    """Enable S3 versioning"""

    # CloudFront configuration
    cacheTtlSeconds: int = 3600
    """Default cache TTL for objects"""

    priceClass: str = "PriceClass_100"
    """CloudFront price class (100, 200, or All)"""

    enableCompressionAutomatically: bool = True
    """Auto-compress objects with CloudFront"""

    # Security
    blockPublicAcl: bool = True
    """Block public ACL on S3 bucket"""

    blockPublicPolicy: bool = True
    """Block public bucket policies"""

    # Additional tags
    tags?: {str: str}
    """Optional tags for all resources"""
