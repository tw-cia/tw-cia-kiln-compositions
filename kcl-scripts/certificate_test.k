import .certificate

_certificateZone = "Z0510802PA88E7HZZ597"
_certificateDomain = "test.trololo.demotw.com"
_certificateArn = "arn:aws:acm:us-east-1:111122223333:certificate/abc-123"
_certificateNameKey = "krm.kcl.dev/composition-resource-name"

_certificateBaseOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "Certificate"
    metadata.name = "site-cert"
    spec = {
        domainName = _certificateDomain
        hostedZoneId = _certificateZone
    }
}

_certificateOption1 = {
    domainName = _certificateDomain
    resourceRecordName = "_abc.test.trololo.demotw.com."
    resourceRecordType = "CNAME"
    resourceRecordValue = "_xyz.acm-validations.aws."
}

_certificateOption2 = {
    domainName = "www.trololo.demotw.com"
    resourceRecordName = "_def.www.trololo.demotw.com."
    resourceRecordType = "CNAME"
    resourceRecordValue = "_uvw.acm-validations.aws."
}

# Observed composed resources, as the function sees them in ocds.
_certificateCertNoArn = {Resource = {status = {atProvider = {}}}}
_certificateCertArnOnly = {Resource = {status = {atProvider = {arn = _certificateArn}}}}
_certificateCertWithOption = {Resource = {status = {atProvider = {
    arn = _certificateArn
    domainValidationOptions = [_certificateOption1]
}}}}
_certificateCertWithTwoOptions = {Resource = {status = {atProvider = {
    arn = _certificateArn
    domainValidationOptions = [_certificateOption1, _certificateOption2]
}}}}
_certificateValidationPending = {Resource = {status = {conditions = [{type = "Synced", status = "True"}]}}}
_certificateValidationReady = {Resource = {status = {conditions = [
    {type = "Synced", status = "True"},
    {type = "Ready", status = "True"}
]}}}

_certificateKindOf = lambda resources, kind -> [any] {
    [r for r in resources if r.kind == kind]
}

_certificateXrOf = lambda resources -> [any] {
    [r for r in resources if r.apiVersion == "platform.demotw.com/v1alpha1"]
}

test_certificate_cold_start_creates_only_the_acm_certificate = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {})

    assert len(result) == 1, "cold start should compose exactly one resource"
    acm = result[0]
    assert acm.apiVersion == "acm.aws.m.upbound.io/v1beta1"
    assert acm.kind == "Certificate"
    assert acm.metadata.annotations[_certificateNameKey] == "certificate"
    assert acm.spec.forProvider.domainName == _certificateDomain
    assert acm.spec.forProvider.validationMethod == "DNS"
}

test_certificate_defaults_region_to_us_east_1 = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {})

    assert result[0].spec.forProvider.region == "us-east-1", "CloudFront needs us-east-1 certificates"
}

test_certificate_region_can_be_overridden = lambda {
    oxr = {
        apiVersion = _certificateBaseOxr.apiVersion
        kind = _certificateBaseOxr.kind
        metadata.name = _certificateBaseOxr.metadata.name
        spec = _certificateBaseOxr.spec | {region = "eu-west-1"}
    }
    result = certificate.composeCertificate(oxr, {})

    assert result[0].spec.forProvider.region == "eu-west-1"
}

test_certificate_passes_subject_alternative_names_through = lambda {
    oxr = {
        apiVersion = _certificateBaseOxr.apiVersion
        kind = _certificateBaseOxr.kind
        metadata.name = _certificateBaseOxr.metadata.name
        spec = _certificateBaseOxr.spec | {subjectAlternativeNames = ["www.trololo.demotw.com"]}
    }
    result = certificate.composeCertificate(oxr, {})

    assert result[0].spec.forProvider.subjectAlternativeNames == ["www.trololo.demotw.com"]
}

test_certificate_leaves_subject_alternative_names_out_when_unset = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {})

    assert not result[0].spec.forProvider.subjectAlternativeNames
}

test_certificate_tolerates_unknown_spec_fields = lambda {
    oxr = {
        apiVersion = _certificateBaseOxr.apiVersion
        kind = _certificateBaseOxr.kind
        metadata.name = _certificateBaseOxr.metadata.name
        spec = _certificateBaseOxr.spec | {crossplane = {}}
    }
    result = certificate.composeCertificate(oxr, {})

    assert len(result) == 1
}

test_certificate_creates_no_records_before_options_are_observed = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {certificate = _certificateCertArnOnly})

    assert len(_certificateKindOf(result, "Record")) == 0
}

test_certificate_creates_one_validation_record_per_observed_option = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {certificate = _certificateCertWithOption})
    records = _certificateKindOf(result, "Record")

    assert len(records) == 1
    record = records[0]
    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.metadata.annotations[_certificateNameKey] == "validationRecord-0"
    assert record.spec.forProvider.zoneId == _certificateZone
    assert record.spec.forProvider.name == _certificateOption1.resourceRecordName
    assert record.spec.forProvider.records == [_certificateOption1.resourceRecordValue]
    assert record.spec.forProvider.allowOverwrite
}

test_certificate_creates_a_record_for_each_san_option = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {certificate = _certificateCertWithTwoOptions})
    records = _certificateKindOf(result, "Record")

    assert len(records) == 2
    assert records[1].metadata.annotations[_certificateNameKey] == "validationRecord-1"
    assert records[1].spec.forProvider.name == _certificateOption2.resourceRecordName
}

test_certificate_creates_validation_once_arn_is_observed = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {certificate = _certificateCertArnOnly})
    validations = _certificateKindOf(result, "CertificateValidation")

    assert len(validations) == 1
    assert validations[0].spec.forProvider.certificateArn == _certificateArn
    assert validations[0].spec.forProvider.region == "us-east-1"
    assert validations[0].metadata.annotations[_certificateNameKey] == "certificateValidation"
}

test_certificate_creates_no_validation_before_arn_is_observed = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {})

    assert len(_certificateKindOf(result, "CertificateValidation")) == 0
}

test_certificate_reports_no_status_before_arn_is_observed = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {certificate = _certificateCertNoArn})

    assert len(_certificateXrOf(result)) == 0
}

test_certificate_reports_arn_once_observed_but_not_validated = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {
        certificate = _certificateCertWithOption
        certificateValidation = _certificateValidationPending
    })
    xrs = _certificateXrOf(result)

    assert len(xrs) == 1
    assert xrs[0].kind == "Certificate"
    assert xrs[0].metadata.name == "site-cert"
    assert xrs[0].status.arn == _certificateArn
    assert not xrs[0].status.validated
}

test_certificate_reports_validated_once_validation_is_ready = lambda {
    result = certificate.composeCertificate(_certificateBaseOxr, {
        certificate = _certificateCertWithOption
        certificateValidation = _certificateValidationReady
    })
    xrs = _certificateXrOf(result)

    assert len(xrs) == 1
    assert xrs[0].status.validated
}
