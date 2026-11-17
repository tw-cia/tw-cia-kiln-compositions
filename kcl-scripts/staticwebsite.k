composeStaticWebsite = lambda oxr, ocds -> [{str:any}] {
    bucket = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "Bucket"
        metadata = {name = oxr.spec.bucketName, namespace = oxr.metadata.namespace}
        spec = {
            forProvider = {
                bucket = oxr.spec.bucketName
                region = "us-east-1"
            }
            providerConfigRef = {name = "aws-provider"}
        }
    }

    website = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketWebsiteConfiguration"
        metadata = {name = oxr.spec.bucketName + "-website", namespace = oxr.metadata.namespace}
        spec = {
            forProvider = {
                bucket = oxr.spec.bucketName
                indexDocument = [{suffix = "index.html"}]
                errorDocument = [{key = "404.html"}]
            }
            providerConfigRef = {name = "aws-provider"}
        }
    }

    versioning = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketVersioning"
        metadata = {name = oxr.spec.bucketName + "-versioning", namespace = oxr.metadata.namespace}
        spec = {
            forProvider = {
                bucket = oxr.spec.bucketName
                versioningConfiguration = [{status = "Enabled"}]
            }
            providerConfigRef = {name = "aws-provider"}
        }
    }

    oac = {
        apiVersion = "cloudfront.aws.upbound.io/v1beta1"
        kind = "OriginAccessControl"
        metadata = {name = oxr.spec.bucketName + "-oac", namespace = oxr.metadata.namespace}
        spec = {
            forProvider = {
                name = oxr.spec.bucketName + "-oac"
                originAccessControlOriginType = "s3"
                signingBehavior = "always"
                signingProtocol = "sigv4"
            }
            providerConfigRef = {name = "aws-provider"}
        }
    }

    distribution = {
        apiVersion = "cloudfront.aws.upbound.io/v1beta1"
        kind = "Distribution"
        metadata = {name = oxr.spec.bucketName + "-distribution", namespace = oxr.metadata.namespace}
        spec = {
            forProvider = {
                enabled = True
                isIpv6Enabled = True
                defaultRootObject = "index.html"
                origin = [{
                    domainName = oxr.spec.bucketName + ".s3.amazonaws.com"
                    originId = oxr.spec.bucketName
                }]
                defaultCacheBehavior = {
                    allowedMethods = ["GET", "HEAD"]
                    cachedMethods = ["GET", "HEAD"]
                    targetOriginId = oxr.spec.bucketName
                    viewerProtocolPolicy = "redirect-to-https"
                    compress = True
                    cachePolicyId = "4135ea3d-c35d-46eb-81d7-7ee126b62249"
                }
                priceClass = "PriceClass_100"
                restrictions = {
                    geoRestriction = {restrictionType = "none"}
                }
                viewerCertificate = {
                    cloudfrontDefaultCertificate = True
                }
                customErrorResponses = [{
                    errorCode = 404
                    responseCode = 404
                    responsePagePath = "/404.html"
                    errorCachingMinTtl = 300
                }]
            }
            providerConfigRef = {name = "aws-provider"}
        }
    }

    policy = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata = {name = oxr.spec.bucketName + "-policy", namespace = oxr.metadata.namespace}
        spec = {
            forProvider = {
                bucket = oxr.spec.bucketName
                policy = {
                    Version = "2012-10-17"
                    Statement = [{
                        Sid = "AllowCloudFront"
                        Effect = "Allow"
                        Principal = {Service = "cloudfront.amazonaws.com"}
                        Action = "s3:GetObject"
                        Resource = "arn:aws:s3:::" + oxr.spec.bucketName + "/*"
                    }]
                }
            }
            providerConfigRef = {name = "aws-provider"}
        }
    }

    [bucket, website, versioning, oac, distribution, policy]
}
