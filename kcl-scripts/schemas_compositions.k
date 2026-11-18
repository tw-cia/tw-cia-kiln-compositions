schema StaticWebsiteSpec:
    """A static website: a private S3 bucket served to the internet through CloudFront."""
    bucketName: str
    region: str = "us-east-1"
    indexDocument: str = "index.html"
    errorDocument?: str
    aliases?: [str]
    certificateArn?: str
    zoneId?: str
    priceClass: str = "PriceClass_100"
    tags?: {str:str}
    [str]: any

schema StaticWebsiteStatus:
    """What a consumer needs to reach the site."""
    distributionId?: str
    domainName?: str

schema DnsValidatedCertificateSpec:
    """An ACM certificate for one domain, validated by DNS records in a Route 53 hosted zone."""
    domainName: str
    zoneId: str
    region: str = "us-east-1"
    [str]: any

schema DnsValidatedCertificateStatus:
    """The issued certificate's ARN, reported once validation has completed."""
    certificateArn?: str

# Narrow Distribution shapes: only the fields the compose function sets or reads.
# Hand-written, so `kiln import` does not touch them. `kiln render` still checks
# every field we set against the real CRD.
schema StaticWebsiteOriginS3Config:
    originAccessIdentity: str

schema StaticWebsiteOrigin:
    originId: str
    domainName: str
    originAccessControlId: str
    s3OriginConfig: StaticWebsiteOriginS3Config

schema StaticWebsiteCacheBehavior:
    targetOriginId: str
    viewerProtocolPolicy: str
    allowedMethods: [str]
    cachedMethods: [str]
    cachePolicyId: str
    compress: bool

schema StaticWebsiteViewerCertificate:
    cloudfrontDefaultCertificate?: bool
    acmCertificateArn?: str
    sslSupportMethod?: str
    minimumProtocolVersion?: str

schema StaticWebsiteGeoRestriction:
    restrictionType: str

schema StaticWebsiteRestrictions:
    geoRestriction: StaticWebsiteGeoRestriction

schema StaticWebsiteCustomErrorResponse:
    errorCode: int
    responseCode: int
    responsePagePath: str
    errorCachingMinTtl: int

schema StaticWebsiteDistributionSpec:
    enabled: bool
    comment?: str
    priceClass: str
    defaultRootObject: str
    aliases?: [str]
    tags?: {str:str}
    origin: [StaticWebsiteOrigin]
    defaultCacheBehavior: StaticWebsiteCacheBehavior
    restrictions: StaticWebsiteRestrictions
    viewerCertificate: StaticWebsiteViewerCertificate
    customErrorResponse?: [StaticWebsiteCustomErrorResponse]

# Observed state stays open: a real atProvider has many more fields than we read.
schema StaticWebsiteDistributionStatus:
    arn?: str
    domainName?: str
    id?: str
    [str]: any
