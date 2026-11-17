"""StaticWebsite composition - manages S3 bucket with CloudFront distribution."""

def compose_static_website(xr):
    spec = xr.spec
    metadata = xr.metadata
    name = metadata.name

    bucket_name = spec.bucketName
    domain_name = spec.domainName
    index_document = spec.get("indexDocument", "index.html")
    error_document = spec.get("errorDocument", "404.html")
    enable_caching = spec.get("enableCaching", True)
    cache_ttl = spec.get("cacheTTL", 3600)
    tags = spec.get("tags", {})

    namespace = metadata.get("namespace", "default")
    resources = []

    # S3 Bucket resource
    bucket = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "Bucket"
        metadata = {
            name = bucket_name
            namespace = namespace
        }
        spec = {
            forProvider = {
                bucket = bucket_name
                region = "us-east-1"
                tags = tags
            }
            providerConfigRef = {
                name = "aws-provider"
            }
        }
    }
    resources.append(bucket)

    # S3 Bucket Website Configuration
    website_config = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketWebsiteConfiguration"
        metadata = {
            name = "${bucket_name}-website"
            namespace = namespace
        }
        spec = {
            forProvider = {
                bucket = bucket_name
                indexDocument = [{suffix = index_document}]
                errorDocument = [{key = error_document}]
            }
            providerConfigRef = {
                name = "aws-provider"
            }
        }
    }
    resources.append(website_config)

    # S3 Bucket Versioning
    versioning = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketVersioning"
        metadata = {
            name = "${bucket_name}-versioning"
            namespace = namespace
        }
        spec = {
            forProvider = {
                bucket = bucket_name
                versioningConfiguration = [{status = "Enabled"}]
            }
            providerConfigRef = {
                name = "aws-provider"
            }
        }
    }
    resources.append(versioning)

    # Origin Access Control for CloudFront to S3
    oac = {
        apiVersion = "cloudfront.aws.upbound.io/v1beta1"
        kind = "OriginAccessControl"
        metadata = {
            name = "${bucket_name}-oac"
            namespace = namespace
        }
        spec = {
            forProvider = {
                name = "${bucket_name}-oac"
                originAccessControlOriginType = "s3"
                signingBehavior = "always"
                signingProtocol = "sigv4"
            }
            providerConfigRef = {
                name = "aws-provider"
            }
        }
    }
    resources.append(oac)

    # Determine cache policy based on enableCaching flag
    cache_policy_id = if enable_caching then "4135ea3d-c35d-46eb-81d7-7ee126b62249" else "658327ea-f89d-4fab-a63d-7e88639e58f6"

    # CloudFront Distribution
    distribution = {
        apiVersion = "cloudfront.aws.upbound.io/v1beta1"
        kind = "Distribution"
        metadata = {
            name = "${bucket_name}-distribution"
            namespace = namespace
        }
        spec = {
            forProvider = {
                enabled = True
                isIpv6Enabled = True
                defaultRootObject = index_document
                origin = [{
                    domainName = "${bucket_name}.s3.amazonaws.com"
                    originId = bucket_name
                }]
                defaultCacheBehavior = [{
                    allowedMethods = ["GET", "HEAD"]
                    cachedMethods = ["GET", "HEAD"]
                    targetOriginId = bucket_name
                    viewerProtocolPolicy = "redirect-to-https"
                    compress = True
                    cachePolicyId = cache_policy_id
                }]
                priceClass = "PriceClass_100"
                restrictions = [{
                    geoRestriction = [{restrictionType = "none"}]
                }]
                viewerCertificate = [{
                    cloudfrontDefaultCertificate = True
                }]
                customErrorResponses = [{
                    errorCode = 404
                    responseCode = 404
                    responsePagePath = "/${error_document}"
                    errorCachingMinTtl = 300
                }]
                tags = tags
            }
            providerConfigRef = {
                name = "aws-provider"
            }
        }
    }
    resources.append(distribution)

    # S3 Bucket Policy to allow CloudFront access
    bucket_policy = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata = {
            name = "${bucket_name}-policy"
            namespace = namespace
        }
        spec = {
            forProvider = {
                bucket = bucket_name
                policy = {
                    Version = "2012-10-17"
                    Statement = [{
                        Sid = "AllowCloudFront"
                        Effect = "Allow"
                        Principal = {Service = "cloudfront.amazonaws.com"}
                        Action = "s3:GetObject"
                        Resource = "arn:aws:s3:::${bucket_name}/*"
                    }]
                }
            }
            providerConfigRef = {
                name = "aws-provider"
            }
        }
    }
    resources.append(bucket_policy)

    return resources
