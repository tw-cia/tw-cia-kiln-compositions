import json

import .schemas_compositions
import .schemas_providers

composeStaticWebsite = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.StaticWebsiteSpec = oxr.spec

    # XR values, bound to locals first: inside a dict that sets its own
    # spec.forProvider, `spec.<x>` would read that dict's spec instead.
    _siteBucket = spec.bucketName
    _siteRegion = spec.region
    _siteDomain = spec.domainName
    _siteZone = spec.zoneId
    _siteTags = spec.tags

    _nBucket = "bucket"
    _nOac = "origin-access-control"
    _nCertificate = "certificate"
    _nDistribution = "distribution"
    _nBucketPolicy = "bucket-policy"
    _nAlias = "alias-record"

    # The bucket stays private. CloudFront reads it through origin access
    # control, and the bucket policy below admits only this distribution.
    _bucket = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "Bucket"
        metadata.annotations = {
            "crossplane.io/external-name" = _siteBucket
            "krm.kcl.dev/composition-resource-name" = _nBucket
        }
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketSpecForProvider {
            region = _siteRegion
            tags = _siteTags
        }
    }

    _oac = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "OriginAccessControl"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _nOac
        }
        spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlSpecForProvider {
            name = "${_siteBucket}-oac"
            description = "Origin access for ${_siteDomain}"
            originAccessControlOriginType = "s3"
            signingBehavior = "always"
            signingProtocol = "sigv4"
        }
    }

    # CloudFront only accepts ACM certificates issued in us-east-1, regardless
    # of which region the rest of this site's resources live in.
    _certificate = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "DnsValidatedCertificate"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _nCertificate
        }
        spec = schemas_compositions.DnsValidatedCertificateSpec {
            domainName = _siteDomain
            region = "us-east-1"
            zoneId = _siteZone
        }
    }

    _certificateArn = ocds[_nCertificate]?.Resource?.status?.certificateArn
    _oacId = ocds[_nOac]?.Resource?.status?.atProvider?.id
    _distributionArn = ocds[_nDistribution]?.Resource?.status?.atProvider?.arn
    _distributionDomain = ocds[_nDistribution]?.Resource?.status?.atProvider?.domainName

    _distribution = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "Distribution"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _nDistribution
        }
        spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProvider {
            enabled = True
            aliases = [_siteDomain]
            defaultRootObject = "index.html"
            origin = [{
                domainName = "${_siteBucket}.s3.${_siteRegion}.amazonaws.com"
                originId = "s3-origin"
                originAccessControlId = _oacId
                s3OriginConfig = {originAccessIdentity = ""}
            }]
            defaultCacheBehavior = {
                targetOriginId = "s3-origin"
                viewerProtocolPolicy = "redirect-to-https"
                allowedMethods = ["GET", "HEAD"]
                cachedMethods = ["GET", "HEAD"]
                # AWS managed policy "CachingOptimized".
                cachePolicyId = "658327ea-f89d-4fab-a63d-7e88639e58f6"
                compress = True
            }
            restrictions = {geoRestriction = {restrictionType = "none"}}
            viewerCertificate = {
                acmCertificateArn = _certificateArn
                sslSupportMethod = "sni-only"
                minimumProtocolVersion = "TLSv1.2_2021"
            }
            tags = _siteTags
        }
    } if _certificateArn and _oacId else None

    # Allows reads only from this distribution, so the bucket cannot be
    # reached by any other CloudFront distribution.
    _bucketPolicy = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _nBucketPolicy
        }
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketPolicySpecForProvider {
            region = _siteRegion
            bucket = _siteBucket
            policy = json.encode({
                Version = "2012-10-17"
                Statement = [{
                    Sid = "AllowCloudFrontServicePrincipalReadOnly"
                    Effect = "Allow"
                    Principal = {Service = "cloudfront.amazonaws.com"}
                    Action = "s3:GetObject"
                    Resource = "arn:aws:s3:::${_siteBucket}/*"
                    Condition = {StringEquals = {"AWS:SourceArn" = _distributionArn}}
                }]
            })
        }
    } if _distributionArn else None

    _aliasRecord = {
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _nAlias
        }
        spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
            zoneId = _siteZone
            name = _siteDomain
            $type = "A"
            # CloudFront's fixed hosted zone ID, used by every alias to a distribution.
            alias = {name = _distributionDomain, zoneId = "Z2FDTNDATAQYW2", evaluateTargetHealth = False}
        }
    } if _distributionDomain else None

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.StaticWebsiteStatus {cloudFrontDomainName = _distributionDomain}
    } if _distributionDomain else None

    [_bucket, _oac, _certificate] + ([_distribution] if _distribution else []) + ([_bucketPolicy] if _bucketPolicy else []) + ([_aliasRecord] if _aliasRecord else []) + ([_xr] if _xr else [])
}
