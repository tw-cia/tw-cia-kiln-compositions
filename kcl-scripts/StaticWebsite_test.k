import json
import .staticwebsite

_staticWebsiteOxrFor = lambda specIn {
    _oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "StaticWebsite"
        metadata = {name = "my-site"}
        spec = specIn
    }
    _oxr
}

_staticWebsiteFind = lambda resources, kind {
    [r for r in resources if r.kind == kind][0]
}

# Observed stages. Keys are the composition-resource-names used in the compose function.
_staticWebsiteBucketObs = {
    Resource = {status = {atProvider = {
        arn = "arn:aws:s3:::example-site"
        bucketRegionalDomainName = "example-site.s3.us-east-1.amazonaws.com"
    }}}
}
_staticWebsiteOacObs = {
    Resource = {status = {atProvider = {id = "E2OACID"}}}
}
_staticWebsiteDistributionObs = {
    Resource = {status = {atProvider = {
        arn = "arn:aws:cloudfront::123456789012:distribution/E1DIST"
        domainName = "d111abcdef8.cloudfront.net"
        id = "E1DIST"
    }}}
}
_staticWebsiteStorageOcds = {
    bucket = _staticWebsiteBucketObs
    "origin-access-control" = _staticWebsiteOacObs
}
_staticWebsiteAllOcds = {
    **_staticWebsiteStorageOcds
    distribution = _staticWebsiteDistributionObs
}
_staticWebsiteEmptyBucketOcds = {
    bucket = {Resource = {status = {atProvider = {}}}}
    "origin-access-control" = _staticWebsiteOacObs
}

test_staticWebsite_cold_start_composes_bucket_access_block_and_oac = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site"})

    result = staticwebsite.composeStaticWebsite(oxr, {})

    kinds = [r.kind for r in result]
    assert kinds == ["Bucket", "BucketPublicAccessBlock", "OriginAccessControl"]
}

test_staticWebsite_bucket_is_named_by_bucket_name_in_its_region_with_tags = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site", region = "eu-west-1", tags = {team = "web"}})

    result = staticwebsite.composeStaticWebsite(oxr, {})

    bucket = _staticWebsiteFind(result, "Bucket")
    assert bucket.apiVersion == "s3.aws.m.upbound.io/v1beta1"
    assert bucket.metadata.annotations["crossplane.io/external-name"] == "example-site"
    assert bucket.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "bucket"
    assert bucket.spec.forProvider.region == "eu-west-1"
    assert bucket.spec.forProvider.tags.team == "web"
}

test_staticWebsite_region_defaults_to_us_east_1 = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site"})

    result = staticwebsite.composeStaticWebsite(oxr, {})

    bucket = _staticWebsiteFind(result, "Bucket")
    assert bucket.spec.forProvider.region == "us-east-1"
}

test_staticWebsite_public_access_block_blocks_all_public_access = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site", region = "eu-west-1"})

    result = staticwebsite.composeStaticWebsite(oxr, {})

    block = _staticWebsiteFind(result, "BucketPublicAccessBlock")
    assert block.apiVersion == "s3.aws.m.upbound.io/v1beta1"
    assert block.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "public-access-block"
    assert block.spec.forProvider.bucket == "example-site"
    assert block.spec.forProvider.region == "eu-west-1"
    assert block.spec.forProvider.blockPublicAcls
    assert block.spec.forProvider.blockPublicPolicy
    assert block.spec.forProvider.ignorePublicAcls
    assert block.spec.forProvider.restrictPublicBuckets
}

test_staticWebsite_origin_access_control_signs_s3_requests = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site"})

    result = staticwebsite.composeStaticWebsite(oxr, {})

    oac = _staticWebsiteFind(result, "OriginAccessControl")
    assert oac.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert oac.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "origin-access-control"
    assert oac.spec.forProvider.originAccessControlOriginType == "s3"
    assert oac.spec.forProvider.signingBehavior == "always"
    assert oac.spec.forProvider.signingProtocol == "sigv4"
}

test_staticWebsite_ignores_extra_control_plane_fields_in_spec = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site", crossplane = {}})

    result = staticwebsite.composeStaticWebsite(oxr, {})

    assert len(result) == 3
}

test_staticWebsite_empty_bucket_observation_does_not_compose_distribution = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site"})

    result = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteEmptyBucketOcds)

    kinds = [r.kind for r in result]
    assert "Distribution" not in kinds
    assert "BucketPolicy" not in kinds
}

test_staticWebsite_distribution_waits_for_bucket_domain_and_oac_id = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site"})

    result = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteStorageOcds)

    kinds = [r.kind for r in result]
    assert "Distribution" in kinds
    assert "BucketPolicy" not in kinds
    dist = _staticWebsiteFind(result, "Distribution")
    origin = dist.spec.forProvider.origin[0]
    assert origin.domainName == "example-site.s3.us-east-1.amazonaws.com"
    assert origin.originAccessControlId == "E2OACID"
    assert dist.spec.forProvider.defaultCacheBehavior.targetOriginId == origin.originId
}

test_staticWebsite_distribution_serves_index_document_with_default_price_class = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site"})

    result = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteStorageOcds)

    dist = _staticWebsiteFind(result, "Distribution")
    assert dist.spec.forProvider.enabled
    assert dist.spec.forProvider.defaultRootObject == "index.html"
    assert dist.spec.forProvider.priceClass == "PriceClass_100"
    assert dist.spec.forProvider.viewerCertificate.cloudfrontDefaultCertificate
}

