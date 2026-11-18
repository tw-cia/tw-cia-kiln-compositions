import json
import .cdndistribution
import .schemas_compositions

_cdnDomain = {name = "cdn.example.com", hostedZoneId = "Z0123456789ABCDEFGHIJ"}

# The two origins. The S3 bucket is served through an origin access control, and the
# HTTPS origin is a WebFleet's domain, which its own certificate covers.
_cdnHttpsOrigin = {domainName = "web.example.com"}
_cdnS3Origin = {bucketName = "cdn-example-assets"}

_cdnHttpsOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "CdnDistribution"
    metadata = {name = "cdn"}
    spec = {domain = _cdnDomain, origin = _cdnHttpsOrigin}
}

_cdnS3Oxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "CdnDistribution"
    metadata = {name = "cdn"}
    spec = {domain = _cdnDomain, origin = _cdnS3Origin}
}

_cdnCertArn = "arn:aws:acm:us-east-1:111111111111:certificate/cdn-example"
_cdnBucketDomain = "cdn-example-assets.s3.us-east-1.amazonaws.com"
_cdnDistributionArn = "arn:aws:cloudfront::111111111111:distribution/E2CDN"

_cdnCertPending = {certificate = {Resource = {status = {certificateArn = _cdnCertArn, validated = False, conditions = [{"type" = "Ready", status = "False"}]}}}}
_cdnCertValidated = {certificate = {Resource = {status = {certificateArn = _cdnCertArn, validated = True, conditions = [{"type" = "Ready", status = "True"}]}}}}

_cdnBucketObserved = {bucket = {Resource = {status = {atProvider = {
    arn = "arn:aws:s3:::cdn-example-assets"
    bucketRegionalDomainName = _cdnBucketDomain
}}}}}

_cdnOacObserved = {"origin-access-control" = {Resource = {status = {atProvider = {id = "E1CDNOAC"}}}}}

_cdnDistributionObserved = {distribution = {Resource = {status = {atProvider = {
    arn = _cdnDistributionArn
    domainName = "d222222abcdef8.cloudfront.net"
}}}}}

_cdnComposed = lambda resources {
    [r for r in resources if r.kind != "CdnDistribution"]
}

_cdnXr = lambda resources {
    [r for r in resources if r.kind == "CdnDistribution"]
}

_cdnNamed = lambda resources, name {
    [r for r in _cdnComposed(resources) if r.metadata.annotations["krm.kcl.dev/composition-resource-name"] == name]
}

_cdnKind = lambda resources, kind {
    [r for r in _cdnComposed(resources) if r.kind == kind]
}

# --- the origin union ---------------------------------------------------------

test_cdnDistribution_origin_accepts_either_form = lambda {
    s3: schemas_compositions.OriginSpec = {bucketName = "cdn-example-assets"}
    https: schemas_compositions.OriginSpec = {domainName = "web.example.com"}

    assert s3.bucketName == "cdn-example-assets"
    assert s3.region == "us-east-1", "the bucket region defaults to us-east-1"
    assert https.domainName == "web.example.com"
}

test_cdnDistribution_spec_defaults_the_price_class = lambda {
    spec: schemas_compositions.CdnDistributionSpec = {domain = _cdnDomain, origin = _cdnHttpsOrigin}

    assert spec.priceClass == "PriceClass_100"
}

# --- certificate --------------------------------------------------------------

test_cdnDistribution_certificate_is_a_child_for_the_domain_in_us_east_1 = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, {})
    cert = _cdnNamed(result, "certificate")[0]

    assert cert.apiVersion == "platform.demotw.com/v1alpha1"
    assert cert.kind == "TlsCertificate"
    assert cert.spec.domainName == "cdn.example.com"
    assert cert.spec.hostedZoneId == "Z0123456789ABCDEFGHIJ"
    assert cert.spec.region == "us-east-1", "CloudFront only takes certificates from us-east-1"
}

# --- cold start ---------------------------------------------------------------

test_cdnDistribution_https_cold_start_emits_only_the_certificate = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, {})

    assert len(_cdnComposed(result)) == 1, "an HTTPS origin needs nothing but the certificate to start"
    assert len(_cdnXr(result)) == 0, "cold start reports no status"
}

