import .schemas_compositions
import .schemas_providers

cdnWebServiceOriginName = "origin"
cdnWebServiceViewerCertificateName = "viewer-certificate"
cdnWebServiceDistributionName = "distribution"
cdnWebServiceAliasName = "viewer-alias"
cdnWebServiceAliasAaaaName = "viewer-alias-aaaa"

# CloudFront's own hosted zone, the target of alias records.
cdnWebServiceCloudFrontZoneId = "Z2FDTNDATAQYW2"
# AWS managed "CachingDisabled": a web service's responses are not cached by default.
cdnWebServiceCachePolicyId = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
# AWS managed "AllViewerExceptHostHeader": forwards the viewer's request except the Host header.
cdnWebServiceOriginRequestPolicyId = "b689b0a8-53d0-40ab-baf2-68738e2966ac"

# Reads the observed distribution through its imported schema, so a misspelt field is a compile error.
cdnWebServiceDistributionObserved = lambda atProvider -> schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProvider {
    _status: schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProvider = atProvider
    _status
}

# One alias record (A or AAAA) for the public name, pointing at the distribution.
cdnWebServiceAliasRecord = lambda recordName, recordType, zoneId, domainName, distributionDomainName -> any {
    {
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = recordName}
        spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
            zoneId = zoneId
            name = domainName
            $type = recordType
            alias = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProviderAlias {
                name = distributionDomainName
                zoneId = cdnWebServiceCloudFrontZoneId
                evaluateTargetHealth = False
            }
        }
    }
}

composeCdnWebService = lambda oxr, ocds -> [any] {
    _cdnSpec: schemas_compositions.CdnWebServiceSpec = oxr.spec

    _name = oxr.metadata.name

    # The origin is a web service of its own, named after the XR. Its settings come from the nested origin block.
    _origin = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebService"
        metadata = {
            name = "${_name}-origin"
            annotations = {"krm.kcl.dev/composition-resource-name" = cdnWebServiceOriginName}
        }
        spec = schemas_compositions.WebServiceSpec {
            **_cdnSpec.origin
            domainName = _cdnSpec.originDomainName
            hostedZoneId = _cdnSpec.hostedZoneId
        }
    }

    # CloudFront reads viewer certificates only from us-east-1, so this one is always requested there.
    _viewerCertificate = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "TlsCertificate"
        metadata = {
            name = "${_name}-viewer-certificate"
            annotations = {"krm.kcl.dev/composition-resource-name" = cdnWebServiceViewerCertificateName}
        }
        spec = schemas_compositions.TlsCertificateSpec {
            domainName = _cdnSpec.domainName
            hostedZoneId = _cdnSpec.hostedZoneId
            region = "us-east-1"
        }
    }

    _viewerCertificateStatus = ocds[cdnWebServiceViewerCertificateName]?.Resource?.status
    _viewerCertificateArn = _viewerCertificateStatus?.certificateArn if _viewerCertificateStatus?.validated else None

    # The origin's name must resolve before CloudFront can reach it, so the distribution waits for the load balancer's DNS name.
    _originStatus = ocds[cdnWebServiceOriginName]?.Resource?.status
    _originDnsName = _originStatus?.loadBalancerDnsName

    _originId = "${_cdnSpec.originDomainName}-origin"

    _distribution = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "Distribution"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = cdnWebServiceDistributionName}
        spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProvider {
            enabled = True
            isIpv6Enabled = True
            comment = _cdnSpec.domainName
            aliases = [_cdnSpec.domainName]
            priceClass = "PriceClass_100"
            origin = [schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginItems0 {
                domainName = _cdnSpec.originDomainName
                originId = _originId
                customOriginConfig = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginItems0CustomOriginConfig {
                    httpPort = 80
                    httpsPort = 443
                    originProtocolPolicy = "https-only"
                    originSslProtocols = ["TLSv1.2"]
                }
            }]
            defaultCacheBehavior = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehavior {
                targetOriginId = _originId
                viewerProtocolPolicy = "redirect-to-https"
                allowedMethods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
                cachedMethods = ["GET", "HEAD"]
                cachePolicyId = cdnWebServiceCachePolicyId
                originRequestPolicyId = cdnWebServiceOriginRequestPolicyId
                compress = True
            }
            viewerCertificate = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerCertificate {
                acmCertificateArn = _viewerCertificateArn
                sslSupportMethod = "sni-only"
                minimumProtocolVersion = "TLSv1.2_2021"
            }
            restrictions = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderRestrictions {
                geoRestriction = {restrictionType = "none"}
            }
        }
    } if _viewerCertificateArn and _originDnsName else None

    _observedDistributionAtProvider = ocds[cdnWebServiceDistributionName]?.Resource?.status?.atProvider
    _observedDistribution = cdnWebServiceDistributionObserved(_observedDistributionAtProvider) if _observedDistributionAtProvider else None
    _distributionDomainName = _observedDistribution?.domainName
    _distributionZoneId = _observedDistribution?.hostedZoneId

    _aliasRecords = [
        cdnWebServiceAliasRecord(cdnWebServiceAliasName, "A", _cdnSpec.hostedZoneId, _cdnSpec.domainName, _distributionDomainName),
        cdnWebServiceAliasRecord(cdnWebServiceAliasAaaaName, "AAAA", _cdnSpec.hostedZoneId, _cdnSpec.domainName, _distributionDomainName)
    ] if _distributionDomainName else []

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.CdnWebServiceStatus {
            url = "https://${_cdnSpec.domainName}"
            distributionDomainName = _distributionDomainName
        }
    } if _distributionDomainName else None

    [_origin, _viewerCertificate] + ([_distribution] if _distribution else []) + _aliasRecords + ([_xr] if _xr else [])
}
