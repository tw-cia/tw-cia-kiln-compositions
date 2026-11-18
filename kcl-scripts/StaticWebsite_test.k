import json
import .staticwebsite

_staticWebsiteOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticWebsite"
    metadata.name = "site"
    spec = {domainName = "site.example.com", hostedZoneId = "Z123EXAMPLE"}
}

_staticWebsiteCertificateArn = "arn:aws:acm:us-east-1:111111111111:certificate/example"

# The bucket exists and reports its regional domain name.
_staticWebsiteBucketObserved = {Resource = {status = {atProvider = {
    arn = "arn:aws:s3:::site-example-com"
    bucketRegionalDomainName = "site-example-com.s3.us-east-1.amazonaws.com"
    id = "site-example-com"
}}}}

# The origin access control exists and reports its id.
_staticWebsiteOacObserved = {Resource = {status = {atProvider = {id = "E2OACEXAMPLE"}}}}

# The certificate child has an ARN but is not validated yet.
_staticWebsiteCertificatePending = {Resource = {status = {
    certificateArn = _staticWebsiteCertificateArn
    validated = False
}}}

# The certificate child reports validated. It carries conditions too, as a real XR does.
_staticWebsiteCertificateValidated = {Resource = {status = {
    certificateArn = _staticWebsiteCertificateArn
    validated = True
    conditions = [{"type" = "Ready", status = "True"}]
}}}

# The distribution exists and reports its ARN and CloudFront domain.
_staticWebsiteDistributionObserved = {Resource = {status = {atProvider = {
    arn = "arn:aws:cloudfront::111111111111:distribution/EDISTEXAMPLE"
    domainName = "d111abcdef8.cloudfront.net"
    hostedZoneId = "Z2FDTNDATAQYW2"
    id = "EDISTEXAMPLE"
}}}}

_staticWebsiteReadyToDistribute = {
    bucket = _staticWebsiteBucketObserved
    "origin-access-control" = _staticWebsiteOacObserved
    certificate = _staticWebsiteCertificateValidated
}

_staticWebsiteFullyObserved = {
    bucket = _staticWebsiteBucketObserved
    "origin-access-control" = _staticWebsiteOacObserved
    certificate = _staticWebsiteCertificateValidated
    distribution = _staticWebsiteDistributionObserved
}

_staticWebsiteKinds = lambda result -> [str] {
    [r.kind for r in result]
}

# Cold start: nothing observed, so the certificate, bucket and access control are requested.
test_staticWebsite_cold_start_composes_certificate_bucket_and_access_control = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, {})

    assert _staticWebsiteKinds(result) == ["TlsCertificate", "Bucket", "BucketPublicAccessBlock", "OriginAccessControl"]
}

test_staticWebsite_requests_a_us_east_1_certificate_for_the_domain = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, {})

    cert = result[0]
    assert cert.apiVersion == "platform.demotw.com/v1alpha1"
    assert cert.kind == "TlsCertificate"
    assert cert.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "certificate"
    assert cert.spec.domainName == "site.example.com"
    assert cert.spec.hostedZoneId == "Z123EXAMPLE"
    assert cert.spec.region == "us-east-1"
}

test_staticWebsite_bucket_is_named_from_the_domain_by_default = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, {})

    bucket = result[1]
    assert bucket.apiVersion == "s3.aws.m.upbound.io/v1beta1"
    assert bucket.kind == "Bucket"
    assert bucket.metadata.annotations["crossplane.io/external-name"] == "site-example-com"
    assert bucket.spec.forProvider.region == "us-east-1"
}

test_staticWebsite_bucket_name_can_be_set = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "StaticWebsite"
        metadata.name = "site"
        spec = {domainName = "site.example.com", hostedZoneId = "Z123EXAMPLE", bucketName = "my-site-bucket"}
    }

    result = staticwebsite.composeStaticWebsite(oxr, {})

    assert result[1].metadata.annotations["crossplane.io/external-name"] == "my-site-bucket"
}

test_staticWebsite_bucket_region_can_be_set = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "StaticWebsite"
        metadata.name = "site"
        spec = {domainName = "site.example.com", hostedZoneId = "Z123EXAMPLE", bucketRegion = "eu-west-2"}
    }

    result = staticwebsite.composeStaticWebsite(oxr, {})

    assert result[1].spec.forProvider.region == "eu-west-2"
}

test_staticWebsite_blocks_all_public_access_to_the_bucket = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, {})

    block = result[2]
    assert block.kind == "BucketPublicAccessBlock"
    assert block.spec.forProvider.bucket == "site-example-com"
    assert block.spec.forProvider.blockPublicAcls
    assert block.spec.forProvider.blockPublicPolicy
    assert block.spec.forProvider.ignorePublicAcls
    assert block.spec.forProvider.restrictPublicBuckets
}

test_staticWebsite_origin_access_control_signs_s3_requests = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, {})

    oac = result[3]
    assert oac.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert oac.kind == "OriginAccessControl"
    assert oac.spec.forProvider.name == "site-example-com"
    assert oac.spec.forProvider.originAccessControlOriginType == "s3"
    assert oac.spec.forProvider.signingBehavior == "always"
    assert oac.spec.forProvider.signingProtocol == "sigv4"
}

