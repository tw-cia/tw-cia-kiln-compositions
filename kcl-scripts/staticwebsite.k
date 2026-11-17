import json
import .schemas_compositions
import .schemas_providers

# A static site: an S3 bucket, a CloudFront distribution reading it through an
# Origin Access Control, and the bucket policy that trusts that distribution.
#
# With a `zoneId` the site also gets its custom domain: a DNS-validated ACM
# certificate, and a Route53 alias record pointing at the distribution.
#
# Every resource comes from an `.aws.m.upbound.io` (namespaced) API group, because
# a namespaced XR may only compose namespaced resources.
composeStaticWebsite = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.StaticWebsiteSpec = oxr.spec

    _region = spec.region or "us-east-1"
    _bucketName = spec.bucketName
    _tags = spec.tags or {}
    _indexDocument = spec.indexDocument or "index.html"
    _errorDocument = spec.errorDocument or "404.html"
    _providerConfigRef = {kind = "ClusterProviderConfig", name = spec.providerConfigName or "pod-identity"}
    _customDomain = bool(spec.zoneId)

    _oacName = "${_bucketName}-oac"
    _certName = "${_bucketName}-cert"

    # --- Bucket and Origin Access Control ---

    # The namespaced Bucket has no `bucket` field; the name comes from the
    # external-name annotation.
    _bucket = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "Bucket"
        metadata.name = _bucketName
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = "bucket"
            "crossplane.io/external-name" = _bucketName
        }
        spec.providerConfigRef = _providerConfigRef
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketSpecForProvider {
            region = _region
            tags = _tags
        }
    }

    _oac = {
        apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
        kind = "OriginAccessControl"
        metadata.name = _oacName
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = "oac"}
        spec.providerConfigRef = _providerConfigRef
        spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1OriginAccessControlSpecForProvider {
            name = _oacName
            description = "OAC for ${spec.domainName}"
            originAccessControlOriginType = "s3"
            signingBehavior = "always"
            signingProtocol = "sigv4"
        }
    }

    # --- Certificate (custom domain only) ---

    # CloudFront only accepts certificates from us-east-1, whatever the bucket region.
    _certificate = [
        {
            apiVersion = "acm.aws.m.upbound.io/v1beta1"
            kind = "Certificate"
            metadata.name = _certName
            metadata.annotations = {"krm.kcl.dev/composition-resource-name" = "certificate"}
            spec.providerConfigRef = _providerConfigRef
            spec.forProvider = schemas_providers.AcmAwsmUpboundIoV1beta1CertificateSpecForProvider {
                region = "us-east-1"
                domainName = spec.domainName
                validationMethod = "DNS"
                tags = _tags
            }
        }
    ] if _customDomain else []

    _certAtProvider = ocds["certificate"]?.Resource?.status?.atProvider
    _certArn = _certAtProvider?.arn
    # The Certificate's observed status lags until the provider's next poll, but the
    # CertificateValidation only becomes Ready once ACM has issued the certificate.
    _validationConditions = ocds["cert-validation"]?.Resource?.status?.conditions or []
    _validationReady = any c in _validationConditions {
        c.type == "Ready" and c.status == "True"
    }
    _certIssued = _certAtProvider?.status == "ISSUED" or _validationReady
    _validationOptions = _certAtProvider?.domainValidationOptions or []
    _validationOption = _validationOptions[0] if _validationOptions else None

    # ACM publishes the record it wants to see only after the certificate exists.
    _certValidation = [
        {
            apiVersion = "route53.aws.m.upbound.io/v1beta1"
            kind = "Record"
            metadata.name = "${_bucketName}-cert-validation"
            metadata.annotations = {"krm.kcl.dev/composition-resource-name" = "cert-validation-record"}
            spec.providerConfigRef = _providerConfigRef
            spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
                zoneId = spec.zoneId
                name = _validationOption.resourceRecordName
                $type = _validationOption.resourceRecordType
                records = [_validationOption.resourceRecordValue]
                ttl = 60
                allowOverwrite = True
            }
        }
        {
            apiVersion = "acm.aws.m.upbound.io/v1beta1"
            kind = "CertificateValidation"
            metadata.name = "${_bucketName}-cert-validation"
            metadata.annotations = {"krm.kcl.dev/composition-resource-name" = "cert-validation"}
            spec.providerConfigRef = _providerConfigRef
            spec.forProvider = schemas_providers.AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProvider {
                region = "us-east-1"
                certificateArnRef = {name = _certName}
                validationRecordFqdns = [_validationOption.resourceRecordName]
            }
        }
    ] if _customDomain and _validationOption else []

    # --- Distribution ---

    # With a custom domain the distribution must wait for an issued certificate:
    # CloudFront rejects an alias that no valid certificate covers.
    _viewerCertificate = {
        acmCertificateArn = _certArn
        sslSupportMethod = "sni-only"
        minimumProtocolVersion = "TLSv1.2_2021"
    } if _customDomain else {cloudfrontDefaultCertificate = True}

    _distribution = [
        {
            apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
            kind = "Distribution"
            metadata.name = "${_bucketName}-dist"
            metadata.annotations = {"krm.kcl.dev/composition-resource-name" = "distribution"}
            spec.providerConfigRef = _providerConfigRef
            spec.forProvider = schemas_providers.CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProvider {
                enabled = True
                isIpv6Enabled = True
                priceClass = "PriceClass_100"
                defaultRootObject = _indexDocument
                tags = _tags
                if _customDomain:
                    aliases = [spec.domainName]
                # Crossplane resolves the OAC's id from the composed resource above.
                origin = [{
                    domainName = "${_bucketName}.s3.${_region}.amazonaws.com"
                    originId = _bucketName
                    originAccessControlIdRef = {name = _oacName}
                }]
                defaultCacheBehavior = {
                    allowedMethods = ["GET", "HEAD"]
                    cachedMethods = ["GET", "HEAD"]
                    targetOriginId = _bucketName
                    viewerProtocolPolicy = "redirect-to-https"
                    compress = True
                    # CachingOptimized, an AWS managed cache policy.
                    cachePolicyId = "658327ea-f89d-4fab-a63d-7e88639e58f6"
                }
                customErrorResponse = [{
                    errorCode = 404
                    responseCode = 404
                    responsePagePath = "/${_errorDocument}"
                }]
                restrictions = {geoRestriction = {restrictionType = "none"}}
                viewerCertificate = _viewerCertificate
            }
        }
    ] if not _customDomain or _certIssued else []

    _distAtProvider = ocds["distribution"]?.Resource?.status?.atProvider
    _distributionArn = _distAtProvider?.arn
    _distributionDomain = _distAtProvider?.domainName
    _distributionZone = _distAtProvider?.hostedZoneId

    # --- Bucket policy ---

    # Only the distribution may read the bucket. The SourceArn condition can only
    # be set once the distribution reports its ARN, so it is added when observed.
    _statement = {
        Sid = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {Service = "cloudfront.amazonaws.com"}
        Action = "s3:GetObject"
        Resource = "arn:aws:s3:::${_bucketName}/*"
    }
    _policyDocument = {
        Version = "2012-10-17"
        Statement = [_statement | {
            Condition.StringEquals = {"AWS:SourceArn" = _distributionArn}
        } if _distributionArn else _statement]
    }

    _policy = {
        apiVersion = "s3.aws.m.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata.name = "${_bucketName}-policy"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = "policy"}
        spec.providerConfigRef = _providerConfigRef
        spec.forProvider = schemas_providers.S3AwsmUpboundIoV1beta1BucketPolicySpecForProvider {
            region = _region
            bucket = _bucketName
            # The namespaced BucketPolicy takes the document as a JSON string.
            policy = json.encode(_policyDocument)
        }
    }

    # --- Alias record (custom domain only) ---

    _dns = [
        {
            apiVersion = "route53.aws.m.upbound.io/v1beta1"
            kind = "Record"
            metadata.name = "${_bucketName}-dns"
            metadata.annotations = {"krm.kcl.dev/composition-resource-name" = "dns"}
            spec.providerConfigRef = _providerConfigRef
            spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
                zoneId = spec.zoneId
                name = spec.domainName
                $type = "A"
                alias = {
                    name = _distributionDomain
                    zoneId = _distributionZone
                    evaluateTargetHealth = False
                }
            }
        }
    ] if _customDomain and _distributionDomain and _distributionZone else []

    # --- Status ---

    _status = {
        bucketName = _bucketName
        domainName = spec.domainName
        distributionDomainName = _distributionDomain
        url = "https://${spec.domainName}" if _customDomain else "https://${_distributionDomain}"
        if _certArn:
            certificateArn = _certArn
    }
    _xr = [
        {
            apiVersion = oxr.apiVersion
            kind = oxr.kind
            metadata = oxr.metadata
            status = _status
        }
    ] if _distributionDomain else []

    [_bucket, _oac] + _certificate + _certValidation + _distribution + [_policy] + _dns + _xr
}
