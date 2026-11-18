import .schemas_compositions
import .schemas_providers

# CdnDistribution: a CloudFront distribution in front of an origin (such as the
# load balancer of a WebFleet). The origin is reached over HTTP. Viewers are
# redirected to HTTPS, and every request is forwarded to the origin with
# caching disabled, since the origin is a dynamic application.
composeCdnDistribution = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.CdnDistributionSpec = oxr.spec

    # Bind XR values to locals before building resource dicts (see kcl-primer).
    _originDomainName = spec.originDomainName
    _priceClass = spec.priceClass
    _aliases = spec.aliases
    _certificateArn = spec.certificateArn

    _distributionName = "distribution"
    _originId = "alb-origin"

    # Use the ACM certificate only when there are aliases to serve; otherwise
    # CloudFront's own certificate for its domain name is used.
    _viewerCertificate = {
        acmCertificateArn = _certificateArn
        sslSupportMethod = "sni-only"
        minimumProtocolVersion = "TLSv1.2_2021"
    } if _aliases and _certificateArn else {cloudfrontDefaultCertificate = True}

    _distributionForProvider: schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProvider = {
        enabled = True
        isIpv6Enabled = True
        priceClass = _priceClass
        restrictions = {geoRestriction = {restrictionType = "none"}}
        viewerCertificate = _viewerCertificate
        origin = [{
            originId = _originId
            domainName = _originDomainName
            customOriginConfig = {
                httpPort = 80
                httpsPort = 443
                originProtocolPolicy = "http-only"
                originSslProtocols = ["TLSv1.2"]
            }
        }]
        defaultCacheBehavior = {
            targetOriginId = _originId
            viewerProtocolPolicy = "redirect-to-https"
            allowedMethods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
            cachedMethods = ["GET", "HEAD"]
            compress = True
            # AWS managed "CachingDisabled" and "AllViewer" policies: fixed,
            # global IDs documented by AWS, not account-specific.
            cachePolicyId = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
            originRequestPolicyId = "216adef6-5c7f-47e4-b989-5492eafa07d3"
        }
        **({"aliases" = _aliases} if _aliases else {})
    }

    _distribution = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "Distribution"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _distributionName}
        spec.forProvider = _distributionForProvider
    }

    _atProvider = ocds[_distributionName]?.Resource?.status?.atProvider
    _domainName = _atProvider?.domainName
    _distributionArn = _atProvider?.arn

    # One alias record per alias, pointing the name at the distribution. The
    # zone ID for CloudFront distributions is fixed (AWS documents it), not per account.
    _hostedZoneId = spec.hostedZoneId
    _aliasRecords = [{
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = "alias-record-${i}"}
        spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
            zoneId = _hostedZoneId
            name = alias
            $type = "A"
            allowOverwrite = True
            alias = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProviderAlias {
                name = _domainName
                zoneId = "Z2FDTNDATAQYW2"
                evaluateTargetHealth = False
            }
        }
    } for i, alias in _aliases] if _aliases and _hostedZoneId and _domainName else []

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.CdnDistributionStatus {distributionArn = _distributionArn, domainName = _domainName}
    } if _domainName else None

    [_distribution] + _aliasRecords + ([_xr] if _xr else [])
}
