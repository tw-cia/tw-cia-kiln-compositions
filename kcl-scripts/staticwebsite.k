import json
import .schemas_compositions
import .schemas_providers

# StaticWebSite: files in a private S3 bucket, served over HTTPS at domainName by a
# CloudFront distribution. The distribution reaches the bucket through an origin
# access control, and the bucket policy lets only that distribution read it.
# Staged by what is observed:
#   cold start                        -> certificate, bucket, access control
#   bucket exists                     -> public access block
#   access control, bucket and a validated certificate -> distribution
#   distribution ARN known            -> bucket policy
#   distribution domain name known    -> alias record and status
composeStaticWebSite = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.StaticWebSiteSpec = oxr.spec

    # Bind XR values to locals before building resource dicts (see kcl-primer).
    _domainName = spec.domainName
    _hostedZoneId = spec.hostedZoneId
    _bucketName = spec.bucketName
    _region = spec.region

    _certificateName = "certificate"
    _bucketResourceName = "bucket"
    _publicAccessBlockName = "public-access-block"
    _oacName = "origin-access-control"
    _distributionName = "distribution"
    _bucketPolicyName = "bucket-policy"
    _aliasRecordName = "alias-record"
    _originId = "s3-origin"

    # The certificate is a child XR: a TlsCertificate for the domain. CloudFront only
    # accepts certificates from us-east-1.
    _certificate = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "TlsCertificate"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _certificateName}
        spec = schemas_compositions.TlsCertificateSpec {
            domainName = _domainName
            hostedZoneId = _hostedZoneId
            region = "us-east-1"
        }
    }

    _bucketForProvider: schemas_providers.S3AwsmUpboundIoV1beta1BucketSpecForProvider = {
        region = _region
    }
    _bucket = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "Bucket"
        metadata.annotations = {
            "crossplane.io/external-name" = _bucketName
            "krm.kcl.dev/composition-resource-name" = _bucketResourceName
        }
        spec.forProvider = _bucketForProvider
    }

    # Nothing in the bucket is public, whatever the bucket policy says.
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
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _publicAccessBlockName}
        spec.forProvider = _publicAccessBlockForProvider
    }

    # The origin access control lets CloudFront sign its requests to the bucket.
    _oacForProvider: schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlSpecForProvider = {
        name = _bucketName
        description = "Reads ${_bucketName} for the CloudFront distribution"
        originAccessControlOriginType = "s3"
        signingBehavior = "always"
        signingProtocol = "sigv4"
    }
    _oac = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "OriginAccessControl"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _oacName}
        spec.forProvider = _oacForProvider
    }

    _bucketAtProvider = ocds[_bucketResourceName]?.Resource?.status?.atProvider
    _bucketArn = _bucketAtProvider?.arn
    _bucketRegionalDomainName = _bucketAtProvider?.bucketRegionalDomainName

    _oacId = ocds[_oacName]?.Resource?.status?.atProvider?.id

    # The certificate's status is read uncast: it also carries Crossplane's conditions.
    _certificateStatus = ocds[_certificateName]?.Resource?.status
    _certificateArn = _certificateStatus?.certificateArn
    _certificateValidated = _certificateStatus?.validated or False

    _distributionReady = True if _oacId and _bucketRegionalDomainName and _certificateValidated else False

    _distributionForProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProvider {
        enabled = True
        isIpv6Enabled = True
        priceClass = "PriceClass_100"
        defaultRootObject = "index.html"
        aliases = [_domainName]
        restrictions = {geoRestriction = {restrictionType = "none"}}
        viewerCertificate = {
            acmCertificateArn = _certificateArn
            sslSupportMethod = "sni-only"
            minimumProtocolVersion = "TLSv1.2_2021"
        }
        origin = [{
            originId = _originId
            domainName = _bucketRegionalDomainName
            originAccessControlId = _oacId
        }]
        defaultCacheBehavior = {
            targetOriginId = _originId
            viewerProtocolPolicy = "redirect-to-https"
            allowedMethods = ["GET", "HEAD", "OPTIONS"]
            cachedMethods = ["GET", "HEAD"]
            compress = True
            # AWS managed "CachingOptimized" policy: fixed, global ID documented by AWS.
            cachePolicyId = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        }
    } if _distributionReady else None

    _distribution = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "Distribution"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _distributionName}
        spec.forProvider = _distributionForProvider
    } if _distributionReady else None

    _distributionAtProvider = ocds[_distributionName]?.Resource?.status?.atProvider
    _distributionArn = _distributionAtProvider?.arn
    _distributionDomainName = _distributionAtProvider?.domainName

    # Only the distribution may read the bucket, and only for requests it signs.
    _bucketPolicy = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _bucketPolicyName}
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketPolicySpecForProvider {
            bucket = _bucketName
            region = _region
            policy = json.encode({
                Version = "2012-10-17"
                Statement = [{
                    Sid = "AllowCloudFrontServicePrincipalReadOnly"
                    Effect = "Allow"
                    Principal = {Service = "cloudfront.amazonaws.com"}
                    Action = ["s3:GetObject"]
                    Resource = "arn:aws:s3:::${_bucketName}/*"
                    Condition = {StringEquals = {"AWS:SourceArn" = _distributionArn}}
                }]
            })
        }
    } if _distributionArn else None

    # The domain name points at the distribution. CloudFront's hosted zone ID is fixed.
    _aliasRecord = {
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _aliasRecordName}
        spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
            zoneId = _hostedZoneId
            name = _domainName
            $type = "A"
            allowOverwrite = True
            alias = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProviderAlias {
                name = _distributionDomainName
                zoneId = "Z2FDTNDATAQYW2"
                evaluateTargetHealth = False
            }
        }
    } if _distributionDomainName else None

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.StaticWebSiteStatus {distributionDomainName = _distributionDomainName}
    } if _distributionDomainName else None

    _publicAccessBlocks = [_publicAccessBlock] if _bucketArn else []
    _distributions = [_distribution] if _distributionReady else []
    _bucketPolicies = [_bucketPolicy] if _distributionArn else []
    _aliasRecords = [_aliasRecord] if _distributionDomainName else []
    _xrs = [_xr] if _xr else []

    [_certificate, _bucket, _oac] + _publicAccessBlocks + _distributions + _bucketPolicies + _aliasRecords + _xrs
}
