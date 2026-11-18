import json
import .staticwebsite

_siteDomain = "test.trololo.demotw.com"
_siteZone = "Z0510802PA88E7HZZ597"
_siteCertArn = "arn:aws:acm:us-east-1:111122223333:certificate/site-123"
_siteBucket = "test-trololo-demotw-com"
_siteNameKey = "krm.kcl.dev/composition-resource-name"
_siteDistArn = "arn:aws:cloudfront::111122223333:distribution/EDIST123"

_siteBaseOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticWebsite"
    metadata.name = "test-site"
    spec = {
        domainName = _siteDomain
        hostedZoneId = _siteZone
    }
}

_siteWithCertOxr = {
    apiVersion = _siteBaseOxr.apiVersion
    kind = _siteBaseOxr.kind
    metadata.name = _siteBaseOxr.metadata.name
    spec = _siteBaseOxr.spec | {certificateArn = _siteCertArn}
}

# Observed composed resources, as ocds holds them.
_siteBucketObs = {Resource = {status = {atProvider = {
    arn = "arn:aws:s3:::test-trololo-demotw-com"
    bucketRegionalDomainName = "test-trololo-demotw-com.s3.us-east-1.amazonaws.com"
}}}}
_siteBucketEmpty = {Resource = {status = {atProvider = {}}}}
_siteOacObs = {Resource = {status = {atProvider = {id = "E2OACEXAMPLE"}}}}
_siteCertObs = {Resource = {status = {arn = _siteCertArn, validated = True}}}
_siteCertPending = {Resource = {status = {arn = _siteCertArn, validated = False}}}
_siteDistObs = {Resource = {status = {atProvider = {
    id = "EDIST123"
    arn = _siteDistArn
    domainName = "d111111abcdef8.cloudfront.net"
}}}}

_siteKindOf = lambda resources, kind -> [any] {
    [r for r in resources if r.kind == kind]
}

_siteNamed = lambda resources, name -> [any] {
    [r for r in resources if r.kind != "StaticWebsite" and r.metadata.annotations[_siteNameKey] == name]
}

test_site_cold_start_composes_bucket_access_block_and_oac = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {})

    assert len(_siteNamed(result, "bucket")) == 1
    assert len(_siteNamed(result, "publicAccessBlock")) == 1
    assert len(_siteNamed(result, "originAccessControl")) == 1
    assert len(result) == 3, "cold start with a certificate ARN composes only the bucket, its block and the OAC"
}

test_site_composes_a_certificate_xr_when_no_arn_is_given = lambda {
    result = staticwebsite.composeStaticWebsite(_siteBaseOxr, {})
    certs = _siteNamed(result, "certificate")

    assert len(certs) == 1
    cert = certs[0]
    assert cert.apiVersion == "platform.demotw.com/v1alpha1"
    assert cert.kind == "Certificate"
    assert cert.spec.domainName == _siteDomain
    assert cert.spec.hostedZoneId == _siteZone
    assert cert.spec.region == "us-east-1"
}

test_site_does_not_compose_a_certificate_when_an_arn_is_given = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {})

    assert len(_siteKindOf(result, "Certificate")) == 0
}

test_site_bucket_name_defaults_to_the_domain_with_hyphens = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {})
    bucket = _siteNamed(result, "bucket")[0]

    assert bucket.apiVersion == "s3.aws.m.upbound.io/v1beta1"
    assert bucket.metadata.annotations["crossplane.io/external-name"] == _siteBucket
    assert bucket.spec.forProvider.region == "us-east-1"
}

test_site_bucket_name_can_be_set = lambda {
    oxr = {
        apiVersion = _siteBaseOxr.apiVersion
        kind = _siteBaseOxr.kind
        metadata.name = _siteBaseOxr.metadata.name
        spec = _siteWithCertOxr.spec | {bucketName = "my-site-bucket"}
    }
    result = staticwebsite.composeStaticWebsite(oxr, {})
    bucket = _siteNamed(result, "bucket")[0]

    assert bucket.metadata.annotations["crossplane.io/external-name"] == "my-site-bucket"
}

test_site_public_access_block_blocks_all_public_access = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {})
    block = _siteNamed(result, "publicAccessBlock")[0]

    assert block.apiVersion == "s3.aws.m.upbound.io/v1beta1"
    assert block.kind == "BucketPublicAccessBlock"
    assert block.spec.forProvider.bucket == _siteBucket
    assert block.spec.forProvider.blockPublicAcls
    assert block.spec.forProvider.blockPublicPolicy
    assert block.spec.forProvider.ignorePublicAcls
    assert block.spec.forProvider.restrictPublicBuckets
}

test_site_origin_access_control_signs_requests_to_s3 = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {})
    oac = _siteNamed(result, "originAccessControl")[0]

    assert oac.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert oac.kind == "OriginAccessControl"
    assert oac.spec.forProvider.originAccessControlOriginType == "s3"
    assert oac.spec.forProvider.signingBehavior == "always"
    assert oac.spec.forProvider.signingProtocol == "sigv4"
}

test_site_distribution_waits_for_bucket_and_oac = lambda {
    noBucket = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        originAccessControl = _siteOacObs
    })
    emptyBucket = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        bucket = _siteBucketEmpty
        originAccessControl = _siteOacObs
    })
    noOac = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        bucket = _siteBucketObs
    })

    assert len(_siteKindOf(noBucket, "Distribution")) == 0
    assert len(_siteKindOf(emptyBucket, "Distribution")) == 0
    assert len(_siteKindOf(noOac, "Distribution")) == 0
}

