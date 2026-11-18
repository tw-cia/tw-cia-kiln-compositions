import .tlscertificate
import .schemas_compositions

_tlsCertOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "TlsCertificate"
    metadata = {name = "site-cert"}
    spec = {domainName = "www.example.com", hostedZoneId = "Z0123456789ABCDEFGHIJ"}
}

_tlsCertArn = "arn:aws:acm:us-east-1:111111111111:certificate/example"

_tlsCertOption = {
    domainName = "www.example.com"
    resourceRecordName = "_abc123.www.example.com"
    resourceRecordType = "CNAME"
    resourceRecordValue = "_def456.acm-validations.aws."
}

_tlsCertOcdsEmptyAtProvider = {certificate = {Resource = {status = {atProvider = {}}}}}

_tlsCertOcdsArnOnly = {certificate = {Resource = {status = {atProvider = {arn = _tlsCertArn}}}}}

_tlsCertOcdsWithOptions = {
    certificate = {Resource = {status = {atProvider = {
        arn = _tlsCertArn
        domainValidationOptions = [_tlsCertOption]
    }}}}
}

_tlsCertOcdsValidated = {
    certificate = {Resource = {status = {atProvider = {
        arn = _tlsCertArn
        domainValidationOptions = [_tlsCertOption]
    }}}}
    "certificate-validation" = {Resource = {status = {conditions = [{"type" = "Ready", status = "True"}]}}}
}

_tlsCertOcdsNotReady = {
    certificate = {Resource = {status = {atProvider = {
        arn = _tlsCertArn
        domainValidationOptions = [_tlsCertOption]
    }}}}
    "certificate-validation" = {Resource = {status = {conditions = [{"type" = "Ready", status = "False"}]}}}
}

# The composed resources (everything but the XR status item), and the XR status item.
_tlsCertComposed = lambda resources {
    [r for r in resources if r.kind != "TlsCertificate"]
}

_tlsCertXr = lambda resources {
    [r for r in resources if r.kind == "TlsCertificate"]
}

_tlsCertNamed = lambda resources, name {
    [r for r in _tlsCertComposed(resources) if r.metadata.annotations["krm.kcl.dev/composition-resource-name"] == name]
}

test_tlsCertificate_cold_start_emits_only_the_certificate = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertOxr, {})

    assert len(_tlsCertComposed(result)) == 1, "cold start should emit only the certificate"
    assert len(_tlsCertXr(result)) == 0, "cold start should report no status"
}

test_tlsCertificate_requests_a_dns_validated_certificate = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertOxr, {})
    cert = _tlsCertNamed(result, "certificate")[0]

    assert cert.apiVersion == "acm.aws.m.upbound.io/v1beta1"
    assert cert.kind == "Certificate"
    assert cert.spec.forProvider.domainName == "www.example.com"
    assert cert.spec.forProvider.validationMethod == "DNS"
    assert cert.spec.forProvider.region == "us-east-1", "region should default to us-east-1 for CloudFront"
}

test_tlsCertificate_uses_the_region_it_is_given = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "TlsCertificate"
        metadata = {name = "site-cert"}
        spec = {domainName = "www.example.com", hostedZoneId = "Z0123456789ABCDEFGHIJ", region = "eu-west-1"}
    }
    result = tlscertificate.composeTlsCertificate(oxr, {})
    cert = _tlsCertNamed(result, "certificate")[0]

    assert cert.spec.forProvider.region == "eu-west-1"
}

test_tlsCertificate_empty_atProvider_is_still_cold_start = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertOxr, _tlsCertOcdsEmptyAtProvider)

    assert len(_tlsCertComposed(result)) == 1, "an observed certificate with no atProvider yet adds nothing"
    assert len(_tlsCertXr(result)) == 0, "no status before the certificate has an ARN"
}

test_tlsCertificate_arn_observed_reports_status_without_validation = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertOxr, _tlsCertOcdsArnOnly)
    xr = _tlsCertXr(result)[0]

    assert len(_tlsCertComposed(result)) == 1, "no validation record until ACM lists the validation options"
    assert xr.status.certificateArn == _tlsCertArn
    assert xr.status.validated == False
}

test_tlsCertificate_options_known_emits_validation_record_and_wait = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertOxr, _tlsCertOcdsWithOptions)

    assert len(_tlsCertComposed(result)) == 3, "expected certificate, validation record and certificate validation"
    assert len(_tlsCertNamed(result, "validation-record")) == 1
    assert len(_tlsCertNamed(result, "certificate-validation")) == 1
}

test_tlsCertificate_validation_record_is_a_cname_in_the_hosted_zone = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertOxr, _tlsCertOcdsWithOptions)
    record = _tlsCertNamed(result, "validation-record")[0]

    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.kind == "Record"
    assert record.spec.forProvider.zoneId == "Z0123456789ABCDEFGHIJ"
    assert record.spec.forProvider.name == "_abc123.www.example.com"
    assert record.spec.forProvider.$type == "CNAME"
    assert record.spec.forProvider.records == ["_def456.acm-validations.aws."]
    assert record.spec.forProvider.ttl == 60
}

test_tlsCertificate_certificate_validation_waits_on_the_record = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertOxr, _tlsCertOcdsWithOptions)
    validation = _tlsCertNamed(result, "certificate-validation")[0]

    assert validation.apiVersion == "acm.aws.m.upbound.io/v1beta1"
    assert validation.kind == "CertificateValidation"
    assert validation.spec.forProvider.certificateArn == _tlsCertArn
    assert validation.spec.forProvider.validationRecordFqdns == ["_abc123.www.example.com"]
    assert validation.spec.forProvider.region == "us-east-1"
}

test_tlsCertificate_not_validated_until_the_validation_is_ready = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertOxr, _tlsCertOcdsNotReady)
    xr = _tlsCertXr(result)[0]

    assert xr.status.certificateArn == _tlsCertArn
    assert xr.status.validated == False
}

test_tlsCertificate_reports_validated_once_the_validation_is_ready = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertOxr, _tlsCertOcdsValidated)
    xr = _tlsCertXr(result)[0]

    assert xr.kind == "TlsCertificate"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.status.certificateArn == _tlsCertArn
    assert xr.status.validated == True
}

test_tlsCertificate_spec_accepts_a_valid_spec = lambda {
    spec = schemas_compositions.TlsCertificateSpec {
        domainName = "www.example.com"
        hostedZoneId = "Z0123456789ABCDEFGHIJ"
    }

    assert spec.region == "us-east-1"
}
