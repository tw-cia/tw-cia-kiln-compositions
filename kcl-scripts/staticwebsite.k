import json
import .schemas_compositions
import .schemas_providers

staticWebsiteCertificateName = "certificate"
staticWebsiteBucketResourceName = "bucket"
staticWebsitePublicAccessBlockName = "bucket-public-access-block"
staticWebsiteOriginAccessControlName = "origin-access-control"
staticWebsiteDistributionName = "distribution"
staticWebsiteBucketPolicyName = "bucket-policy"
staticWebsiteAliasName = "website-a"
staticWebsiteAliasAaaaName = "website-aaaa"

# CloudFront's own hosted zone, used as the target of alias records.
staticWebsiteCloudFrontZoneId = "Z2FDTNDATAQYW2"
# AWS managed cache policy "CachingOptimized".
staticWebsiteCachePolicyId = "658327ea-f89d-4fab-a63d-7e88639e58f6"

# Reads observed resources through their imported status schemas, so a misspelt field is a compile error.
staticWebsiteBucketObserved = lambda atProvider -> schemas_providers.S3AwsmUpboundIoV1beta1BucketStatusAtProvider {
    _status: schemas_providers.S3AwsmUpboundIoV1beta1BucketStatusAtProvider = atProvider
    _status
}

staticWebsiteOacObserved = lambda atProvider -> schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlStatusAtProvider {
    _status: schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlStatusAtProvider = atProvider
    _status
}

staticWebsiteDistributionObserved = lambda atProvider -> schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProvider {
    _status: schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProvider = atProvider
    _status
}

# One alias record (A or AAAA) for the site's domain, pointing at the distribution.
staticWebsiteAliasRecord = lambda recordName, recordType, zoneId, domainName, distributionDomainName -> any {
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
                zoneId = staticWebsiteCloudFrontZoneId
                evaluateTargetHealth = False
            }
        }
    }
}

composeStaticWebsite = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.StaticWebsiteSpec = oxr.spec

    _domainName = spec.domainName
    _bucketName = spec.bucketName or _domainName.replace(".", "-")

    # CloudFront only reads certificates from us-east-1, so the certificate is always requested there.
    _certificate = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "TlsCertificate"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = staticWebsiteCertificateName}
        spec = schemas_compositions.TlsCertificateSpec {
            domainName = _domainName
            hostedZoneId = spec.hostedZoneId
            region = "us-east-1"
        }
    }

    _bucket = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "Bucket"
        metadata.annotations = {
            "crossplane.io/external-name" = _bucketName
            "krm.kcl.dev/composition-resource-name" = staticWebsiteBucketResourceName
        }
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketSpecForProvider {
            region = spec.bucketRegion
        }
    }

    _publicAccessBlock = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPublicAccessBlock"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = staticWebsitePublicAccessBlockName}
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProvider {
            bucket = _bucketName
            region = spec.bucketRegion
            blockPublicAcls = True
            blockPublicPolicy = True
            ignorePublicAcls = True
            restrictPublicBuckets = True
        }
    }

    _originAccessControl = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "OriginAccessControl"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = staticWebsiteOriginAccessControlName}
        spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlSpecForProvider {
            name = _bucketName
            description = "Read access to ${_domainName} from CloudFront"
            originAccessControlOriginType = "s3"
            signingBehavior = "always"
            signingProtocol = "sigv4"
        }
    }

    # Observed state. Each value is None until the resource reports it.
    _observedBucket = staticWebsiteBucketObserved(ocds[staticWebsiteBucketResourceName]?.Resource?.status?.atProvider) if ocds[staticWebsiteBucketResourceName]?.Resource?.status?.atProvider else None
    _observedOac = staticWebsiteOacObserved(ocds[staticWebsiteOriginAccessControlName]?.Resource?.status?.atProvider) if ocds[staticWebsiteOriginAccessControlName]?.Resource?.status?.atProvider else None
    _observedDistribution = staticWebsiteDistributionObserved(ocds[staticWebsiteDistributionName]?.Resource?.status?.atProvider) if ocds[staticWebsiteDistributionName]?.Resource?.status?.atProvider else None

    _bucketRegionalDomainName = _observedBucket?.bucketRegionalDomainName
    _oacId = _observedOac?.id

    # The child certificate reports validated only once ACM has issued it.
    _certificateStatus = ocds[staticWebsiteCertificateName]?.Resource?.status
    _certificateArn = _certificateStatus?.certificateArn if _certificateStatus?.validated else None

    _originId = "${_bucketName}-origin"
    _distributionReady = bool(_bucketRegionalDomainName) and bool(_oacId) and bool(_certificateArn)

    _distribution = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "Distribution"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = staticWebsiteDistributionName}
        spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProvider {
            enabled = True
            isIpv6Enabled = True
            comment = _domainName
            aliases = [_domainName]
            defaultRootObject = spec.indexDocument
            priceClass = "PriceClass_100"
            origin = [schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginItems0 {
                domainName = _bucketRegionalDomainName
                originId = _originId
                originAccessControlId = _oacId
            }]
            defaultCacheBehavior = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehavior {
                targetOriginId = _originId
                viewerProtocolPolicy = "redirect-to-https"
                allowedMethods = ["GET", "HEAD"]
                cachedMethods = ["GET", "HEAD"]
                cachePolicyId = staticWebsiteCachePolicyId
                compress = True
            }
            viewerCertificate = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerCertificate {
                acmCertificateArn = _certificateArn
                sslSupportMethod = "sni-only"
                minimumProtocolVersion = "TLSv1.2_2021"
            }
            restrictions = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderRestrictions {
                geoRestriction = {restrictionType = "none"}
            }
        }
    } if _distributionReady else None

    _distributionArn = _observedDistribution?.arn
    _distributionDomainName = _observedDistribution?.domainName
    _distributionZoneId = _observedDistribution?.hostedZoneId

    # The bucket only allows reads from this distribution, not from any CloudFront distribution.
    _bucketPolicy = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = staticWebsiteBucketPolicyName}
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketPolicySpecForProvider {
            bucket = _bucketName
            region = spec.bucketRegion
            policy = json.encode({
                Version = "2012-10-17"
                Statement = [
                    {
                        Sid = "AllowCloudFrontRead"
                        Effect = "Allow"
                        Principal = {Service = "cloudfront.amazonaws.com"}
                        Action = ["s3:GetObject"]
                        Resource = "arn:aws:s3:::${_bucketName}/*"
                        Condition = {StringEquals = {"AWS:SourceArn" = _distributionArn}}
                    }
                ]
            })
        }
    } if _distributionArn else None

    _aliasRecords = [
        staticWebsiteAliasRecord(staticWebsiteAliasName, "A", spec.hostedZoneId, _domainName, _distributionDomainName),
        staticWebsiteAliasRecord(staticWebsiteAliasAaaaName, "AAAA", spec.hostedZoneId, _domainName, _distributionDomainName)
    ] if _distributionDomainName else []

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.StaticWebsiteStatus {
            url = "https://${_domainName}"
            distributionDomainName = _distributionDomainName
        }
    } if _distributionDomainName else None

    [_certificate, _bucket, _publicAccessBlock, _originAccessControl] + ([_distribution] if _distribution else []) + ([_bucketPolicy] if _bucketPolicy else []) + _aliasRecords + ([_xr] if _xr else [])
}
