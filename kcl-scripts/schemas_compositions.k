# Your composite resource (XR) spec schemas, one per kind, e.g. `schema MyKindSpec:`.

schema StaticSiteSpec:
    r"""
    A static website: a private S3 bucket behind a CloudFront distribution
    that reads it through an Origin Access Control. Served on the
    distribution's own *.cloudfront.net domain; no custom domain or
    certificate is composed.

    Attributes
    ----------
    bucketName : str, required
        Name of the S3 bucket to create. Must be a globally unique, valid
        S3 bucket name. Also used as the external-name for every composed
        resource that is keyed by bucket name.
    region : str, default is "us-east-1", optional
        AWS region the S3 bucket (and its related S3 resources) are created in.
        CloudFront itself is a global service and has no region.
    indexDocument : str, default is "index.html", optional
        Object CloudFront returns for requests to the root URL.
    priceClass : str, default is "PriceClass_100", optional
        CloudFront price class: PriceClass_100, PriceClass_200, or PriceClass_All.
    tags : {str:str}, default is Undefined, optional
        Tags applied to the bucket and the distribution.
    """

    bucketName: str
    region: str = "us-east-1"
    indexDocument: str = "index.html"
    priceClass: "PriceClass_100" | "PriceClass_200" | "PriceClass_All" = "PriceClass_100"
    tags?: {str:str}
    [str]: any

schema StaticSiteStatus:
    r"""
    Attributes
    ----------
    bucketArn : str, default is Undefined, optional
        ARN of the composed S3 bucket.
    bucketDomainName : str, default is Undefined, optional
        Regional domain name of the bucket, used as the CloudFront origin.
    distributionId : str, default is Undefined, optional
        ID of the composed CloudFront distribution.
    distributionArn : str, default is Undefined, optional
        ARN of the composed CloudFront distribution.
    distributionDomainName : str, default is Undefined, optional
        The distribution's *.cloudfront.net domain name: where the site is served.
    """

    bucketArn?: str
    bucketDomainName?: str
    distributionId?: str
    distributionArn?: str
    distributionDomainName?: str

# See staticSiteComposition.k for the StaticSite schema definition.
