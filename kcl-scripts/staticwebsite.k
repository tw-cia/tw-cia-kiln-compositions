import json
import .schemas_compositions
import .schemas_providers

_staticWebsiteBucketRes = "bucket"
_staticWebsitePublicAccessBlockRes = "public-access-block"
_staticWebsiteOacRes = "origin-access-control"
_staticWebsiteDistributionRes = "distribution"
_staticWebsiteBucketPolicyRes = "bucket-policy"

_staticWebsiteS3OriginId = "s3-origin"
# AWS managed cache policy "CachingOptimized"
_staticWebsiteCachePolicyId = "658327ea-f89d-4fab-a63d-7e88639e58f6"

# Typed reads of observed state. Each is only called when the atProvider exists.
_staticWebsiteBucketStatus = lambda atProvider -> schemas_providers.S3AwsmUpboundIoV1beta1BucketStatusAtProvider {
    _status: schemas_providers.S3AwsmUpboundIoV1beta1BucketStatusAtProvider = atProvider
    _status
}
_staticWebsiteOacStatus = lambda atProvider -> schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlStatusAtProvider {
    _status: schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlStatusAtProvider = atProvider
    _status
}
_staticWebsiteDistributionStatus = lambda atProvider -> schemas_compositions.StaticWebsiteDistributionStatus {
    _status: schemas_compositions.StaticWebsiteDistributionStatus = atProvider
    _status
}

_staticWebsiteCustomErrors = lambda errorDocument -> [any] {
    [{errorCode = code, responseCode = 404, responsePagePath = "/${errorDocument}", errorCachingMinTtl = 10} for code in [403, 404]]
}

_staticWebsiteDistributionForProvider = lambda specIn, domainName, oacId -> schemas_compositions.StaticWebsiteDistributionSpec {
    _viewerCertificate = {
        acmCertificateArn = specIn.certificateArn
        sslSupportMethod = "sni-only"
        minimumProtocolVersion = "TLSv1.2_2021"
    } if specIn.certificateArn else {cloudfrontDefaultCertificate = True}
    _forProvider: schemas_compositions.StaticWebsiteDistributionSpec = {
        enabled = True
        comment = specIn.bucketName
        priceClass = specIn.priceClass
        defaultRootObject = specIn.indexDocument
        aliases = specIn.aliases
        tags = specIn.tags
        origin = [
            {
                originId = _staticWebsiteS3OriginId
                domainName = domainName
                originAccessControlId = oacId
                s3OriginConfig = {originAccessIdentity = ""}
            }
        ]
        defaultCacheBehavior = {
            targetOriginId = _staticWebsiteS3OriginId
            viewerProtocolPolicy = "redirect-to-https"
            allowedMethods = ["GET", "HEAD"]
            cachedMethods = ["GET", "HEAD"]
            cachePolicyId = _staticWebsiteCachePolicyId
            compress = True
        }
        restrictions = {geoRestriction = {restrictionType = "none"}}
        viewerCertificate = _viewerCertificate
        customErrorResponse = _staticWebsiteCustomErrors(specIn.errorDocument) if specIn.errorDocument else None
    }
    _forProvider
}

_staticWebsiteBucketPolicyForProvider = lambda bucketName, bucketRegion, distributionArn -> schemas_providers.S3AwsmUpboundIoV1beta1BucketPolicySpecForProvider {
    _forProvider: schemas_providers.S3AwsmUpboundIoV1beta1BucketPolicySpecForProvider = {
        bucket = bucketName
        region = bucketRegion
        policy = json.encode({
            Version = "2012-10-17"
            Statement = [
                {
                    Sid = "AllowCloudFrontRead"
                    Effect = "Allow"
                    Principal = {Service = "cloudfront.amazonaws.com"}
                    Action = "s3:GetObject"
                    Resource = "arn:aws:s3:::${bucketName}/*"
                    Condition = {StringEquals = {"AWS:SourceArn" = distributionArn}}
                }
            ]
        })
    }
    _forProvider
}

_staticWebsiteCloudFrontZoneId = "Z2FDTNDATAQYW2"