test_cdnDistribution_s3_cold_start_emits_certificate_bucket_and_access_control = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnS3Oxr, {})

    assert len(_cdnComposed(result)) == 3
    assert len(_cdnKind(result, "Bucket")) == 1
    assert len(_cdnKind(result, "OriginAccessControl")) == 1
    assert len(_cdnKind(result, "TlsCertificate")) == 1
}

test_cdnDistribution_nothing_waits_on_observed_state_is_emitted_cold = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnS3Oxr, {})

    assert len(_cdnKind(result, "Distribution")) == 0, "waits for the access control, the bucket and the certificate"
    assert len(_cdnKind(result, "BucketPublicAccessBlock")) == 0, "waits for the bucket"
    assert len(_cdnKind(result, "BucketPolicy")) == 0, "waits for the distribution"
    assert len(_cdnKind(result, "Record")) == 0, "waits for the distribution"
}

# --- HTTPS origin -------------------------------------------------------------

test_cdnDistribution_https_origin_is_the_domain_over_https = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, _cdnCertValidated)
    dist = _cdnKind(result, "Distribution")[0]
    origin = dist.spec.forProvider.origin[0]

    assert dist.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert origin.domainName == "web.example.com", "the fleet's domain, which its certificate covers"
    assert origin.customOriginConfig.originProtocolPolicy == "https-only", "the fleet redirects HTTP to HTTPS"
    assert origin.customOriginConfig.httpsPort == 443
    assert origin.customOriginConfig.originSslProtocols == ["TLSv1.2"]
    assert not origin.originAccessControlId, "no access control for an HTTPS origin"
}

test_cdnDistribution_https_origin_caches_nothing_and_forwards_everything = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, _cdnCertValidated)
    behaviour = _cdnKind(result, "Distribution")[0].spec.forProvider.defaultCacheBehavior

    assert behaviour.cachePolicyId == "4135ea2d-6df8-44a3-9df3-4b5a84be39ad", "CachingDisabled managed policy"
    assert behaviour.originRequestPolicyId == "216adef6-5c7f-47e4-b989-5492eafa07d3", "AllViewer managed policy"
    assert "POST" in behaviour.allowedMethods, "a dynamic origin needs every method"
    assert behaviour.viewerProtocolPolicy == "redirect-to-https"
}

test_cdnDistribution_https_origin_waits_for_the_validated_certificate = lambda {
    none = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, {})
    pending = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, _cdnCertPending)

    assert len(_cdnKind(none, "Distribution")) == 0, "no certificate yet"
    assert len(_cdnKind(pending, "Distribution")) == 0, "certificate not validated yet"
}

test_cdnDistribution_no_bucket_resources_for_an_https_origin = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, _cdnCertValidated)

    assert len(_cdnKind(result, "Bucket")) == 0
    assert len(_cdnKind(result, "OriginAccessControl")) == 0
    assert len(_cdnKind(result, "BucketPolicy")) == 0
}

# --- S3 origin ----------------------------------------------------------------

test_cdnDistribution_s3_origin_uses_the_bucket_through_the_access_control = lambda {
    ocds = {**_cdnBucketObserved, **_cdnOacObserved, **_cdnCertValidated}
    result = cdndistribution.composeCdnDistribution(_cdnS3Oxr, ocds)
    dist = _cdnKind(result, "Distribution")[0]
    origin = dist.spec.forProvider.origin[0]

    assert origin.domainName == _cdnBucketDomain, "the bucket's regional domain name"
    assert origin.originAccessControlId == "E1CDNOAC"
    assert not origin.customOriginConfig, "a bucket is not an HTTP origin"
    assert dist.spec.forProvider.defaultRootObject == "index.html"
}

test_cdnDistribution_s3_origin_caches_optimised_content = lambda {
    ocds = {**_cdnBucketObserved, **_cdnOacObserved, **_cdnCertValidated}
    behaviour = _cdnKind(cdndistribution.composeCdnDistribution(_cdnS3Oxr, ocds), "Distribution")[0].spec.forProvider.defaultCacheBehavior

    assert behaviour.cachePolicyId == "658327ea-f89d-4fab-a63d-7e88639e58f6", "CachingOptimized managed policy"
    assert behaviour.allowedMethods == ["GET", "HEAD", "OPTIONS"], "a static site only reads"
}

