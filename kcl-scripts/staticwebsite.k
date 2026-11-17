import schemas_providers as sp
import schemas_compositions as sc

# Compose a StaticWebsite from S3 bucket, public access block, and CloudFront distribution
composeStaticWebsite = lambda oxr, ocds {
    bucket_name = oxr.spec.bucketName
    region = oxr.spec.region
    tags = oxr.spec.tags or {}
    domain_name = oxr.spec.domainName or ""
    cache_ttl = oxr.spec.cacheTtl

    # S3 bucket base spec
    bucket_spec = {
        "bucket": bucket_name
        "region": region
    }

    # Add tags if provided
    if tags:
        bucket_spec["tags"] = tags

    # S3 bucket
    s3_bucket = {
        "apiVersion": "s3.aws.m.upbound.io/v1beta1"
        "kind": "Bucket"
        "metadata": {
            "name": bucket_name
        }
        "spec": {
            "forProvider": bucket_spec
        }
    }

    # Block public access on the bucket
    block_public_access = {
        "apiVersion": "s3.aws.m.upbound.io/v1beta1"
        "kind": "BucketPublicAccessBlock"
        "metadata": {
            "name": bucket_name
        }
        "spec": {
            "forProvider": {
                "bucketRef": {
                    "name": bucket_name
                }
                "blockPublicAcls": oxr.spec.blockPublicAccess
                "blockPublicPolicy": oxr.spec.blockPublicAccess
                "ignorePublicAcls": oxr.spec.blockPublicAccess
                "restrictPublicBuckets": oxr.spec.blockPublicAccess
            }
        }
    }

    # S3 website configuration
    website_config = {
        "apiVersion": "s3.aws.m.upbound.io/v1beta1"
        "kind": "BucketWebsiteConfiguration"
        "metadata": {
            "name": bucket_name
        }
        "spec": {
            "forProvider": {
                "bucketRef": {
                    "name": bucket_name
                }
                "indexDocument": [
                    {
                        "suffix": "index.html"
                    }
                ]
                "errorDocument": [
                    {
                        "key": "error.html"
                    }
                ]
            }
        }
    }

    # CloudFront Origin Access Control for secure S3 access
    oac = {
        "apiVersion": "cloudfront.aws.m.upbound.io/v1beta1"
        "kind": "OriginAccessControl"
        "metadata": {
            "name": "${bucket_name}-oac"
        }
        "spec": {
            "forProvider": {
                "name": "${bucket_name}-oac"
                "originAccessControlOriginType": "s3"
                "signingBehavior": "always"
                "signingProtocol": "sigv4"
            }
        }
    }

    # CloudFront distribution base spec
    dist_spec = {
        "enabled": True
        "isIpv6Enabled": True
        "comment": "Static website for ${bucket_name}"
        "origin": [
            {
                "domainName": "${bucket_name}.s3.${region}.amazonaws.com"
                "originId": "S3Origin"
                "s3OriginConfig": [
                    {
                        "originAccessIdentity": ""
                    }
                ]
            }
        ]
        "defaultCacheBehavior": [
            {
                "allowedMethods": ["GET", "HEAD"]
                "cachedMethods": ["GET", "HEAD"]
                "targetOriginId": "S3Origin"
                "viewerProtocolPolicy": "redirect-to-https"
                "minTtl": 0
                "defaultTtl": cache_ttl
                "maxTtl": cache_ttl * 2
                "forwardedValues": [
                    {
                        "queryString": False
                        "cookies": [
                            {
                                "forward": "none"
                            }
                        ]
                    }
                ]
            }
        ]
        "restrictions": [
            {
                "geoRestriction": [
                    {
                        "restrictionType": "none"
                    }
                ]
            }
        ]
        "viewerCertificate": [
            {
                "cloudfrontDefaultCertificate": True
            }
        ]
    }

    # Add aliases if domain name provided
    if domain_name:
        dist_spec["aliases"] = [domain_name]

    # CloudFront distribution
    distribution = {
        "apiVersion": "cloudfront.aws.m.upbound.io/v1beta1"
        "kind": "Distribution"
        "metadata": {
            "name": bucket_name
        }
        "spec": {
            "forProvider": dist_spec
        }
    }

    # Return the composed resources
    {
        "bucket": s3_bucket
        "blockPublicAccess": block_public_access
        "websiteConfig": website_config
        "originAccessControl": oac
        "distribution": distribution
    }
}