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

# The application part of a web fleet: an auto-scaling group of web instances
# behind an application load balancer, and what they run. It does not say which
# network the fleet runs in, so an Environment can supply that.
# domain is the address the fleet serves HTTPS on. The fleet gets a certificate for
# it in its own region, and HTTP on port 80 redirects to HTTPS.
# userData is a plain-text bootstrap script (cloud-init or a shell script); the
# launch template receives it base64-encoded, as EC2 requires.
schema WebFleetAppSpec:
    name: str
    domain: DomainSpec
    imageId: str
    instanceType: str = "t3.micro"
    port: int = 80
    healthCheckPath: str = "/"
    minSize: int = 1
    maxSize: int = 2
    userData?: str
    scalingSchedules?: [ScalingScheduleSpec]

    check:
        minSize <= maxSize, "minSize must not be greater than maxSize"

# A web fleet placed in a network: WebFleetAppSpec plus the region and the network.
schema WebFleetSpec(WebFleetAppSpec):
    region: str = "us-east-1"
    network: NetworkSpec

# loadBalancerDnsName is the load balancer's own DNS name. A CdnDistribution's
# origin is the fleet's domain instead, which its certificate covers.
schema WebFleetStatus:
    loadBalancerArn?: str
    loadBalancerDnsName?: str

# An S3 bucket that the distribution serves, read through an origin access control.
# The bucket is private: only this distribution may read it. name must be unique
# across all of AWS.
schema S3OriginSpec:
    bucketName: str
    region: str = "us-east-1"

# An HTTPS origin that already exists: a name it serves HTTPS on, with a certificate
# for that name, such as a WebFleet's domain.
schema HttpsOriginSpec:
    domainName: str

# Where a distribution's content comes from: an S3 bucket it creates, or an HTTPS
# origin that already exists. Give exactly one. The fields do not overlap, so the
# closed schemas tell the two forms apart.
type OriginSpec = S3OriginSpec | HttpsOriginSpec

# A CloudFront distribution serving content from one origin at domain. The domain's
# certificate is created and validated by DNS, as a child TlsCertificate. Viewers are
# redirected to HTTPS.
schema CdnDistributionSpec:
    domain: DomainSpec
    origin: OriginSpec
    priceClass: str = "PriceClass_100"

schema CdnDistributionStatus:
    distributionArn?: str
    domainName?: str

# The VPC and subnets that resources run in. The subnets must already exist:
# public ones for internet-facing load balancers, private ones for instances and
# databases. Two or more in each tier, in different zones.
schema NetworkSpec:
    vpcId: str
    publicSubnetIds: [str]
    privateSubnetIds: [str]

    check:
        len(publicSubnetIds) >= 2, "publicSubnetIds needs at least two subnets, in different zones"
        len(privateSubnetIds) >= 2, "privateSubnetIds needs at least two subnets, in different zones"

# A VPC to create, from a CIDR block, across two or more zones. Not supported yet:
# an Environment that asks for one is rejected until the create path exists.
schema CreateVpcSpec:
    cidrBlock: str
    availabilityZones: [str]

    check:
        len(availabilityZones) >= 2, "availabilityZones needs at least two zones"

# An environment's network: a VPC and subnets that already exist (NetworkSpec), or
# a VPC to create (CreateVpcSpec). Exactly one of the two is given.
type EnvironmentNetwork = NetworkSpec | CreateVpcSpec

# An environment, such as prod, that holds a network and the applications that
# run in it. Each application's AWS names are prefixed with the environment name,
# so two environments can share a region. Application names must be unique.
schema EnvironmentSpec:
    name: str
    region: str = "us-east-1"
    network: EnvironmentNetwork
    webFleets?: [WebFleetAppSpec]

    check:
        len({w.name: True for w in webFleets or []}) == len(webFleets or []), "web fleet names must be unique within an environment"

# webFleetDnsNames maps each web fleet's application name to its load balancer's
# DNS name, for the fleets whose load balancer exists.
schema EnvironmentStatus:
    webFleetDnsNames?: {str:str}

# A domain a consumer serves something at: name is the domain (such as
# docs.example.com), and hostedZoneId is the Route 53 zone that holds it. The zone
# takes the certificate's validation records and the alias records to the service.
schema DomainSpec:
    name: str
    hostedZoneId: str

# The bucket that holds the site's files. name must be unique across all of AWS.
# Only the site's CloudFront distribution may read it.
schema StaticWebSiteBucketSpec:
    name: str
    region: str = "us-east-1"

# A static website: files in a private S3 bucket, served over HTTPS at the domain
# by a CloudFront distribution. The certificate is a TlsCertificate for the domain,
# validated by DNS in the domain's hosted zone.
schema StaticWebSiteSpec:
    domain: DomainSpec
    bucket: StaticWebSiteBucketSpec

# distribution holds what CloudFront reports once it has the distribution: its ARN,
# and the address it answers on (such as d111111abcdef8.cloudfront.net).
schema StaticWebSiteDistributionStatus:
    arn?: str
    domainName?: str

schema StaticWebSiteStatus:
    distribution?: StaticWebSiteDistributionStatus
