schema DnsValidatedCertificateSpec:
    r"""
    Consumer-facing spec for a DnsValidatedCertificate composite resource: an
    ACM certificate validated by DNS records in an existing Route53 zone.
    """
    domainName: str
    region: str
    zoneId: str
    subjectAlternativeNames?: [str]
    tags?: {str:str}
    [str]: any

schema DnsValidatedCertificateStatus:
    r"""
    Reported only once ACM has validated the certificate.
    """
    certificateArn?: str

schema StaticWebsiteSpec:
    r"""
    Consumer-facing spec for a StaticWebsite composite resource: a private S3
    bucket served over HTTPS on a custom domain through CloudFront, with an
    ACM certificate issued for that domain.
    """
    bucketName: str
    domainName: str
    region: str
    zoneId: str
    tags?: {str:str}
    [str]: any

schema StaticWebsiteStatus:
    r"""
    Reported once the CloudFront distribution exists.
    """
    cloudFrontDomainName?: str
