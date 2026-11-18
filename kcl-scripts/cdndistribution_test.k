import .cdndistribution
import .schemas_compositions

_cdnOrigin = "web.example.com"

_cdnOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "CdnDistribution"
    metadata = {name = "site-cdn"}
    spec = {originDomainName = _cdnOrigin}
}

_cdnCertArn = "arn:aws:acm:us-east-1:111111111111:certificate/0123abcd"

_cdnObservedNoDomain = {distribution = {Resource = {status = {atProvider = {}}}}}

_cdnObserved = {distribution = {Resource = {status = {atProvider = {
    arn = "arn:aws:cloudfront::111111111111:distribution/E2EXAMPLE"
    domainName = "d111111abcdef8.cloudfront.net"
}}}}}

_cdnComposed = lambda resources {
    [r for r in resources if r.kind != "CdnDistribution"]
}

_cdnXr = lambda resources {
    [r for r in resources if r.kind == "CdnDistribution"]
}

test_cdnDistribution_emits_one_distribution_cold = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnOxr, {})
    dist = _cdnComposed(result)[0]

    assert len(_cdnComposed(result)) == 1
    assert len(_cdnXr(result)) == 0, "cold start reports no status"
    assert dist.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert dist.kind == "Distribution"
    assert dist.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "distribution"
}

test_cdnDistribution_origin_is_the_fleet_domain_over_https = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnOxr, {})
    origin = _cdnComposed(result)[0].spec.forProvider.origin[0]

    assert origin.domainName == _cdnOrigin, "the fleet's domain, which its certificate covers"
    assert origin.originId == "alb-origin"
    assert origin.customOriginConfig.originProtocolPolicy == "https-only", "the fleet redirects HTTP to HTTPS, so the origin is reached over HTTPS"
    assert origin.customOriginConfig.httpsPort == 443
    assert origin.customOriginConfig.originSslProtocols == ["TLSv1.2"]
}

test_cdnDistribution_default_behaviour_redirects_to_https_and_forwards_everything = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnOxr, {})
    behaviour = _cdnComposed(result)[0].spec.forProvider.defaultCacheBehavior

    assert behaviour.targetOriginId == "alb-origin"
    assert behaviour.viewerProtocolPolicy == "redirect-to-https"
    assert behaviour.cachePolicyId == "4135ea2d-6df8-44a3-9df3-4b5a84be39ad", "CachingDisabled managed policy"
    assert behaviour.originRequestPolicyId == "216adef6-5c7f-47e4-b989-5492eafa07d3", "AllViewer managed policy"
    assert "POST" in behaviour.allowedMethods, "a dynamic origin needs every method"
}

test_cdnDistribution_price_class_defaults_and_passes_through = lambda {
    cheap = cdndistribution.composeCdnDistribution(_cdnOxr, {})
    assert _cdnComposed(cheap)[0].spec.forProvider.priceClass == "PriceClass_100"

    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "CdnDistribution"
        metadata = {name = "site-cdn"}
        spec = {originDomainName = _cdnOrigin, priceClass = "PriceClass_All"}
    }
    result = cdndistribution.composeCdnDistribution(oxr, {})

    assert _cdnComposed(result)[0].spec.forProvider.priceClass == "PriceClass_All"
}

test_cdnDistribution_without_aliases_uses_the_cloudfront_certificate = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnOxr, {})
    forProvider = _cdnComposed(result)[0].spec.forProvider

    assert forProvider.viewerCertificate.cloudfrontDefaultCertificate == True
    assert not forProvider.viewerCertificate.acmCertificateArn, "no ACM certificate without aliases"
    assert not forProvider.aliases, "no aliases set"
    assert forProvider.enabled == True
}

