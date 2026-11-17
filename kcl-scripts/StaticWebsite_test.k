import json
import .staticwebsite

_staticWebsiteBaseOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticWebsite"
    metadata.name = "example"
    spec = {
        domainName = "www.example.com"
        bucketName = "example-bucket"
    }
}

_staticWebsiteZonedOxr = _staticWebsiteBaseOxr | {spec: {zoneId = "Z0510802PA88E7HZZ597"}}

_staticWebsiteCertArn = "arn:aws:acm:us-east-1:123456789012:certificate/abc"

# ACM has published the DNS validation record but not issued the certificate.
_staticWebsiteObservedCertPending = {
    "certificate" = {
        Resource.status.atProvider = {
            arn = _staticWebsiteCertArn
            status = "PENDING_VALIDATION"
            domainValidationOptions = [{
                domainName = "www.example.com"
                resourceRecordName = "_abc.www.example.com."
                resourceRecordType = "CNAME"
                resourceRecordValue = "_xyz.acm-validations.aws."
            }]
        }
    }
}

_staticWebsiteObservedCertIssued = {
    "certificate" = {
        Resource.status.atProvider = _staticWebsiteObservedCertPending.certificate.Resource.status.atProvider | {status = "ISSUED"}
    }
}

_staticWebsiteObservedDistribution = {
    "distribution" = {
        Resource.status.atProvider = {
            arn = "arn:aws:cloudfront::123456789012:distribution/E1234567890"
            domainName = "d111111abcdef8.cloudfront.net"
            hostedZoneId = "Z2FDTNDATAQYW2"
        }
    }
}

_staticWebsiteFullyObserved = _staticWebsiteObservedCertIssued | _staticWebsiteObservedDistribution

_staticWebsiteByName = lambda result: [any] -> {str:any} {
    {r.metadata.annotations["krm.kcl.dev/composition-resource-name"]: r for r in result if "annotations" in r.metadata}
}

# --- Without a zone: no custom domain, so no certificate. ---

test_cold_start_without_zone_emits_four_resources = lambda {
    byName = _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteBaseOxr, {}))

    assert sorted(byName) == ["bucket", "distribution", "oac", "policy"]
}

test_without_zone_distribution_uses_default_certificate = lambda {
    forProvider = _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteBaseOxr, {}))["distribution"].spec.forProvider

    assert forProvider.viewerCertificate.cloudfrontDefaultCertificate == True
    assert not forProvider.aliases, "an alias without a matching ACM certificate is rejected by CloudFront"
}

# --- Provider config ---

test_every_resource_uses_pod_identity_by_default = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteZonedOxr, _staticWebsiteFullyObserved)
    composed = [r for r in result if r.kind != "StaticWebsite"]

    assert len(composed) == 8
    assert all r in composed {
        r.spec.providerConfigRef == {kind = "ClusterProviderConfig", name = "pod-identity"}
    }, "every composed resource must reference the pod-identity ClusterProviderConfig"
}

test_provider_config_can_be_overridden = lambda {
    oxr = _staticWebsiteBaseOxr | {spec: {providerConfigName = "other"}}
    result = staticwebsite.composeStaticWebsite(oxr, {})

    assert all r in result {
        r.spec.providerConfigRef.name == "other"
    }
}

# A namespaced XR may only compose namespaced resources. Upbound ships both a
# cluster-scoped group (<svc>.aws.upbound.io) and a namespaced one
# (<svc>.aws.m.upbound.io); every resource here must come from the latter.
test_all_resources_use_namespaced_api_groups = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteZonedOxr, _staticWebsiteFullyObserved)

    assert all r in [r for r in result if r.kind != "StaticWebsite"] {
        ".aws.m.upbound.io/" in r.apiVersion
    }, "every composed resource must use an .aws.m.upbound.io (namespaced) API group"
}

# --- Bucket, OAC, policy ---

test_bucket_names_itself_via_external_name = lambda {
    bucket = _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteBaseOxr, {}))["bucket"]

    assert "bucket" not in bucket.spec.forProvider, "forProvider.bucket is not in the namespaced Bucket schema"
    assert bucket.metadata.annotations["crossplane.io/external-name"] == "example-bucket"
    assert bucket.spec.forProvider.region == "us-east-1", "region is required and should default"
}

test_region_and_tags_flow_through = lambda {
    oxr = _staticWebsiteBaseOxr | {spec: {region = "eu-west-1", tags = {env = "prod"}}}
    byName = _staticWebsiteByName(staticwebsite.composeStaticWebsite(oxr, {}))

    assert byName["bucket"].spec.forProvider.region == "eu-west-1"
    assert byName["policy"].spec.forProvider.region == "eu-west-1"
    assert byName["bucket"].spec.forProvider.tags == {env = "prod"}
    assert "eu-west-1" in byName["distribution"].spec.forProvider.origin[0].domainName
}

test_distribution_reads_bucket_through_the_oac = lambda {
    byName = _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteBaseOxr, {}))

    assert byName["distribution"].spec.forProvider.origin[0].originAccessControlIdRef.name == byName["oac"].metadata.name
    assert byName["oac"].spec.forProvider.originAccessControlOriginType == "s3"
}

test_index_and_error_documents = lambda {
    oxr = _staticWebsiteBaseOxr | {spec: {indexDocument = "home.html", errorDocument = "oops.html"}}
    forProvider = _staticWebsiteByName(staticwebsite.composeStaticWebsite(oxr, {}))["distribution"].spec.forProvider

    assert forProvider.defaultRootObject == "home.html"
    assert forProvider.customErrorResponse[0].responsePagePath == "/oops.html"
}