test_staticWebsite_distribution_uses_custom_domain_with_certificate = lambda {
    oxr = _staticWebsiteOxrFor({
        bucketName = "example-site"
        indexDocument = "home.html"
        aliases = ["www.example.com"]
        certificateArn = "arn:aws:acm:us-east-1:123456789012:certificate/abc"
    })

    result = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteStorageOcds)

    dist = _staticWebsiteFind(result, "Distribution")
    assert dist.spec.forProvider.defaultRootObject == "home.html"
    assert dist.spec.forProvider.aliases == ["www.example.com"]
    assert dist.spec.forProvider.viewerCertificate.acmCertificateArn == "arn:aws:acm:us-east-1:123456789012:certificate/abc"
    assert dist.spec.forProvider.viewerCertificate.sslSupportMethod == "sni-only"
}

test_staticWebsite_distribution_omits_aliases_and_custom_errors_when_unset = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site"})

    result = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteStorageOcds)

    dist = _staticWebsiteFind(result, "Distribution")
    assert not dist.spec.forProvider.aliases
    assert not dist.spec.forProvider.customErrorResponse
}

test_staticWebsite_error_document_maps_403_and_404_to_it = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site", errorDocument = "404.html"})

    result = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteStorageOcds)

    dist = _staticWebsiteFind(result, "Distribution")
    errors = dist.spec.forProvider.customErrorResponse
    assert len(errors) == 2
    assert errors[0].errorCode == 403
    assert errors[1].errorCode == 404
    assert errors[0].responsePagePath == "/404.html"
    assert errors[0].responseCode == 404
}

test_staticWebsite_bucket_policy_grants_read_only_to_this_distribution = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site", region = "eu-west-1"})

    result = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteAllOcds)

    policyResource = _staticWebsiteFind(result, "BucketPolicy")
    assert policyResource.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "bucket-policy"
    assert policyResource.spec.forProvider.bucket == "example-site"
    assert policyResource.spec.forProvider.region == "eu-west-1"
    policy = json.decode(policyResource.spec.forProvider.policy)
    statement = policy.Statement[0]
    assert statement.Effect == "Allow"
    assert statement.Principal.Service == "cloudfront.amazonaws.com"
    assert statement.Action == "s3:GetObject"
    assert statement.Resource == "arn:aws:s3:::example-site/*"
    assert statement.Condition.StringEquals["AWS:SourceArn"] == "arn:aws:cloudfront::123456789012:distribution/E1DIST"
}

test_staticWebsite_status_reports_domain_only_once_distribution_is_observed = lambda {
    oxr = _staticWebsiteOxrFor({bucketName = "example-site"})

    beforeDist = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteStorageOcds)
    assert "StaticWebsite" not in [r.kind for r in beforeDist]

    result = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteAllOcds)

    xr = _staticWebsiteFind(result, "StaticWebsite")
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.metadata.name == "my-site"
    assert xr.status.domainName == "d111abcdef8.cloudfront.net"
    assert xr.status.distributionId == "E1DIST"
}

test_staticWebsite_alias_records_point_each_alias_at_the_distribution = lambda {
    oxr = _staticWebsiteOxrFor({
        bucketName = "example-site"
        aliases = ["test.trololo.demotw.com"]
        certificateArn = "arn:aws:acm:us-east-1:123456789012:certificate/abc"
        zoneId = "Z0510802PA88E7HZZ597"
    })

    result = staticwebsite.composeStaticWebsite(oxr, _staticWebsiteAllOcds)

    records = [r for r in result if r.kind == "Record"]
    assert len(records) == 1
    record = records[0]
    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "alias-record-0"
    assert record.spec.forProvider.zoneId == "Z0510802PA88E7HZZ597"
    assert record.spec.forProvider.name == "test.trololo.demotw.com"
    assert record.spec.forProvider.$type == "A"
    assert record.spec.forProvider.alias.name == "d111abcdef8.cloudfront.net"
    assert record.spec.forProvider.alias.zoneId == "Z2FDTNDATAQYW2"
    assert record.spec.forProvider.alias.evaluateTargetHealth == False
}

test_staticWebsite_no_alias_records_without_zone_or_before_distribution_is_observed = lambda {
    withoutZone = _staticWebsiteOxrFor({
        bucketName = "example-site"
        aliases = ["test.trololo.demotw.com"]
        certificateArn = "arn:aws:acm:us-east-1:123456789012:certificate/abc"
    })
    withZone = _staticWebsiteOxrFor({
        bucketName = "example-site"
        aliases = ["test.trololo.demotw.com"]
        certificateArn = "arn:aws:acm:us-east-1:123456789012:certificate/abc"
        zoneId = "Z0510802PA88E7HZZ597"
    })

    noZoneResult = staticwebsite.composeStaticWebsite(withoutZone, _staticWebsiteAllOcds)
    assert "Record" not in [r.kind for r in noZoneResult]

    beforeDistResult = staticwebsite.composeStaticWebsite(withZone, _staticWebsiteStorageOcds)
    assert "Record" not in [r.kind for r in beforeDistResult]
}
