import json

import .staticwebsite

_siteBaseSpec = {
    bucketName = "test-trololo-demotw-site"
    domainName = "test.trololo.demotw.com"
    region = "us-east-2"
    zoneId = "Z0510802PA88E7HZZ597"
}

_siteBaseOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticWebsite"
    metadata = {name = "test-trololo-site"}
    spec = _siteBaseSpec
}

_siteCertArn = "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"
_siteOacId = "E2OACEXAMPLE"
_siteDistArn = "arn:aws:cloudfront::123456789012:distribution/E1DISTEXAMPLE"
_siteDistDomain = "d111111abcdef8.cloudfront.net"

# Kinds of every resource in a result, in order.
_siteKinds = lambda resources -> [str] {
    [r.kind for r in resources]
}

# The one resource of a given kind.
_siteOfKind = lambda resources, kind -> any {
    [r for r in resources if r.kind == kind][0]
}

# --- Cold start -------------------------------------------------------------

test_site_cold_start_requests_bucket_oac_and_nested_certificate = lambda {
    oxr = {spec = _siteBaseSpec}

    result = staticwebsite.composeStaticWebsite(oxr, {})

    assert _siteKinds(result) == ["Bucket", "OriginAccessControl", "DnsValidatedCertificate"]
}

test_site_cold_start_builds_no_distribution_or_policy_yet = lambda {
    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, {})

    kinds = _siteKinds(result)
    assert "Distribution" not in kinds
    assert "BucketPolicy" not in kinds
    assert "Record" not in kinds
}

test_site_bucket_is_private_and_named_by_external_name = lambda {
    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, {})

    bucket = _siteOfKind(result, "Bucket")
    assert bucket.apiVersion == "s3.aws.m.upbound.io/v1beta1"
    assert bucket.metadata.annotations["crossplane.io/external-name"] == "test-trololo-demotw-site"
    assert bucket.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "bucket"
    assert bucket.spec.forProvider.region == "us-east-2"
}

test_site_origin_access_control_signs_requests_to_s3 = lambda {
    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, {})

    oac = _siteOfKind(result, "OriginAccessControl")
    assert oac.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert oac.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "origin-access-control"
    assert oac.spec.forProvider.originAccessControlOriginType == "s3"
    assert oac.spec.forProvider.signingBehavior == "always"
    assert oac.spec.forProvider.signingProtocol == "sigv4"
}

test_site_nested_certificate_is_in_us_east_1_whatever_the_bucket_region = lambda {
    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, {})

    cert = _siteOfKind(result, "DnsValidatedCertificate")
    assert cert.apiVersion == "platform.demotw.com/v1alpha1"
    assert cert.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "certificate"
    assert cert.spec.domainName == "test.trololo.demotw.com"
    assert cert.spec.zoneId == "Z0510802PA88E7HZZ597"
    # CloudFront only accepts ACM certificates issued in us-east-1.
    assert cert.spec.region == "us-east-1"
}

test_site_passes_tags_to_bucket_when_set = lambda {
    oxr = {spec = {
        bucketName = "test-trololo-demotw-site"
        domainName = "test.trololo.demotw.com"
        region = "us-east-2"
        zoneId = "Z0510802PA88E7HZZ597"
        tags = {team = "web"}
    }}

    result = staticwebsite.composeStaticWebsite(oxr, {})

    assert _siteOfKind(result, "Bucket").spec.forProvider.tags == {team = "web"}
}

# --- Waiting on the certificate and the origin access control ---------------

test_site_waits_for_the_certificate_arn_before_building_the_distribution = lambda {
    ocds = {
        "certificate" = {Resource = {status = {}}}
        "origin-access-control" = {Resource = {status = {atProvider = {id = _siteOacId}}}}
    }

    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, ocds)

    assert "Distribution" not in _siteKinds(result)
}

test_site_waits_for_the_origin_access_control_id_before_building_the_distribution = lambda {
    ocds = {
        "certificate" = {Resource = {status = {certificateArn = _siteCertArn}}}
        "origin-access-control" = {Resource = {status = {atProvider = {}}}}
    }

    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, ocds)

    assert "Distribution" not in _siteKinds(result)
}

# --- Distribution -----------------------------------------------------------

test_site_builds_distribution_once_certificate_and_oac_are_known = lambda {
    ocds = {
        "certificate" = {Resource = {status = {certificateArn = _siteCertArn}}}
        "origin-access-control" = {Resource = {status = {atProvider = {id = _siteOacId}}}}
    }

    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, ocds)

    dist = _siteOfKind(result, "Distribution")
    assert dist.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert dist.spec.forProvider.enabled == True
    assert dist.spec.forProvider.aliases == ["test.trololo.demotw.com"]
    assert dist.spec.forProvider.defaultRootObject == "index.html"
    assert dist.spec.forProvider.viewerCertificate.acmCertificateArn == _siteCertArn
    assert dist.spec.forProvider.viewerCertificate.sslSupportMethod == "sni-only"
    assert dist.spec.forProvider.viewerCertificate.minimumProtocolVersion == "TLSv1.2_2021"
}