test_site_distribution_waits_for_the_certificate_to_validate = lambda {
    result = staticwebsite.composeStaticWebsite(_siteBaseOxr, {
        bucket = _siteBucketObs
        originAccessControl = _siteOacObs
        certificate = _siteCertPending
    })

    assert len(_siteKindOf(result, "Distribution")) == 0
}

test_site_distribution_serves_the_bucket_through_oac = lambda {
    result = staticwebsite.composeStaticWebsite(_siteBaseOxr, {
        bucket = _siteBucketObs
        originAccessControl = _siteOacObs
        certificate = _siteCertObs
    })
    dists = _siteKindOf(result, "Distribution")

    assert len(dists) == 1
    fp = dists[0].spec.forProvider
    assert fp.enabled
    assert fp.aliases == [_siteDomain]
    assert fp.defaultRootObject == "index.html"
    assert fp.origin[0].domainName == "test-trololo-demotw-com.s3.us-east-1.amazonaws.com"
    assert fp.origin[0].originAccessControlId == "E2OACEXAMPLE"
    assert fp.defaultCacheBehavior.targetOriginId == fp.origin[0].originId
    assert fp.defaultCacheBehavior.viewerProtocolPolicy == "redirect-to-https"
    assert fp.viewerCertificate.acmCertificateArn == _siteCertArn
    assert fp.viewerCertificate.sslSupportMethod == "sni-only"
    assert fp.viewerCertificate.minimumProtocolVersion == "TLSv1.2_2021"
    assert fp.restrictions.geoRestriction.restrictionType == "none"
}

test_site_distribution_uses_a_given_certificate_arn = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        bucket = _siteBucketObs
        originAccessControl = _siteOacObs
    })
    dists = _siteKindOf(result, "Distribution")

    assert len(dists) == 1
    assert dists[0].spec.forProvider.viewerCertificate.acmCertificateArn == _siteCertArn
}

test_site_bucket_policy_waits_for_the_distribution_arn = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        bucket = _siteBucketObs
        originAccessControl = _siteOacObs
    })

    assert len(_siteKindOf(result, "BucketPolicy")) == 0
}

test_site_bucket_policy_only_lets_the_distribution_read = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        bucket = _siteBucketObs
        originAccessControl = _siteOacObs
        distribution = _siteDistObs
    })
    policies = _siteKindOf(result, "BucketPolicy")

    assert len(policies) == 1
    fp = policies[0].spec.forProvider
    assert fp.bucket == _siteBucket
    assert fp.region == "us-east-1"
    statement = json.decode(fp.policy).Statement[0]
    assert statement.Effect == "Allow"
    assert statement.Principal.Service == "cloudfront.amazonaws.com"
    assert statement.Action == "s3:GetObject"
    assert statement.Resource == "arn:aws:s3:::test-trololo-demotw-com/*"
    assert statement.Condition.StringEquals["AWS:SourceArn"] == _siteDistArn
}

test_site_alias_record_waits_for_the_distribution_domain = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        bucket = _siteBucketObs
        originAccessControl = _siteOacObs
    })

    assert len(_siteNamed(result, "aliasRecord")) == 0
}

test_site_alias_record_points_the_domain_at_the_distribution = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        bucket = _siteBucketObs
        originAccessControl = _siteOacObs
        distribution = _siteDistObs
    })
    records = _siteNamed(result, "aliasRecord")

    assert len(records) == 1
    fp = records[0].spec.forProvider
    assert records[0].apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert fp.zoneId == _siteZone
    assert fp.name == _siteDomain
    assert fp.$type == "A"
    assert fp.alias.name == "d111111abcdef8.cloudfront.net"
    assert fp.alias.zoneId == "Z2FDTNDATAQYW2"
    assert not fp.alias.evaluateTargetHealth
}

test_site_reports_no_status_until_the_distribution_exists = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        bucket = _siteBucketObs
        originAccessControl = _siteOacObs
    })

    assert len(_siteKindOf(result, "StaticWebsite")) == 0
    assert len([r for r in result if r.kind == "StaticWebsite"]) == 0
}

test_site_reports_url_and_distribution_once_it_exists = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        bucket = _siteBucketObs
        originAccessControl = _siteOacObs
        distribution = _siteDistObs
    })
    xrs = [r for r in result if r.kind == "StaticWebsite"]

    assert len(xrs) == 1
    assert xrs[0].metadata.name == "test-site"
    assert xrs[0].status.url == "https://test.trololo.demotw.com"
    assert xrs[0].status.distributionDomainName == "d111111abcdef8.cloudfront.net"
    assert xrs[0].status.certificateArn == _siteCertArn
}

test_site_composes_the_whole_site_once_fully_observed = lambda {
    result = staticwebsite.composeStaticWebsite(_siteWithCertOxr, {
        bucket = _siteBucketObs
        originAccessControl = _siteOacObs
        distribution = _siteDistObs
    })

    assert len(result) == 7, "bucket, block, OAC, distribution, policy, alias record and the status"
}

test_site_tolerates_unknown_spec_fields = lambda {
    oxr = {
        apiVersion = _siteBaseOxr.apiVersion
        kind = _siteBaseOxr.kind
        metadata.name = _siteBaseOxr.metadata.name
        spec = _siteWithCertOxr.spec | {crossplane = {}}
    }
    result = staticwebsite.composeStaticWebsite(oxr, {})

    assert len(result) == 3
}
