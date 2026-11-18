import json
import .schemas_compositions
import .schemas_providers

# CdnDistribution: a CloudFront distribution serving one origin at a domain.
#   HTTPS origin (a WebFleet's domain): CloudFront reaches it over HTTPS, caches
#     nothing and forwards everything, since the origin is a dynamic application.
#   S3 origin: this kind creates a private bucket and reaches it through an origin
#     access control. The bucket policy lets only this distribution read it, and
#     content is cached, with index.html as the default page.
# Staged by what is observed, as the cluster reports it:
#   cold start                     -> certificate, plus the bucket and access control for S3
#   bucket exists                  -> public access block (S3)
#   certificate validated, origin ready -> distribution
#   distribution ARN known         -> bucket policy (S3)
#   distribution domain name known -> alias record and status
composeCdnDistribution = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.CdnDistributionSpec = oxr.spec

    # Bind XR values to locals before building resource dicts (see kcl-primer).
    _domainName = spec.domain.name
    _hostedZoneId = spec.domain.hostedZoneId
    _priceClass = spec.priceClass

    # The origin is read untyped, so the branch can see which form was given.
    _origin = oxr.spec.origin
    _isS3 = "bucketName" in _origin
    _bucketName = _origin?.bucketName
    _bucketRegion = _origin?.region or "us-east-1"
    _originDomainName = _origin?.domainName

    _certificateName = "certificate"
    _bucketResourceName = "bucket"
    _publicAccessBlockName = "public-access-block"
    _oacName = "origin-access-control"
    _distributionName = "distribution"
    _bucketPolicyName = "bucket-policy"
    _aliasRecordName = "alias-record"
    _originId = "origin"

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

    # The certificate's status is read uncast: it also carries Crossplane's conditions.
    _certificateStatus = ocds[_certificateName]?.Resource?.status
    _certificateArn = _certificateStatus?.certificateArn
    _certificateValidated = _certificateStatus?.validated or False

    # --- S3 origin: resources exist only for a bucket origin ---------------------

    _bucket = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "Bucket"
        metadata.annotations = {
            "crossplane.io/external-name" = _bucketName
            "krm.kcl.dev/composition-resource-name" = _bucketResourceName
        }
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketSpecForProvider {
            region = _bucketRegion
        }
    } if _isS3 else None

    _bucketAtProvider = ocds[_bucketResourceName]?.Resource?.status?.atProvider
    _bucketArn = _bucketAtProvider?.arn
    _bucketRegionalDomainName = _bucketAtProvider?.bucketRegionalDomainName

    # Nothing in the bucket is public, whatever the bucket policy says.
    _publicAccessBlock = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPublicAccessBlock"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _publicAccessBlockName}
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProvider {
            bucket = _bucketName
            region = _bucketRegion
            blockPublicAcls = True
            blockPublicPolicy = True
            ignorePublicAcls = True
            restrictPublicBuckets = True
        }
    } if _isS3 else None

    _oac = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "OriginAccessControl"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _oacName}
        spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlSpecForProvider {
            name = _bucketName
            description = "Reads ${_bucketName} for the CloudFront distribution"
            originAccessControlOriginType = "s3"
            signingBehavior = "always"
            signingProtocol = "sigv4"
        }
    } if _isS3 else None

    _oacId = ocds[_oacName]?.Resource?.status?.atProvider?.id

    # --- distribution ---------------------------------------------------------------

    # An S3 origin needs its access control and bucket to exist; an HTTPS origin needs
    # only the certificate.
    _originReady = (_oacId and _bucketRegionalDomainName) if _isS3 else True
    _distributionReady = True if _certificateValidated and _originReady else False

    _distribution = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "Distribution"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _distributionName}
        spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProvider {
            enabled = True
            isIpv6Enabled = True
            priceClass = _priceClass
            aliases = [_domainName]
            restrictions = {geoRestriction = {restrictionType = "none"}}
            viewerCertificate = {
                acmCertificateArn = _certificateArn
                sslSupportMethod = "sni-only"
                minimumProtocolVersion = "TLSv1.2_2021"
            }
            origin = [{
                originId = _originId
                domainName = _bucketRegionalDomainName if _isS3 else _originDomainName
                **({"originAccessControlId" = _oacId} if _isS3 else {
                    customOriginConfig = {
                        httpsPort = 443
                        originProtocolPolicy = "https-only"
                        originSslProtocols = ["TLSv1.2"]
                    }
                })
            }]
            defaultCacheBehavior = {
                targetOriginId = _originId
                viewerProtocolPolicy = "redirect-to-https"
                allowedMethods = ["GET", "HEAD", "OPTIONS"] if _isS3 else ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
                cachedMethods = ["GET", "HEAD"]
                compress = True
                # AWS managed policies, fixed global IDs documented by AWS:
                # CachingOptimized for content, CachingDisabled for a dynamic origin.
                cachePolicyId = "658327ea-f89d-4fab-a63d-7e88639e58f6" if _isS3 else "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
                # AllViewer forwards every header, cookie and query string to a dynamic origin.
                **({} if _isS3 else {originRequestPolicyId = "216adef6-5c7f-47e4-b989-5492eafa07d3"})
            }
            **({"defaultRootObject" = "index.html"} if _isS3 else {})
        }
    } if _distributionReady else None

    _distributionAtProvider = ocds[_distributionName]?.Resource?.status?.atProvider
    _distributionArn = _distributionAtProvider?.arn
    _distributionDomainName = _distributionAtProvider?.domainName

    # Only this distribution may read the bucket, and only for requests it signs.
    _bucketPolicy = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _bucketPolicyName}
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketPolicySpecForProvider {
            bucket = _bucketName
            region = _bucketRegion
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
    } if _isS3 and _distributionArn else None

    # The domain points at the distribution. CloudFront's hosted zone ID is fixed.
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
        status = schemas_compositions.CdnDistributionStatus {distributionArn = _distributionArn, domainName = _distributionDomainName}
    } if _distributionDomainName else None

    _s3Buckets = [_bucket] if _isS3 else []
    _s3Oacs = [_oac] if _isS3 else []
    _s3PublicAccessBlocks = [_publicAccessBlock] if _isS3 and _bucketArn else []
    _distributions = [_distribution] if _distributionReady else []
    _s3BucketPolicies = [_bucketPolicy] if _isS3 and _distributionArn else []
    _aliasRecords = [_aliasRecord] if _distributionDomainName else []
    _xrs = [_xr] if _xr else []

    [_certificate] + _s3Buckets + _s3Oacs + _s3PublicAccessBlocks + _distributions + _s3BucketPolicies + _aliasRecords + _xrs
}
