import crossplane as xp
from schemas_compositions import S3StaticWebsiteSpec

schema S3StaticWebsite:
    """Composition for S3 static website with CloudFront distribution"""

    spec: S3StaticWebsiteSpec

# Main composition logic
mixin S3StaticWebsite:
    _base_name: str = spec.siteName.lower().replace("_", "-")
    _tags: {str: str} = spec.tags or {}

    # S3 Bucket for website content
    resources.s3_bucket = xp.Resource {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "Bucket"
        metadata = {
            name = "${_base_name}-bucket"
            labels = {
                "website" = _base_name
            }
        }
        spec = {
            forProvider = {
                region = "us-east-1"
                bucket = "${_base_name}-${xp.randhex(8)}"
                tags = _tags
            }
        }
    }

    # S3 Bucket Versioning
    if spec.enableVersioning:
        resources.s3_versioning = xp.Resource {
            apiVersion = "s3.aws.upbound.io/v1beta1"
            kind = "BucketVersioning"
            metadata = {
                name = "${_base_name}-versioning"
            }
            spec = {
                forProvider = {
                    bucket = resources.s3_bucket.metadata.name
                    versioningConfiguration = [{
                        status = "Enabled"
                    }]
                }
            }
        }

    # S3 Bucket Public Access Block
    resources.s3_public_block = xp.Resource {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketPublicAccessBlock"
        metadata = {
            name = "${_base_name}-public-block"
        }
        spec = {
            forProvider = {
                bucket = resources.s3_bucket.metadata.name
                blockPublicAcls = spec.blockPublicAcl
                blockPublicPolicy = spec.blockPublicPolicy
                ignorePublicAcls = True
                restrictPublicBuckets = True
            }
        }
    }

    # S3 Bucket Website Configuration
    resources.s3_website = xp.Resource {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketWebsiteConfiguration"
        metadata = {
            name = "${_base_name}-website-config"
        }
        spec = {
            forProvider = {
                bucket = resources.s3_bucket.metadata.name
                indexDocument = [{
                    suffix = spec.indexDocument
                }]
            } | {errorDocument = [{key = spec.errorDocument}]} if spec.errorDocument else {}
        }
    }

    # CloudFront Origin Access Identity (OAI)
    resources.cf_oai = xp.Resource {
        apiVersion = "cloudfront.aws.upbound.io/v1beta1"
        kind = "OriginAccessIdentity"
        metadata = {
            name = "${_base_name}-oai"
        }
        spec = {
            forProvider = {
                comment = "OAI for ${_base_name} static website"
            }
        }
    }

    # S3 Bucket Policy for CloudFront OAI
    resources.s3_policy = xp.Resource {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata = {
            name = "${_base_name}-policy"
        }
        spec = {
            forProvider = {
                bucket = resources.s3_bucket.metadata.name
                policy = xp.to_json_string({
                    "Version": "2012-10-17"
                    "Statement": [{
                        "Effect": "Allow"
                        "Principal": {
                            "AWS": f"arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity {resources.cf_oai.status.atProvider.id}"
                        }
                        "Action": "s3:GetObject"
                        "Resource": f"{resources.s3_bucket.metadata.name}/*"
                    }]
                })
            }
        }
    }

    # CloudFront Distribution
    resources.cloudfront_dist = xp.Resource {
        apiVersion = "cloudfront.aws.upbound.io/v1beta1"
        kind = "Distribution"
        metadata = {
            name = "${_base_name}-distribution"
            labels = {
                "website" = _base_name
            }
        }
        spec = {
            forProvider = {
                enabled = True
                isIpv6Enabled = True
                priceClass = spec.priceClass
                defaultRootObject = spec.indexDocument

                origins = [{
                    domainName = "${resources.s3_bucket.status.atProvider.bucketRegionalDomainName}"
                    originId = "S3Origin"
                    s3OriginConfig = [{
                        originAccessIdentity = "origin-access-identity/cloudfront/${resources.cf_oai.status.atProvider.id}"
                    }]
                }]

                defaultCacheBehavior = [{
                    allowedMethods = ["GET", "HEAD", "OPTIONS"]
                    cachedMethods = ["GET", "HEAD"]
                    targetOriginId = "S3Origin"
                    compress = spec.enableCompressionAutomatically

                    forwardedValues = [{
                        queryString = False
                        cookies = [{
                            forward = "none"
                        }]
                    }]

                    viewerProtocolPolicy = spec.certificateArn ? "redirect-to-https" : "allow-all"
                    minTtl = 0
                    defaultTtl = spec.cacheTtlSeconds
                    maxTtl = spec.cacheTtlSeconds * 2
                }]

                restrictions = [{
                    geoRestriction = [{
                        restrictionType = "none"
                    }]
                }]

                viewerCertificate = spec.certificateArn ? [{
                    acmCertificateArn = spec.certificateArn
                    sslSupportMethod = "sni-only"
                    minimumProtocolVersion = "TLSv1.2_2021"
                }] : [{
                    cloudfrontDefaultCertificate = True
                }]

                tags = _tags
            }
        }
    }

    # Optional: Route53 Record
    if spec.domainName:
        resources.route53_record = xp.Resource {
            apiVersion = "route53.aws.upbound.io/v1beta1"
            kind = "Record"
            metadata = {
                name = "${_base_name}-route53"
            }
            spec = {
                forProvider = {
                    name = spec.domainName
                    type = "A"
                    zoneId = ""  # This would need to be injected
                    alias = [{
                        name = resources.cloudfront_dist.status.atProvider.domainName
                        zoneId = "Z2FDTNDATAQYW2"  # CloudFront zone ID
                        evaluateTargetHealth = False
                    }]
                }
            }
        }