# The bucket and access control are ready, but the certificate is not validated yet.
test_staticWebsite_no_distribution_until_the_certificate_is_validated = lambda {
    ocds = {
        bucket = _staticWebsiteBucketObserved
        "origin-access-control" = _staticWebsiteOacObserved
        certificate = _staticWebsiteCertificatePending
    }

    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, ocds)

    assert "Distribution" not in _staticWebsiteKinds(result)
}

test_staticWebsite_distribution_serves_the_bucket_through_oac_with_the_certificate = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, _staticWebsiteReadyToDistribute)

    dist = [r for r in result if r.kind == "Distribution"][0]
    assert dist.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert dist.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "distribution"
    forProvider = dist.spec.forProvider
    assert forProvider.aliases == ["site.example.com"]
    assert forProvider.enabled
    assert forProvider.defaultRootObject == "index.html"
    assert forProvider.origin[0].domainName == "site-example-com.s3.us-east-1.amazonaws.com"
    assert forProvider.origin[0].originAccessControlId == "E2OACEXAMPLE"
    assert forProvider.defaultCacheBehavior.targetOriginId == forProvider.origin[0].originId
    assert forProvider.defaultCacheBehavior.viewerProtocolPolicy == "redirect-to-https"
    assert forProvider.viewerCertificate.acmCertificateArn == _staticWebsiteCertificateArn
    assert forProvider.viewerCertificate.sslSupportMethod == "sni-only"
}

test_staticWebsite_index_document_can_be_set = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "StaticWebsite"
        metadata.name = "site"
        spec = {domainName = "site.example.com", hostedZoneId = "Z123EXAMPLE", indexDocument = "home.html"}
    }

    result = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteReadyToDistribute)

    dist = [r for r in result if r.kind == "Distribution"][0]
    assert dist.spec.forProvider.defaultRootObject == "home.html"
}

# The distribution is created but has not reported its ARN or domain yet: no policy, records or status.
test_staticWebsite_no_policy_records_or_status_until_the_distribution_is_observed = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, _staticWebsiteReadyToDistribute)

    kinds = _staticWebsiteKinds(result)
    assert "BucketPolicy" not in kinds
    assert "Record" not in kinds
    assert "StaticWebsite" not in kinds
}

test_staticWebsite_bucket_policy_lets_only_this_distribution_read = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, _staticWebsiteFullyObserved)

    policyResource = [r for r in result if r.kind == "BucketPolicy"][0]
    assert policyResource.spec.forProvider.bucket == "site-example-com"
    policy = json.decode(policyResource.spec.forProvider.policy)
    statement = policy.Statement[0]
    assert statement.Effect == "Allow"
    assert statement.Principal.Service == "cloudfront.amazonaws.com"
    assert statement.Action == ["s3:GetObject"]
    assert statement.Resource == "arn:aws:s3:::site-example-com/*"
    assert statement.Condition.StringEquals["AWS:SourceArn"] == "arn:aws:cloudfront::111111111111:distribution/EDISTEXAMPLE"
}

test_staticWebsite_writes_ipv4_and_ipv6_alias_records_for_the_domain = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, _staticWebsiteFullyObserved)

    records = [r for r in result if r.kind == "Record"]
    assert len(records) == 2
    assert [r.spec.forProvider["type"] for r in records] == ["A", "AAAA"]
    assert all_true([r.apiVersion == "route53.aws.m.upbound.io/v1beta1" for r in records])
    assert all_true([r.spec.forProvider.zoneId == "Z123EXAMPLE" for r in records])
    assert all_true([r.spec.forProvider.name == "site.example.com" for r in records])
    assert all_true([r.spec.forProvider.alias.name == "d111abcdef8.cloudfront.net" for r in records])
    assert all_true([r.spec.forProvider.alias.zoneId == "Z2FDTNDATAQYW2" for r in records])
    assert all_true([not r.spec.forProvider.alias.evaluateTargetHealth for r in records])
}

test_staticWebsite_reports_url_and_distribution_domain_once_observed = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, _staticWebsiteFullyObserved)

    xr = result[-1]
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.kind == "StaticWebsite"
    assert xr.metadata.name == "site"
    assert xr.status.url == "https://site.example.com"
    assert xr.status.distributionDomainName == "d111abcdef8.cloudfront.net"
}

# A bucket and access control that exist but have reported no fields yet count as not observed.
test_staticWebsite_empty_atprovider_is_treated_as_not_observed = lambda {
    ocds = {
        bucket = {Resource = {status = {atProvider = {}}}}
        "origin-access-control" = {Resource = {status = {atProvider = {}}}}
        certificate = _staticWebsiteCertificateValidated
    }

    result = staticwebsite.composeStaticWebsite(_staticWebsiteOxr, ocds)

    assert "Distribution" not in _staticWebsiteKinds(result)
    assert _staticWebsiteKinds(result) == _staticWebsiteKinds(staticwebsite.composeStaticWebsite(_staticWebsiteOxr, {}))
}
