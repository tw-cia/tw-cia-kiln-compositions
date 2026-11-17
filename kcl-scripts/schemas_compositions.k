# Your composite resource (XR) spec schemas, one per kind, e.g. `schema MyKindSpec:`.

schema StaticWebsiteSpec:
	bucketName: str
	domainName: str
	acmCertificateArn?: str
	indexDocument: str = "index.html"
	errorDocument: str = "error.html"
	enableLogging: bool = False
	logBucketName?: str
	enableCloudFrontCompression: bool = True
	cacheTTL: int = 3600

schema StaticWebsiteSpec:
    """Static website hosted on S3 with CloudFront distribution."""

    # S3 bucket name (must be globally unique)
    bucketName: str

    # Domain name for the website (optional, used for CloudFront aliases)
    domainName?: str

    # Whether to enable versioning on the S3 bucket
    versioningEnabled: bool = False

    # Tags to apply to resources
    tags?: {str: str}

    # Enable logging to S3
    enableLogging: bool = False

    # Regional endpoint configuration
    region: str = "us-east-1"

    # CloudFront settings
    cacheTtl: int = 3600  # seconds

    # Whether to enable S3 public access block
    blockPublicAccess: bool = True

    # Certificate ARN for HTTPS (optional, for custom domain)
    certificateArn?: str

    [str]: any
