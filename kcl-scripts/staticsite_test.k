import .staticsite

_staticSiteBaseOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticSite"
    metadata.name = "example-site"
    spec = {
        bucketName = "example-static-site"
    }
}

_staticSiteObservedOac = {
    apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
    kind = "OriginAccessControl"
    metadata.annotations = {"krm.kcl.dev/composition-resource-name" = "origin-access-control"}
    status.atProvider = {
        id = "E1EXAMPLEOACID"
        arn = "arn:aws:cloudfront::123456789012:origin-access-control/E1EXAMPLEOACID"
    }
}

_staticSiteObservedDistribution = {
    apiVersion = "cloudfront.aws.m.upbound.io/v1beta1"
    kind = "Distribution"
    metadata.annotations = {"krm.kcl.dev/composition-resource-name" = "distribution"}
    status.atProvider = {
        id = "E2EXAMPLEDISTID"
        arn = "arn:aws:cloudfront::123456789012:distribution/E2EXAMPLEDISTID"
        domainName = "d111111abcdef8.cloudfront.net"
    }
}

test_cold_start_composes_bucket_pab_and_oac_only = lambda {
    oxr = _staticSiteBaseOxr
    ocds = {}

    result = staticsite.composeStaticSite(oxr, ocds)

    assert len(result) == 3
    kinds = [r.kind for r in result]
    assert "Bucket" in kinds
    assert "BucketPublicAccessBlock" in kinds
    assert "OriginAccessControl" in kinds
    assert "Distribution" not in kinds
    assert "BucketPolicy" not in kinds
}

test_bucket_uses_the_spec_region_and_name = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "StaticSite"
        metadata.name = "example-site"
        spec = {
            bucketName = "example-static-site"
            region = "eu-west-1"
        }
    }
    ocds = {}

    result = staticsite.composeStaticSite(oxr, ocds)

    bucket = [r for r in result if r.kind == "Bucket"][0]
    assert bucket.metadata.annotations["crossplane.io/external-name"] == "example-static-site"
    assert bucket.spec.forProvider.region == "eu-west-1"
}

test_oac_observed_adds_the_distribution_pointed_at_the_bucket = lambda {
    oxr = _staticSiteBaseOxr
    ocds = {
        "origin-access-control" = {Resource = _staticSiteObservedOac}
    }

    result = staticsite.composeStaticSite(oxr, ocds)

    kinds = [r.kind for r in result]
    assert "Distribution" in kinds
    assert "BucketPolicy" not in kinds

    distribution = [r for r in result if r.kind == "Distribution"][0]
    origin = distribution.spec.forProvider.origin[0]
    assert origin.originAccessControlId == "E1EXAMPLEOACID"
    assert origin.domainName == "example-static-site.s3.us-east-1.amazonaws.com"
}

test_distribution_observed_adds_the_bucket_policy_and_status = lambda {
    oxr = _staticSiteBaseOxr
    ocds = {
        "origin-access-control" = {Resource = _staticSiteObservedOac}
        "distribution" = {Resource = _staticSiteObservedDistribution}
    }

    result = staticsite.composeStaticSite(oxr, ocds)

    kinds = [r.kind for r in result]
    assert "BucketPolicy" in kinds

    policy = [r for r in result if r.kind == "BucketPolicy"][0]
    assert "arn:aws:cloudfront::123456789012:distribution/E2EXAMPLEDISTID" in policy.spec.forProvider.policy

    xr = [r for r in result if r.kind == "StaticSite"][0]
    assert xr.status.distributionDomainName == "d111111abcdef8.cloudfront.net"
    assert xr.status.distributionArn == "arn:aws:cloudfront::123456789012:distribution/E2EXAMPLEDISTID"
}
