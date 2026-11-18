import json
import .schemas_compositions
import .staticwebsite

_staticWebSiteOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticWebSite"
    metadata = {name = "docs-site"}
    spec = {
        domain = {name = "docs.example.com", hostedZoneId = "Z0123456789ABCDEFGHIJ"}
        bucket = {name = "docs-example-com-assets"}
    }
}

_staticWebSiteCertArn = "arn:aws:acm:us-east-1:111111111111:certificate/example"
_staticWebSiteBucketDomain = "docs-example-com-assets.s3.us-east-1.amazonaws.com"
_staticWebSiteDistributionArn = "arn:aws:cloudfront::111111111111:distribution/E2EXAMPLE"

# Observed stages. Each is a snapshot of everything observed at that point.
_staticWebSiteOcdsBucket = {
    bucket = {Resource = {status = {atProvider = {
        arn = "arn:aws:s3:::docs-example-com-assets"
        bucketRegionalDomainName = _staticWebSiteBucketDomain
    }}}}
}

_staticWebSiteOcdsOac = {
    "origin-access-control" = {Resource = {status = {atProvider = {id = "E1OACEXAMPLE"}}}}
}

_staticWebSiteOcdsCertPending = {
    certificate = {Resource = {status = {certificateArn = _staticWebSiteCertArn, validated = False, conditions = [{"type" = "Ready", status = "False"}]}}}
}

_staticWebSiteOcdsCertValidated = {
    certificate = {Resource = {status = {certificateArn = _staticWebSiteCertArn, validated = True, conditions = [{"type" = "Ready", status = "True"}]}}}
}

_staticWebSiteOcdsReady = {
    **_staticWebSiteOcdsBucket
    **_staticWebSiteOcdsOac
    **_staticWebSiteOcdsCertValidated
}

_staticWebSiteOcdsDeployed = {
    **_staticWebSiteOcdsReady
    distribution = {Resource = {status = {atProvider = {
        arn = _staticWebSiteDistributionArn
        domainName = "d111111abcdef8.cloudfront.net"
    }}}}
}

# The composed resources (everything but the XR status item), and the XR status item.
_staticWebSiteComposed = lambda resources {
    [r for r in resources if r.kind != "StaticWebSite"]
}

_staticWebSiteXr = lambda resources {
    [r for r in resources if r.kind == "StaticWebSite"]
}

_staticWebSiteNamed = lambda resources, name {
    [r for r in _staticWebSiteComposed(resources) if r.metadata.annotations["krm.kcl.dev/composition-resource-name"] == name]
}

_staticWebSiteKind = lambda resources, kind {
    [r for r in _staticWebSiteComposed(resources) if r.kind == kind]
}

# --- cold start -------------------------------------------------------------

test_staticWebSite_cold_start_emits_certificate_bucket_and_access_control = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, {})

    assert len(_staticWebSiteComposed(result)) == 3, "cold start: certificate, bucket and origin access control"
    assert len(_staticWebSiteKind(result, "TlsCertificate")) == 1
    assert len(_staticWebSiteKind(result, "Bucket")) == 1
    assert len(_staticWebSiteKind(result, "OriginAccessControl")) == 1
    assert len(_staticWebSiteXr(result)) == 0, "cold start reports no status"
}

test_staticWebSite_nothing_depending_on_observed_state_is_emitted_cold = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, {})

    assert len(_staticWebSiteKind(result, "BucketPublicAccessBlock")) == 0, "waits for the bucket"
    assert len(_staticWebSiteKind(result, "Distribution")) == 0, "waits for the bucket, the access control and the certificate"
    assert len(_staticWebSiteKind(result, "BucketPolicy")) == 0, "waits for the distribution"
    assert len(_staticWebSiteKind(result, "Record")) == 0, "waits for the distribution"
}

# --- certificate -------------------------------------------------------------