test_defaults_index_and_error_documents = lambda {
    forProvider = _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteBaseOxr, {}))["distribution"].spec.forProvider

    assert forProvider.defaultRootObject == "index.html"
    assert forProvider.customErrorResponse[0].responsePagePath == "/404.html"
}

test_policy_is_a_json_string_without_source_arn_when_unobserved = lambda {
    policy = _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteBaseOxr, {}))["policy"].spec.forProvider.policy

    assert typeof(policy) == "str", "the namespaced BucketPolicy takes a JSON string"
    document = json.decode(policy)
    assert document.Statement[0].Resource == "arn:aws:s3:::example-bucket/*"
    assert "Condition" not in document.Statement[0]
}

test_policy_restricts_to_distribution_once_observed = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteBaseOxr, _staticWebsiteObservedDistribution)
    document = json.decode(_staticWebsiteByName(result)["policy"].spec.forProvider.policy)

    assert document.Statement[0].Condition.StringEquals["AWS:SourceArn"] == "arn:aws:cloudfront::123456789012:distribution/E1234567890"
}

# --- With a zone: certificate stages ---

test_zoned_cold_start_requests_a_certificate_and_waits = lambda {
    oxr = _staticWebsiteZonedOxr | {spec: {region = "eu-west-1"}}
    byName = _staticWebsiteByName(staticwebsite.composeStaticWebsite(oxr, {}))

    assert sorted(byName) == ["bucket", "certificate", "oac", "policy"]
    cert = byName["certificate"].spec.forProvider
    assert cert.domainName == "www.example.com"
    assert cert.validationMethod == "DNS"
    assert cert.region == "us-east-1", "CloudFront only accepts certificates from us-east-1"
}

test_validation_record_once_acm_publishes_it = lambda {
    byName = _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteZonedOxr, _staticWebsiteObservedCertPending))

    record = byName["cert-validation-record"].spec.forProvider
    assert record.zoneId == "Z0510802PA88E7HZZ597"
    assert record.name == "_abc.www.example.com."
    assert record.type == "CNAME"
    assert record.records == ["_xyz.acm-validations.aws."]
    assert record.allowOverwrite == True

    validation = byName["cert-validation"].spec.forProvider
    assert validation.certificateArnRef.name == byName["certificate"].metadata.name
    assert validation.validationRecordFqdns == ["_abc.www.example.com."]
    assert validation.region == "us-east-1"

    assert "distribution" not in byName, "the distribution waits for an issued certificate"
}

test_distribution_uses_certificate_once_issued = lambda {
    byName = _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteZonedOxr, _staticWebsiteObservedCertIssued))
    forProvider = byName["distribution"].spec.forProvider

    assert forProvider.aliases == ["www.example.com"]
    assert forProvider.viewerCertificate.acmCertificateArn == _staticWebsiteCertArn
    assert forProvider.viewerCertificate.sslSupportMethod == "sni-only"
    assert forProvider.viewerCertificate.minimumProtocolVersion == "TLSv1.2_2021"
    assert "dns" not in byName, "the alias record waits for the distribution"
}

# The Certificate's observed status lags until the provider's next poll, but the
# CertificateValidation only becomes Ready once ACM has issued the certificate.
test_distribution_proceeds_when_validation_is_ready = lambda {
    ocds = _staticWebsiteObservedCertPending | {
        "cert-validation" = {Resource.status.conditions = [{$type = "Ready", status = "True"}]}
    }
    byName = _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteZonedOxr, ocds))

    assert "distribution" in byName
    assert byName["distribution"].spec.forProvider.viewerCertificate.acmCertificateArn == _staticWebsiteCertArn
}

test_distribution_waits_while_validation_is_not_ready = lambda {
    ocds = _staticWebsiteObservedCertPending | {
        "cert-validation" = {Resource.status.conditions = [{$type = "Ready", status = "False"}]}
    }
    assert "distribution" not in _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteZonedOxr, ocds))
}

test_dns_record_aliases_the_distribution = lambda {
    forProvider = _staticWebsiteByName(staticwebsite.composeStaticWebsite(_staticWebsiteZonedOxr, _staticWebsiteFullyObserved))["dns"].spec.forProvider

    assert forProvider.zoneId == "Z0510802PA88E7HZZ597"
    assert forProvider.name == "www.example.com"
    assert forProvider.type == "A", "`type` is reserved in KCL and must serialise back to `type`"
    assert forProvider.alias.name == "d111111abcdef8.cloudfront.net"
    assert forProvider.alias.zoneId == "Z2FDTNDATAQYW2"
}

# --- Status ---

test_status_with_custom_domain = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteZonedOxr, _staticWebsiteFullyObserved)
    xrs = [r for r in result if r.kind == "StaticWebsite"]

    assert len(xrs) == 1
    assert xrs[0].status.url == "https://www.example.com"
    assert xrs[0].status.distributionDomainName == "d111111abcdef8.cloudfront.net"
    assert xrs[0].status.certificateArn == _staticWebsiteCertArn
}

test_status_without_custom_domain_points_at_cloudfront = lambda {
    xrs = [r for r in staticwebsite.composeStaticWebsite(_staticWebsiteBaseOxr, _staticWebsiteObservedDistribution) if r.kind == "StaticWebsite"]

    assert xrs[0].status.url == "https://d111111abcdef8.cloudfront.net"
}

test_no_status_before_the_distribution_exists = lambda {
    result = staticwebsite.composeStaticWebsite(_staticWebsiteBaseOxr, {})
    assert len([r for r in result if r.kind == "StaticWebsite"]) == 0
}

test_extra_spec_fields_are_accepted = lambda {
    oxr = _staticWebsiteBaseOxr | {spec: {somethingCrossplaneAdded = "ok"}}
    assert len(staticwebsite.composeStaticWebsite(oxr, {})) == 4
}