test_cdnDistribution_s3_distribution_waits_for_the_bucket_and_access_control = lambda {
    onlyBucket = cdndistribution.composeCdnDistribution(_cdnS3Oxr, {**_cdnBucketObserved, **_cdnCertValidated})
    onlyOac = cdndistribution.composeCdnDistribution(_cdnS3Oxr, {**_cdnOacObserved, **_cdnCertValidated})

    assert len(_cdnKind(onlyBucket, "Distribution")) == 0, "no access control yet"
    assert len(_cdnKind(onlyOac, "Distribution")) == 0, "no bucket yet"
}

test_cdnDistribution_s3_bucket_is_named_and_private = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnS3Oxr, _cdnBucketObserved)
    bucket = _cdnNamed(result, "bucket")[0]
    block = _cdnKind(result, "BucketPublicAccessBlock")[0]

    assert bucket.metadata.annotations["crossplane.io/external-name"] == "cdn-example-assets"
    assert bucket.spec.forProvider.region == "us-east-1"
    assert block.spec.forProvider.bucket == "cdn-example-assets"
    assert block.spec.forProvider.blockPublicPolicy == True
    assert block.spec.forProvider.restrictPublicBuckets == True
}

test_cdnDistribution_s3_bucket_policy_lets_only_this_distribution_read = lambda {
    ocds = {**_cdnBucketObserved, **_cdnOacObserved, **_cdnCertValidated, **_cdnDistributionObserved}
    result = cdndistribution.composeCdnDistribution(_cdnS3Oxr, ocds)
    policyResource = _cdnKind(result, "BucketPolicy")[0]
    statement = json.decode(policyResource.spec.forProvider.policy).Statement[0]

    assert policyResource.spec.forProvider.bucket == "cdn-example-assets"
    assert statement.Principal.Service == "cloudfront.amazonaws.com"
    assert statement.Action == ["s3:GetObject"]
    assert statement.Resource == "arn:aws:s3:::cdn-example-assets/*"
    assert statement.Condition.StringEquals["AWS:SourceArn"] == _cdnDistributionArn
}

test_cdnDistribution_https_origin_has_no_bucket_policy_even_once_deployed = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, {**_cdnCertValidated, **_cdnDistributionObserved})

    assert len(_cdnKind(result, "BucketPolicy")) == 0
}

# --- domain, status ------------------------------------------------------------

test_cdnDistribution_serves_the_domain_over_the_certificate = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, _cdnCertValidated)
    forProvider = _cdnKind(result, "Distribution")[0].spec.forProvider

    assert forProvider.aliases == ["cdn.example.com"]
    assert forProvider.viewerCertificate.acmCertificateArn == _cdnCertArn
    assert forProvider.viewerCertificate.sslSupportMethod == "sni-only"
    assert forProvider.enabled == True
}

test_cdnDistribution_alias_record_points_the_domain_at_the_distribution = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, {**_cdnCertValidated, **_cdnDistributionObserved})
    record = _cdnKind(result, "Record")[0]

    assert record.spec.forProvider.zoneId == "Z0123456789ABCDEFGHIJ"
    assert record.spec.forProvider.name == "cdn.example.com"
    assert record.spec.forProvider.alias.name == "d222222abcdef8.cloudfront.net"
    assert record.spec.forProvider.alias.zoneId == "Z2FDTNDATAQYW2", "CloudFront's fixed hosted zone ID"
}

test_cdnDistribution_no_status_until_the_distribution_has_a_domain_name = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, _cdnCertValidated)

    assert len(_cdnXr(result)) == 0
}

test_cdnDistribution_reports_arn_and_domain_once_observed = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnHttpsOxr, {**_cdnCertValidated, **_cdnDistributionObserved})
    xr = _cdnXr(result)[0]

    assert xr.kind == "CdnDistribution"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.status.distributionArn == _cdnDistributionArn
    assert xr.status.domainName == "d222222abcdef8.cloudfront.net"
}
