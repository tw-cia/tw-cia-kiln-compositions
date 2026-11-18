import json
import .schemas_compositions
import .schemas_providers

# A static website: a private S3 bucket read only by a CloudFront distribution
# (through an Origin Access Control), served on a custom domain with an ACM
# certificate, and an alias record that points the domain at the distribution.
#
# Staging. Each resource needs a value from an earlier one, so the chain is:
#   bucket + OAC -> certificate validated -> distribution -> bucket policy and alias record.

_resBucket = "bucket"
_resPublicAccessBlock = "publicAccessBlock"
_resOac = "originAccessControl"
_resCertificate = "certificate"
_resDistribution = "distribution"
_resBucketPolicy = "bucketPolicy"
_resAliasRecord = "aliasRecord"

_siteOriginId = "bucket-origin"
# The fixed hosted zone ID every CloudFront distribution alias uses.
_siteCloudfrontZoneId = "Z2FDTNDATAQYW2"
# The AWS managed "CachingOptimized" cache policy.
_siteCachePolicyId = "658327ea-f89d-4fab-a63d-7e88639e58f6"

_siteAnnotations = lambda name -> any {
    {"krm.kcl.dev/composition-resource-name" = name}
}

composeStaticWebsite = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.StaticWebsiteSpec = oxr.spec

    # Read every XR value into a local first: inside a dict that sets its own
    # spec.<x>, `spec.<y>` would refer to that dict's spec.
    _domainName = spec.domainName
    _zoneId = spec.hostedZoneId
    _region = spec.region
    _indexDocument = spec.indexDocument
    _bucketName = spec.bucketName or _domainName.replace(".", "-")
    _givenCertArn = spec.certificateArn

    _bucketObs = ocds[_resBucket]?.Resource?.status?.atProvider
    _bucketRegional = _bucketObs?.bucketRegionalDomainName
    _oacId = ocds[_resOac]?.Resource?.status?.atProvider?.id

    # The certificate is either given, or composed as a Certificate XR whose
    # status reports the ARN and whether it has validated.
    _certOcd = ocds[_resCertificate]?.Resource?.status
    _certArn = _givenCertArn or _certOcd?.arn
    _certReady = True if _givenCertArn else (_certOcd?.validated or False)

    _distObs = ocds[_resDistribution]?.Resource?.status?.atProvider
    _distArn = _distObs?.arn
    _distDomain = _distObs?.domainName

    _certificateXr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "Certificate"
        metadata.annotations = _siteAnnotations(_resCertificate)
        spec = schemas_compositions.CertificateSpec {
            domainName = _domainName
            hostedZoneId = _zoneId
            region = "us-east-1"
        }
    }

    _bucket = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "Bucket"
        metadata.annotations = {
            "crossplane.io/external-name" = _bucketName
            "krm.kcl.dev/composition-resource-name" = _resBucket
        }
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketSpecForProvider {
            region = _region
        }
    }

    _publicAccessBlock = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPublicAccessBlock"
        metadata.annotations = _siteAnnotations(_resPublicAccessBlock)
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProvider {
            bucket = _bucketName
            region = _region
            blockPublicAcls = True
            blockPublicPolicy = True
            ignorePublicAcls = True
            restrictPublicBuckets = True
        }
    }

    _oac = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "OriginAccessControl"
        metadata.annotations = _siteAnnotations(_resOac)
        spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlSpecForProvider {
            name = _bucketName
            description = "Read ${_domainName} bucket from CloudFront"
            originAccessControlOriginType = "s3"
            signingBehavior = "always"
            signingProtocol = "sigv4"
        }
    }

    _distributionReady = _bucketRegional and _oacId and _certReady and _certArn

    _distribution = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "Distribution"
        metadata.annotations = _siteAnnotations(_resDistribution)
        spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProvider {
            enabled = True
            aliases = [_domainName]
            comment = _domainName
            defaultRootObject = _indexDocument
            priceClass = "PriceClass_100"
            origin = [
                schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginItems0 {
                    domainName = _bucketRegional
                    originId = _siteOriginId
                    originAccessControlId = _oacId
                }
            ]
            defaultCacheBehavior = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehavior {
                targetOriginId = _siteOriginId
                viewerProtocolPolicy = "redirect-to-https"
                allowedMethods = ["GET", "HEAD"]
                cachedMethods = ["GET", "HEAD"]
                compress = True
                cachePolicyId = _siteCachePolicyId
            }
            restrictions = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderRestrictions {
                geoRestriction = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderRestrictionsGeoRestriction {
                    restrictionType = "none"
                }
            }
            viewerCertificate = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerCertificate {
                acmCertificateArn = _certArn
                sslSupportMethod = "sni-only"
                minimumProtocolVersion = "TLSv1.2_2021"
            }
        }
    } if _distributionReady else None

    # Only the distribution may read the bucket, and only this distribution.
    _bucketPolicy = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata.annotations = _siteAnnotations(_resBucketPolicy)
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketPolicySpecForProvider {
            bucket = _bucketName
            region = _region
            policy = json.encode({
                Version = "2012-10-17"
                Statement = [
                    {
                        Sid = "AllowCloudFrontServicePrincipalReadOnly"
                        Effect = "Allow"
                        Principal = {Service = "cloudfront.amazonaws.com"}
                        Action = "s3:GetObject"
                        Resource = "arn:aws:s3:::${_bucketName}/*"
                        Condition = {StringEquals = {"AWS:SourceArn" = _distArn}}
                    }
                ]
            })
        }
    } if _distArn else None

    _aliasRecord = {
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = _siteAnnotations(_resAliasRecord)
        spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
            zoneId = _zoneId
            name = _domainName
            $type = "A"
            alias = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProviderAlias {
                name = _distDomain
                zoneId = _siteCloudfrontZoneId
                evaluateTargetHealth = False
            }
        }
    } if _distDomain else None

    _siteXr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.StaticWebsiteStatus {
            url = "https://${_domainName}"
            distributionDomainName = _distDomain
            certificateArn = _certArn
        }
    } if _distDomain else None

    _certificateResources = [_certificateXr] if not _givenCertArn else []
    _distributionResources = [_distribution] if _distribution else []
    _policyResources = [_bucketPolicy] if _bucketPolicy else []
    _aliasResources = [_aliasRecord] if _aliasRecord else []
    _statusResources = [_siteXr] if _siteXr else []

    [_bucket, _publicAccessBlock, _oac] + _certificateResources + _distributionResources + _policyResources + _aliasResources + _statusResources
}
