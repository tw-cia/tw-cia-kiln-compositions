# Your composite resource (XR) spec schemas, one per kind, e.g. `schema MyKindSpec:`.

schema StaticWebsiteSpec:
    domainName: str
    bucketName: str
    region?: str
    indexDocument?: str
    errorDocument?: str
    tags?: {str: str}
    zoneId?: str
    providerConfigName?: str
    [str]: any

schema StaticWebsiteStatus:
    bucketName?: str
    domainName?: str
    distributionDomainName?: str
    certificateArn?: str
    url?: str
