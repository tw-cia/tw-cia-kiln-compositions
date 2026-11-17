"""
Static Site Composition Implementation

Renders Crossplane resources for S3 bucket + CloudFront distribution.
"""

import base64

_site = option("observedCompositeResource") or {}
_siteSpec = _site.get("spec") or {}
_siteName = _siteSpec.get("siteName") or "unknown"
_domainName = _siteSpec.get("domainName") or ""
_alternateNames = _siteSpec.get("alternateNames") or []
_bucketName = _siteSpec.get("bucketName") or "${_siteName}-website-$(date +%s)"
_enableVersioning = _siteSpec.get("enableVersioning") or False
_enableLogging = _siteSpec.get("enableLogging") or True
_loggingBucket = _siteSpec.get("loggingBucket") or "${_siteName}-logs"
_defaultRootObject = _siteSpec.get("defaultRootObject") or "index.html"
_errorResponses = _siteSpec.get("errorResponses") or {"403": "index.html", "404": "404.html"}
_viewerProtocolPolicy = _siteSpec.get("viewerProtocolPolicy") or "redirect-to-https"
_cachePolicyId = _siteSpec.get("cachePolicyId") or "658327ea-f89d-4fab-a63d-7e88639e58f6"
_originRequestPolicyId = _siteSpec.get("originRequestPolicyId") or "216adef5-5c7f-47e4-b989-5492eafa07d3"
_tags = _siteSpec.get("tags") or {}
_region = "us-east-1"

# Build tags with defaults
_resourceTags = {**_tags, "managed-by": "kiln", "site": _siteName}

# S3 Bucket for website content
_items = [
    {
        apiVersion: "s3.aws.upbound.io/v1beta1"
        kind: "Bucket"
        metadata: {
            name: "site-bucket-${_siteName}"
            namespace: _site.metadata.namespace
        }
        spec: {
            forProvider: {
                bucket: _bucketName
                region: _region
                tags: _resourceTags
            }
            providerConfigRef: {
                name: "default"
            }
        }
    }
]

# S3 Bucket Versioning (if enabled)
if _enableVersioning:
    _items.append({
        apiVersion: "s3.aws.upbound.io/v1beta1"
        kind: "BucketVersioning"
        metadata: {
            name: "site-versioning-${_siteName}"
            namespace: _site.metadata.namespace
        }
        spec: {
            forProvider: {
                bucket: _bucketName
                versioningConfiguration: {
                    status: "Enabled"
                }
            }
            providerConfigRef: {
                name: "default"
            }
        }
    })

# S3 Bucket ACL
_items.append({
    apiVersion: "s3.aws.upbound.io/v1beta1"
    kind: "BucketACL"
    metadata: {
        name: "site-acl-${_siteName}"
        namespace: _site.metadata.namespace
    }
    spec: {
        forProvider: {
            bucket: _bucketName
            acl: "private"
        }
        providerConfigRef: {
            name: "default"
        }
    }
})

# S3 Bucket Public Access Block
_items.append({
    apiVersion: "s3.aws.upbound.io/v1beta1"
    kind: "BucketPublicAccessBlock"
    metadata: {
        name: "site-pab-${_siteName}"
        namespace: _site.metadata.namespace
    }
    spec: {
        forProvider: {
            bucket: _bucketName
            blockPublicAcls: True
            blockPublicPolicy: True
            ignorePublicAcls: True
            restrictPublicBuckets: True
        }
        providerConfigRef: {
            name: "default"
        }
    }
})

# CloudFront Origin Access Identity (OAI)
_items.append({
    apiVersion: "cloudfront.aws.upbound.io/v1beta1"
    kind: "OriginAccessIdentity"
    metadata: {
        name: "site-oai-${_siteName}"
        namespace: _site.metadata.namespace
    }
    spec: {
        forProvider: {
            comment: "OAI for ${_siteName} website"
        }
        providerConfigRef: {
            name: "default"
        }
    }
})

# S3 Bucket Policy for CloudFront OAI access
_items.append({
    apiVersion: "s3.aws.upbound.io/v1beta1"
    kind: "BucketPolicy"
    metadata: {
        name: "site-policy-${_siteName}"
        namespace: _site.metadata.namespace
    }
    spec: {
        forProvider: {
            bucket: _bucketName
            policy: {
                Version: "2012-10-17"
                Statement: [
                    {
                        Sid: "CloudFrontAccess"
                        Effect: "Allow"
                        Principal: {
                            AWS: "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity"
                        }
                        Action: "s3:GetObject"
                        Resource: "arn:aws:s3:::${_bucketName}/*"
                    }
                ]
            }
        }
        providerConfigRef: {
            name: "default"
        }
    }
})

# CloudFront Distribution
_errorResponseConfigs = []
for statusCode, filePath in _errorResponses:
    _errorResponseConfigs.append({
        errorCode: int(statusCode)
        responsePagePath: "/${filePath}"
        responseCode: statusCode
        errorCachingMinTtl: 300
    })

_items.append({
    apiVersion: "cloudfront.aws.upbound.io/v1beta1"
    kind: "Distribution"
    metadata: {
        name: "site-dist-${_siteName}"
        namespace: _site.metadata.namespace
    }
    spec: {
        forProvider: {
            enabled: True
            defaultRootObject: _defaultRootObject
            defaultCacheBehavior: {
                allowedMethods: ["GET", "HEAD", "OPTIONS"]
                cachedMethods: ["GET", "HEAD"]
                targetOriginId: "s3Origin"
                viewerProtocolPolicy: _viewerProtocolPolicy
                cachePolicyId: _cachePolicyId
                originRequestPolicyId: _originRequestPolicyId
                compress: True
            }
            origin: [
                {
                    domainName: "${_bucketName}.s3.${_region}.amazonaws.com"
                    originId: "s3Origin"
                    s3OriginConfig: [
                        {
                            originAccessIdentity: "origin-access-identity/cloudfront/example"
                        }
                    ]
                }
            ]
            restrictions: {
                geoRestriction: [
                    {
                        restrictionType: "none"
                    }
                ]
            }
            viewerCertificate: [
                {
                    cloudfrontDefaultCertificate: True
                }
            ]
            tags: _resourceTags
        }
        providerConfigRef: {
            name: "default"
        }
    }
})

# Update the composite resource status
_site.status = {
    s3BucketName: _bucketName
    cloudFrontDomainName: "d*.cloudfront.net"
    ready: True
}

items = _items