_staticWebsiteAliasRecordForProvider = lambda zoneId, domain, distributionDomain -> schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
    _forProvider: schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider = {
        zoneId = zoneId
        name = domain
        $type = "A"
        alias = {
            name = distributionDomain
            zoneId = _staticWebsiteCloudFrontZoneId
            evaluateTargetHealth = False
        }
    }
    _forProvider
}

composeStaticWebsite = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.StaticWebsiteSpec = oxr.spec
    _bucketName = spec.bucketName
    _region = spec.region

    _observedBucketAtProvider = ocds[_staticWebsiteBucketRes]?.Resource?.status?.atProvider
    _observedBucket = _staticWebsiteBucketStatus(_observedBucketAtProvider) if _observedBucketAtProvider else None
    _bucketRegionalDomainName = _observedBucket?.bucketRegionalDomainName

    _observedOacAtProvider = ocds[_staticWebsiteOacRes]?.Resource?.status?.atProvider
    _observedOac = _staticWebsiteOacStatus(_observedOacAtProvider) if _observedOacAtProvider else None
    _oacId = _observedOac?.id

    _observedDistributionAtProvider = ocds[_staticWebsiteDistributionRes]?.Resource?.status?.atProvider
    _observedDistribution = _staticWebsiteDistributionStatus(_observedDistributionAtProvider) if _observedDistributionAtProvider else None
    _distributionArn = _observedDistribution?.arn
    _distributionDomainName = _observedDistribution?.domainName
    _distributionId = _observedDistribution?.id

    _bucketForProvider: schemas_providers.S3AwsmUpboundIoV1beta1BucketSpecForProvider = {
        region = _region
        tags = spec.tags
    }
    _bucket = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "Bucket"
        metadata.annotations = {
            "crossplane.io/external-name" = _bucketName
            "krm.kcl.dev/composition-resource-name" = _staticWebsiteBucketRes
        }
        spec.forProvider = _bucketForProvider
    }

    _publicAccessBlockForProvider: schemas_providers.S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProvider = {
        bucket = _bucketName
        region = _region
        blockPublicAcls = True
        blockPublicPolicy = True
        ignorePublicAcls = True
        restrictPublicBuckets = True
    }
    _publicAccessBlock = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPublicAccessBlock"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _staticWebsitePublicAccessBlockRes
        }
        spec.forProvider = _publicAccessBlockForProvider
    }

    _oacForProvider: schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlSpecForProvider = {
        name = "${_bucketName}-oac"
        description = "Origin access for the ${_bucketName} static website"
        originAccessControlOriginType = "s3"
        signingBehavior = "always"
        signingProtocol = "sigv4"
    }
    _oac = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "OriginAccessControl"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _staticWebsiteOacRes
        }
        spec.forProvider = _oacForProvider
    }

    _distributionForProvider = _staticWebsiteDistributionForProvider(spec, _bucketRegionalDomainName, _oacId) if _bucketRegionalDomainName and _oacId else None
    _distribution = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "Distribution"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _staticWebsiteDistributionRes
        }
        spec.forProvider = _distributionForProvider
    } if _distributionForProvider else None

    _bucketPolicy = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _staticWebsiteBucketPolicyRes
        }
        spec.forProvider = _staticWebsiteBucketPolicyForProvider(_bucketName, _region, _distributionArn)
    } if _distributionArn else None

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.StaticWebsiteStatus {
            distributionId = _distributionId
            domainName = _distributionDomainName
        }
    } if _distributionDomainName else None

    _aliasRecords = [{
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = "alias-record-${i}"
        }
        spec.forProvider = _staticWebsiteAliasRecordForProvider(spec.zoneId, domain, _distributionDomainName)
    } for i, domain in (spec.aliases or [])] if spec.zoneId and _distributionDomainName else []

    [_bucket, _publicAccessBlock, _oac] + ([_distribution] if _distribution else []) + ([_bucketPolicy] if _bucketPolicy else []) + _aliasRecords + ([_xr] if _xr else [])
}