test_staticWebSite_certificate_is_a_child_tls_certificate_for_the_domain = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, {})
    cert = _staticWebSiteNamed(result, "certificate")[0]

    assert cert.apiVersion == "platform.demotw.com/v1alpha1"
    assert cert.kind == "TlsCertificate"
    assert cert.spec.domainName == "docs.example.com"
    assert cert.spec.hostedZoneId == "Z0123456789ABCDEFGHIJ"
    assert cert.spec.region == "us-east-1", "CloudFront only takes certificates from us-east-1"
}

# --- bucket ------------------------------------------------------------------

test_staticWebSite_bucket_is_named_by_the_spec_in_the_region = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, {})
    bucket = _staticWebSiteNamed(result, "bucket")[0]

    assert bucket.apiVersion == "s3.aws.m.upbound.io/v1beta1"
    assert bucket.kind == "Bucket"
    assert bucket.metadata.annotations["crossplane.io/external-name"] == "docs-example-com-assets"
    assert bucket.spec.forProvider.region == "us-east-1"
}

test_staticWebSite_bucket_region_defaults_to_us_east_1 = lambda {
    spec = schemas_compositions.StaticWebSiteSpec {
        domain = {name = "docs.example.com", hostedZoneId = "Z0123456789ABCDEFGHIJ"}
        bucket = {name = "docs-example-com-assets"}
    }

    assert spec.bucket.region == "us-east-1"
}

test_staticWebSite_bucket_region_passes_through = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "StaticWebSite"
        metadata = {name = "docs-site"}
        spec = {
            domain = {name = "docs.example.com", hostedZoneId = "Z0123456789ABCDEFGHIJ"}
            bucket = {name = "docs-example-com-assets", region = "eu-west-1"}
        }
    }
    result = staticwebsite.composeStaticWebSite(oxr, {})

    assert _staticWebSiteNamed(result, "bucket")[0].spec.forProvider.region == "eu-west-1"
}

# --- origin access control ---------------------------------------------------

test_staticWebSite_origin_access_control_signs_s3_requests_with_sigv4 = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, {})
    oac = _staticWebSiteNamed(result, "origin-access-control")[0]

    assert oac.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert oac.kind == "OriginAccessControl"
    assert oac.spec.forProvider.originAccessControlOriginType == "s3"
    assert oac.spec.forProvider.signingBehavior == "always"
    assert oac.spec.forProvider.signingProtocol == "sigv4"
}

# --- public access block -----------------------------------------------------

test_staticWebSite_public_access_is_blocked_once_the_bucket_exists = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, _staticWebSiteOcdsBucket)
    block = _staticWebSiteKind(result, "BucketPublicAccessBlock")[0]

    assert block.apiVersion == "s3.aws.m.upbound.io/v1beta1"
    assert block.spec.forProvider.bucket == "docs-example-com-assets"
    assert block.spec.forProvider.blockPublicAcls == True
    assert block.spec.forProvider.blockPublicPolicy == True
    assert block.spec.forProvider.ignorePublicAcls == True
    assert block.spec.forProvider.restrictPublicBuckets == True
}

# --- distribution ------------------------------------------------------------

test_staticWebSite_distribution_waits_for_the_bucket_access_control_and_certificate = lambda {
    onlyBucket = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, _staticWebSiteOcdsBucket)
    bucketAndOac = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, {**_staticWebSiteOcdsBucket, **_staticWebSiteOcdsOac})
    bucketOacPending = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, {**_staticWebSiteOcdsReady, **_staticWebSiteOcdsCertPending})

    assert len(_staticWebSiteKind(onlyBucket, "Distribution")) == 0, "no access control or certificate yet"
    assert len(_staticWebSiteKind(bucketAndOac, "Distribution")) == 0, "certificate not known yet"
    assert len(_staticWebSiteKind(bucketOacPending, "Distribution")) == 0, "certificate not validated yet"
}

