# Your composite resource (XR) spec schemas, one per kind, e.g. `schema MyKindSpec:`.

# A DNS-validated ACM certificate. CloudFront only accepts certificates from us-east-1,
# which is the default.
schema TlsCertificateSpec:
    domainName: str
    hostedZoneId: str
    subjectAlternativeNames?: [str]
    region: str = "us-east-1"

schema TlsCertificateStatus:
    certificateArn?: str
    validated?: bool

# A static website served by CloudFront from a private S3 bucket, behind a custom domain.
schema StaticWebsiteSpec:
    domainName: str
    hostedZoneId: str
    bucketName?: str
    bucketRegion: str = "us-east-1"
    indexDocument: str = "index.html"

schema StaticWebsiteStatus:
    url?: str
    distributionDomainName?: str

# An auto-scaling group of identical instances, built from a launch template.
schema AutoScalingGroupSpec:
    region: str = "us-east-1"
    imageId: str
    instanceType: str = "t3.micro"
    subnetIds: [str]
    securityGroupIds?: [str]
    minSize: int = 1
    maxSize: int = 3
    desiredCapacity?: int
    # A plain-text boot script, run by each instance on launch. The function encodes it for AWS.
    userData?: str

    check:
        minSize <= maxSize, "minSize must not be greater than maxSize"
        desiredCapacity == Undefined or (desiredCapacity >= minSize and desiredCapacity <= maxSize), "desiredCapacity must be between minSize and maxSize"
        userData == Undefined or len(userData) <= 16384, "userData must be at most 16 KB"

schema AutoScalingGroupStatus:
    autoScalingGroupArn?: str

# An application load balancer serving HTTPS with an existing DNS-validated certificate.
schema LoadBalancerSpec:
    region: str = "us-east-1"
    vpcId: str
    subnetIds: [str]
    securityGroupIds: [str]
    # The ARN of a validated certificate, for example TlsCertificate status.certificateArn.
    certificateArn: str
    targetPort: int = 80
    # The name of an AutoScalingGroup XR whose instances join the target group.
    autoScalingGroupName?: str

    check:
        len(subnetIds) >= 2, "an application load balancer needs at least two subnets"

schema LoadBalancerStatus:
    dnsName?: str
    loadBalancerArn?: str
    # The load balancer's Route53 hosted zone, needed for an alias record.
    zoneId?: str

# A complete web service: a DNS-validated certificate, an auto-scaling group, a load balancer
# serving HTTPS with that certificate, and a DNS alias from the domain to the load balancer.
# Everything about a web service except its name: where it runs and what it serves.
# WebServiceSpec adds the name, and CdnWebServiceSpec nests one of these as its origin.
schema WebServiceSettings:
    region: str = "us-east-1"
    vpcId: str
    # The load balancer is internet-facing, so it takes public subnets.
    loadBalancerSubnetIds: [str]
    loadBalancerSecurityGroupIds: [str]
    # The instances take private subnets with a route out, so they can install software at boot.
    instanceSubnetIds: [str]
    instanceSecurityGroupIds: [str]
    imageId: str
    instanceType: str = "t3.micro"
    minSize: int = 1
    maxSize: int = 3
    desiredCapacity?: int
    targetPort: int = 80
    # A plain-text boot script for each instance. See AutoScalingGroupSpec.
    userData?: str

    check:
        len(loadBalancerSubnetIds) >= 2, "the load balancer needs at least two subnets"
        minSize <= maxSize, "minSize must not be greater than maxSize"
        desiredCapacity == Undefined or (desiredCapacity >= minSize and desiredCapacity <= maxSize), "desiredCapacity must be between minSize and maxSize"
        userData == Undefined or len(userData) <= 16384, "userData must be at most 16 KB"

schema WebServiceSpec(WebServiceSettings):
    domainName: str
    hostedZoneId: str

schema WebServiceStatus:
    url?: str
    loadBalancerDnsName?: str

# A web service served through CloudFront. The public name is a CloudFront alias with a us-east-1
# certificate. CloudFront reaches the origin, a WebService at originDomainName, over HTTPS.
schema CdnWebServiceSpec:
    domainName: str
    hostedZoneId: str
    originDomainName: str
    origin: WebServiceSettings

    check:
        domainName != originDomainName, "the public name and the origin name must differ"

schema CdnWebServiceStatus:
    url?: str
    distributionDomainName?: str
