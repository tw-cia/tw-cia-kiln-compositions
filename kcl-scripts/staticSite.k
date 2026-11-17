import json
import .schemas_compositions
import .schemas_providers

# AWS managed CloudFront cache policy "Managed-CachingOptimized". Stable
# across accounts/regions; there is no way to look this up at compose time.
_cachingOptimizedPolicyId = "658327ea-f89d-4fab-a63d-7e88639e58f6"

composeStaticSite = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.StaticSiteSpec = oxr.spec

    _bucketName = "bucket"
    _publicAccessBlockName = "bucket-public-access-block"
    _oacName = "origin-access-control"
    _distributionName = "distribution"
    _bucketPolicyName = "bucket-policy"

    _originId = "s3-origin"

    # Deterministic: S3 regional domain names are derived from bucket name
    # and region, not assigned by AWS, so this does not need observed state.
    _bucketDomainName = "${spec.bucketName}.s3.${spec.region}.amazonaws.com"

    _bucketForProvider: schemas_providers.S3AwsmUpboundIoV1beta1BucketSpecForProvider = {
        region = spec.region
        tags = spec.tags
    }

    _bucket = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "Bucket"
        metadata.annotations = {
            "crossplane.io/external-name" = spec.bucketName
            "krm.kcl.dev/composition-resource-name" = _bucketName
        }
        spec.forProvider = _bucketForProvider
    }

    _publicAccessBlockForProvider: schemas_providers.S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProvider = {
        bucket = spec.bucketName
        region = spec.region
        blockPublicAcls = True
        blockPublicPolicy = True
        ignorePublicAcls = True
        restrictPublicBuckets = True
    }

    _publicAccessBlock = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPublicAccessBlock"
        metadata.annotations = {
            "crossplane.io/external-name" = spec.bucketName
            "krm.kcl.dev/composition-resource-name" = _publicAccessBlockName
        }
        spec.forProvider = _publicAccessBlockForProvider
    }

    _oacForProvider: schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlSpecForProvider = {
        name = spec.bucketName
        description = "OAC for ${spec.bucketName}"
        originAccessControlOriginType = "s3"
        signingBehavior = "always"
        signingProtocol = "sigv4"
    }

    _oac = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "OriginAccessControl"
        metadata.annotations = {
            "crossplane.io/external-name" = spec.bucketName
            "krm.kcl.dev/composition-resource-name" = _oacName
        }
        spec.forProvider = _oacForProvider
    }

    # The distribution needs the OAC's AWS-assigned ID, which only exists
    # once the OAC has been observed.
    _observedOacAtProvider = ocds[_oacName]?.Resource?.status?.atProvider

    _oacStatus = lambda atProvider -> schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlStatusAtProvider {
        _status: schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlStatusAtProvider = atProvider
        _status
    }
    _observedOac = _oacStatus(_observedOacAtProvider) if _observedOacAtProvider else None
    _oacId = _observedOac?.id

    _distributionForProvider: schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProvider = {
        enabled = True
        isIpv6Enabled = True
        comment = "Static site ${spec.bucketName}"
        defaultRootObject = spec.indexDocument
        priceClass = spec.priceClass
        tags = spec.tags
        origin = [{
            originId = _originId
            domainName = _bucketDomainName
            originAccessControlId = _oacId
        }]
        defaultCacheBehavior = {
            targetOriginId = _originId
            viewerProtocolPolicy = "redirect-to-https"
            allowedMethods = ["GET", "HEAD"]
            cachedMethods = ["GET", "HEAD"]
            compress = True
            cachePolicyId = _cachingOptimizedPolicyId
        }
        restrictions.geoRestriction = {
            restrictionType = "none"
        }
        viewerCertificate.cloudfrontDefaultCertificate = True
    } if _oacId else None

    _distribution = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "Distribution"
        metadata.annotations = {
            "crossplane.io/external-name" = spec.bucketName
            "krm.kcl.dev/composition-resource-name" = _distributionName
        }
        spec.forProvider = _distributionForProvider
    } if _distributionForProvider else None

    # The bucket policy must name the distribution's ARN as the allowed
    # caller, which only exists once the distribution has been observed.
    _observedDistributionAtProvider = ocds[_distributionName]?.Resource?.status?.atProvider

    _distributionStatus = lambda atProvider -> schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProvider {
        _status: schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProvider = atProvider
        _status
    }
    _observedDistribution = _distributionStatus(_observedDistributionAtProvider) if _observedDistributionAtProvider else None
    _distributionId = _observedDistribution?.id
    _distributionArn = _observedDistribution?.arn
    _distributionDomainName = _observedDistribution?.domainName

    _bucketPolicyDocument = json.encode({
        Version = "2012-10-17"
        Statement = [{
            Sid = "AllowCloudFrontServicePrincipalReadOnly"
            Effect = "Allow"
            Principal = {Service = "cloudfront.amazonaws.com"}
            Action = "s3:GetObject"
            Resource = "arn:aws:s3:::${spec.bucketName}/*"
            Condition = {
                StringEquals = {"AWS:SourceArn" = _distributionArn}
            }
        }]
    })

    _bucketPolicyForProvider: schemas_providers.S3AwsmUpboundIoV1beta1BucketPolicySpecForProvider = {
        bucket = spec.bucketName
        region = spec.region
        policy = _bucketPolicyDocument
    } if _distributionArn else None

    _bucketPolicy = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata.annotations = {
            "crossplane.io/external-name" = spec.bucketName
            "krm.kcl.dev/composition-resource-name" = _bucketPolicyName
        }
        spec.forProvider = _bucketPolicyForProvider
    } if _bucketPolicyForProvider else None

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.StaticSiteStatus {
            bucketArn = "arn:aws:s3:::${spec.bucketName}"
            bucketDomainName = _bucketDomainName
            distributionId = _distributionId
            distributionArn = _distributionArn
            distributionDomainName = _distributionDomainName
        }
    } if _distributionId else None

    _baseResources = [_bucket, _publicAccessBlock, _oac]
    _withDistribution = _baseResources + ([_distribution] if _distribution else [])
    _withBucketPolicy = _withDistribution + ([_bucketPolicy] if _bucketPolicy else [])
    _withBucketPolicy + ([_xr] if _xr else [])
}