test_staticWebSite_distribution_is_emitted_when_ready = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, _staticWebSiteOcdsReady)
    dist = _staticWebSiteKind(result, "Distribution")[0]

    assert len(_staticWebSiteKind(result, "Distribution")) == 1
    assert dist.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert dist.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "distribution"
}

test_staticWebSite_origin_is_the_bucket_through_the_access_control = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, _staticWebSiteOcdsReady)
    origin = _staticWebSiteKind(result, "Distribution")[0].spec.forProvider.origin[0]

    assert origin.domainName == _staticWebSiteBucketDomain, "the bucket's regional domain name"
    assert origin.originAccessControlId == "E1OACEXAMPLE"
    assert origin.originId == "s3-origin"
}

test_staticWebSite_distribution_serves_https_on_the_domain_with_the_acm_certificate = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, _staticWebSiteOcdsReady)
    forProvider = _staticWebSiteKind(result, "Distribution")[0].spec.forProvider

    assert forProvider.aliases == ["docs.example.com"]
    assert forProvider.viewerCertificate.acmCertificateArn == _staticWebSiteCertArn
    assert forProvider.viewerCertificate.sslSupportMethod == "sni-only"
    assert forProvider.viewerCertificate.minimumProtocolVersion == "TLSv1.2_2021"
    assert forProvider.defaultCacheBehavior.viewerProtocolPolicy == "redirect-to-https"
    assert forProvider.defaultRootObject == "index.html"
    assert forProvider.enabled == True
}

# --- bucket policy -----------------------------------------------------------

test_staticWebSite_no_bucket_policy_until_the_distribution_is_observed = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, _staticWebSiteOcdsReady)

    assert len(_staticWebSiteKind(result, "BucketPolicy")) == 0, "the policy names the distribution's ARN"
}

test_staticWebSite_bucket_policy_lets_only_this_distribution_read = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, _staticWebSiteOcdsDeployed)
    policyResource = _staticWebSiteKind(result, "BucketPolicy")[0]
    policy = json.decode(policyResource.spec.forProvider.policy)
    statement = policy.Statement[0]

    assert policyResource.spec.forProvider.bucket == "docs-example-com-assets"
    assert statement.Effect == "Allow"
    assert statement.Principal.Service == "cloudfront.amazonaws.com", "CloudFront's service principal, not anyone"
    assert statement.Action == ["s3:GetObject"]
    assert statement.Resource == "arn:aws:s3:::docs-example-com-assets/*"
    assert statement.Condition.StringEquals["AWS:SourceArn"] == _staticWebSiteDistributionArn, "signed requests from this distribution only"
}

# --- alias record ------------------------------------------------------------

test_staticWebSite_alias_record_points_the_domain_at_the_distribution = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, _staticWebSiteOcdsDeployed)
    record = _staticWebSiteKind(result, "Record")[0]

    assert len(_staticWebSiteKind(result, "Record")) == 1
    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.spec.forProvider.zoneId == "Z0123456789ABCDEFGHIJ"
    assert record.spec.forProvider.name == "docs.example.com"
    assert record.spec.forProvider.$type == "A"
    assert record.spec.forProvider.alias.name == "d111111abcdef8.cloudfront.net"
    assert record.spec.forProvider.alias.zoneId == "Z2FDTNDATAQYW2", "CloudFront's fixed hosted zone ID"
}

# --- status ------------------------------------------------------------------

test_staticWebSite_no_status_before_the_distribution_has_a_domain_name = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, _staticWebSiteOcdsReady)

    assert len(_staticWebSiteXr(result)) == 0
}

test_staticWebSite_reports_the_distribution_once_observed = lambda {
    result = staticwebsite.composeStaticWebSite(_staticWebSiteOxr, _staticWebSiteOcdsDeployed)
    xr = _staticWebSiteXr(result)[0]

    assert xr.kind == "StaticWebSite"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.status.distribution.domainName == "d111111abcdef8.cloudfront.net"
    assert xr.status.distribution.arn == _staticWebSiteDistributionArn
}
