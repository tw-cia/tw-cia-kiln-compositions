# Your composite resource (XR) spec schemas, one per kind, e.g. `schema MyKindSpec:`.

# A public TLS certificate for one domain, issued by ACM and validated through
# DNS records in a Route 53 hosted zone. CloudFront only accepts certificates
# from us-east-1, so keep the default region when the certificate is for a
# CdnDistribution.
schema TlsCertificateSpec:
    domainName: str
    hostedZoneId: str
    region: str = "us-east-1"

# certificateArn is set once ACM has created the certificate. validated is true
# once ACM reports the DNS validation as complete.
schema TlsCertificateStatus:
    certificateArn?: str
    validated?: bool

# One change to the fleet's size, that AWS applies on a cron schedule. recurrence
# is a Unix cron expression, for example "0 8 * * MON-FRI" for 08:00 on weekdays,
# and timeZone is an IANA name such as "Europe/London" (UTC when it is left out).
# Set at least one of minSize, maxSize or desiredCapacity. A value left out is
# not changed at that time.
schema ScalingScheduleSpec:
    name: str
    recurrence: str
    timeZone?: str
    minSize?: int
    maxSize?: int
    desiredCapacity?: int

    check:
        minSize is not Undefined or maxSize is not Undefined or desiredCapacity is not Undefined, "a scaling schedule must set minSize, maxSize or desiredCapacity"

# An auto-scaling group of web instances behind an application load balancer.
# subnetIds holds the load balancer's subnets, which must be public for an
# internet-facing load balancer. instanceSubnetIds holds the instances' subnets;
# it defaults to subnetIds, and private subnets with a NAT route are better for
# instances, so the bootstrap script can reach the internet.
# userData is a plain-text bootstrap script (cloud-init or a shell script); the
# launch template receives it base64-encoded, as EC2 requires.
schema WebFleetSpec:
    name: str
    region: str = "us-east-1"
    vpcId: str
    subnetIds: [str]
    instanceSubnetIds?: [str]
    imageId: str
    instanceType: str = "t3.micro"
    port: int = 80
    healthCheckPath: str = "/"
    minSize: int = 1
    maxSize: int = 2
    userData?: str
    scalingSchedules?: [ScalingScheduleSpec]

    check:
        len(subnetIds) >= 2, "subnetIds needs at least two subnets, in different zones, for the load balancer"
        minSize <= maxSize, "minSize must not be greater than maxSize"

# loadBalancerDnsName is what a CdnDistribution uses as its origin.
schema WebFleetStatus:
    loadBalancerArn?: str
    loadBalancerDnsName?: str

# hostedZoneId is the Route 53 zone that gets an alias record for each alias,
# pointing it at the distribution. Without it, the aliases are only set on
# CloudFront and nothing resolves them.
# A CloudFront distribution in front of an origin (such as the load balancer of
# a WebFleet). The origin is reached over HTTP, and viewers are redirected to
# HTTPS. Every request is forwarded to the origin, with caching disabled, since
# the origin is a dynamic application.
schema CdnDistributionSpec:
    originDomainName: str
    aliases?: [str]
    certificateArn?: str
    hostedZoneId?: str
    priceClass: str = "PriceClass_100"

    check:
        not aliases or certificateArn, "aliases need certificateArn, an ACM certificate in us-east-1"

schema CdnDistributionStatus:
    distributionArn?: str
    domainName?: str