test_site_distribution_origin_is_the_bucket_through_oac = lambda {
    ocds = {
        "certificate" = {Resource = {status = {certificateArn = _siteCertArn}}}
        "origin-access-control" = {Resource = {status = {atProvider = {id = _siteOacId}}}}
    }

    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, ocds)

    origin = _siteOfKind(result, "Distribution").spec.forProvider.origin[0]
    assert origin.domainName == "test-trololo-demotw-site.s3.us-east-2.amazonaws.com"
    assert origin.originAccessControlId == _siteOacId
    assert origin.s3OriginConfig.originAccessIdentity == ""
}

test_site_distribution_caches_with_managed_policy_and_forces_https = lambda {
    ocds = {
        "certificate" = {Resource = {status = {certificateArn = _siteCertArn}}}
        "origin-access-control" = {Resource = {status = {atProvider = {id = _siteOacId}}}}
    }

    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, ocds)

    behavior = _siteOfKind(result, "Distribution").spec.forProvider.defaultCacheBehavior
    # AWS managed policy "CachingOptimized".
    assert behavior.cachePolicyId == "658327ea-f89d-4fab-a63d-7e88639e58f6"
    assert behavior.viewerProtocolPolicy == "redirect-to-https"
    assert behavior.targetOriginId == "s3-origin"
}

# --- Bucket policy ----------------------------------------------------------

test_site_bucket_policy_waits_for_the_distribution_arn = lambda {
    ocds = {
        "certificate" = {Resource = {status = {certificateArn = _siteCertArn}}}
        "origin-access-control" = {Resource = {status = {atProvider = {id = _siteOacId}}}}
        "distribution" = {Resource = {status = {atProvider = {domainName = _siteDistDomain}}}}
    }

    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, ocds)

    assert "BucketPolicy" not in _siteKinds(result)
}

test_site_bucket_policy_lets_only_this_distribution_read = lambda {
    ocds = {
        "certificate" = {Resource = {status = {certificateArn = _siteCertArn}}}
        "origin-access-control" = {Resource = {status = {atProvider = {id = _siteOacId}}}}
        "distribution" = {Resource = {status = {atProvider = {arn = _siteDistArn, domainName = _siteDistDomain}}}}
    }

    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, ocds)

    policyResource = _siteOfKind(result, "BucketPolicy")
    assert policyResource.spec.forProvider.bucket == "test-trololo-demotw-site"
    policy = json.decode(policyResource.spec.forProvider.policy)
    statement = policy.Statement[0]
    assert statement.Effect == "Allow"
    assert statement.Principal.Service == "cloudfront.amazonaws.com"
    assert statement.Action == "s3:GetObject"
    assert statement.Resource == "arn:aws:s3:::test-trololo-demotw-site/*"
    assert statement.Condition.StringEquals["AWS:SourceArn"] == _siteDistArn
}

# --- Alias record and status ------------------------------------------------

test_site_no_alias_or_status_until_distribution_domain_is_observed = lambda {
    ocds = {
        "certificate" = {Resource = {status = {certificateArn = _siteCertArn}}}
        "origin-access-control" = {Resource = {status = {atProvider = {id = _siteOacId}}}}
        "distribution" = {Resource = {status = {atProvider = {arn = _siteDistArn}}}}
    }

    result = staticwebsite.composeStaticWebsite({spec = _siteBaseSpec}, ocds)

    kinds = _siteKinds(result)
    assert "Record" not in kinds
    assert "StaticWebsite" not in kinds
}

test_site_creates_alias_record_and_reports_status_once_distribution_domain_is_observed = lambda {
    ocds = {
        "certificate" = {Resource = {status = {certificateArn = _siteCertArn}}}
        "origin-access-control" = {Resource = {status = {atProvider = {id = _siteOacId}}}}
        "distribution" = {Resource = {status = {atProvider = {arn = _siteDistArn, domainName = _siteDistDomain}}}}
    }

    result = staticwebsite.composeStaticWebsite(_siteBaseOxr, ocds)

    record = _siteOfKind(result, "Record")
    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.spec.forProvider.zoneId == "Z0510802PA88E7HZZ597"
    assert record.spec.forProvider.name == "test.trololo.demotw.com"
    assert record.spec.forProvider.$type == "A"
    assert record.spec.forProvider.alias.name == _siteDistDomain
    # CloudFront's fixed hosted zone ID, used by every alias to a distribution.
    assert record.spec.forProvider.alias.zoneId == "Z2FDTNDATAQYW2"

    xr = _siteOfKind(result, "StaticWebsite")
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.metadata.name == "test-trololo-site"
    assert xr.status.cloudFrontDomainName == _siteDistDomain
}

# --- Spec pass-through ------------------------------------------------------

test_site_tolerates_extra_fields_the_real_control_plane_injects = lambda {
    oxr = {
        spec = {
            bucketName = "test-trololo-demotw-site"
            domainName = "test.trololo.demotw.com"
            region = "us-east-2"
            zoneId = "Z0510802PA88E7HZZ597"
            crossplane = {compositionRef = {name = "staticwebsite-demotw"}}
        }
    }

    result = staticwebsite.composeStaticWebsite(oxr, {})

    assert len(result) == 3
}