test_cdnDistribution_with_aliases_uses_the_acm_certificate = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "CdnDistribution"
        metadata = {name = "site-cdn"}
        spec = {originDomainName = _cdnOrigin, aliases = ["www.example.com"], certificateArn = _cdnCertArn}
    }
    result = cdndistribution.composeCdnDistribution(oxr, {})
    forProvider = _cdnComposed(result)[0].spec.forProvider

    assert forProvider.aliases == ["www.example.com"]
    assert forProvider.viewerCertificate.acmCertificateArn == _cdnCertArn
    assert forProvider.viewerCertificate.sslSupportMethod == "sni-only"
    assert forProvider.viewerCertificate.minimumProtocolVersion == "TLSv1.2_2021"
    assert not forProvider.viewerCertificate.cloudfrontDefaultCertificate
}

test_cdnDistribution_no_status_until_the_domain_name_is_observed = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnOxr, _cdnObservedNoDomain)

    assert len(_cdnXr(result)) == 0, "an atProvider with no domain name yet reports nothing"
}

test_cdnDistribution_reports_domain_name_and_arn_once_observed = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnOxr, _cdnObserved)
    xr = _cdnXr(result)[0]

    assert xr.kind == "CdnDistribution"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.status.domainName == "d111111abcdef8.cloudfront.net"
    assert xr.status.distributionArn == "arn:aws:cloudfront::111111111111:distribution/E2EXAMPLE"
}

test_cdnDistribution_spec_accepts_aliases_with_a_certificate = lambda {
    spec = schemas_compositions.CdnDistributionSpec {
        originDomainName = _cdnOrigin
        aliases = ["www.example.com"]
        certificateArn = _cdnCertArn
    }

    assert spec.priceClass == "PriceClass_100"
}

_cdnAliasOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "CdnDistribution"
    metadata = {name = "site-cdn"}
    spec = {
        originDomainName = _cdnOrigin
        aliases = ["kiln-test.demotw.com"]
        certificateArn = _cdnCertArn
        hostedZoneId = "Z0182862241741A14JZDA"
    }
}

test_cdnDistribution_alias_record_is_not_emitted_before_the_distribution_is_observed = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnAliasOxr, {})

    assert len(_cdnComposed(result)) == 1, "only the distribution until CloudFront reports its domain name"
}

test_cdnDistribution_emits_an_alias_record_once_the_distribution_is_observed = lambda {
    result = cdndistribution.composeCdnDistribution(_cdnAliasOxr, _cdnObserved)
    records = [r for r in _cdnComposed(result) if r.kind == "Record"]

    assert len(records) == 1
    record = records[0]
    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "alias-record-0"
    assert record.spec.forProvider.zoneId == "Z0182862241741A14JZDA"
    assert record.spec.forProvider.name == "kiln-test.demotw.com"
    assert record.spec.forProvider.$type == "A"
    assert record.spec.forProvider.alias.name == "d111111abcdef8.cloudfront.net"
    assert record.spec.forProvider.alias.zoneId == "Z2FDTNDATAQYW2", "CloudFront's fixed hosted zone ID"
    assert record.spec.forProvider.alias.evaluateTargetHealth == False
}

test_cdnDistribution_no_alias_record_without_a_hosted_zone = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "CdnDistribution"
        metadata = {name = "site-cdn"}
        spec = {originDomainName = _cdnOrigin, aliases = ["kiln-test.demotw.com"], certificateArn = _cdnCertArn}
    }
    result = cdndistribution.composeCdnDistribution(oxr, _cdnObserved)

    assert len([r for r in _cdnComposed(result) if r.kind == "Record"]) == 0, "no zone, no record"
}

test_cdnDistribution_one_alias_record_per_alias = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "CdnDistribution"
        metadata = {name = "site-cdn"}
        spec = {
            originDomainName = _cdnOrigin
            aliases = ["kiln-test.demotw.com", "www.kiln-test.demotw.com"]
            certificateArn = _cdnCertArn
            hostedZoneId = "Z0182862241741A14JZDA"
        }
    }
    result = cdndistribution.composeCdnDistribution(oxr, _cdnObserved)
    records = [r for r in _cdnComposed(result) if r.kind == "Record"]

    assert len(records) == 2
    assert records[1].metadata.annotations["krm.kcl.dev/composition-resource-name"] == "alias-record-1"
    assert records[1].spec.forProvider.name == "www.kiln-test.demotw.com"
}
