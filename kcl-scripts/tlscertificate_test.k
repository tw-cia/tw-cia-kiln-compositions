import .tlscertificate

_tlsCertificateOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "TlsCertificate"
    metadata.name = "my-cert"
    spec = {domainName = "test.example.com", hostedZoneId = "Z123EXAMPLE"}
}

_tlsCertificateArn = "arn:aws:acm:us-east-1:111111111111:certificate/example"

_tlsCertificateOption = {
    domainName = "test.example.com"
    resourceRecordName = "_abc.test.example.com."
    resourceRecordType = "CNAME"
    resourceRecordValue = "_xyz.acm-validations.aws."
}

# The certificate has been requested and ACM has returned its DNS validation options.
_tlsCertificateRequested = {
    certificate = {Resource = {status = {atProvider = {
        arn = _tlsCertificateArn
        domainValidationOptions = [_tlsCertificateOption]
    }}}}
}

# The validation record exists and Route53 reports its name.
_tlsCertificateRecordCreated = {
    certificate = {Resource = {status = {atProvider = {
        arn = _tlsCertificateArn
        domainValidationOptions = [_tlsCertificateOption]
    }}}}
    "validation-0" = {Resource = {status = {atProvider = {fqdn = "_abc.test.example.com."}}}}
}

# ACM has issued the certificate: the validation resource is Ready.
_tlsCertificateValidated = {
    certificate = {Resource = {status = {atProvider = {
        arn = _tlsCertificateArn
        domainValidationOptions = [_tlsCertificateOption]
    }}}}
    "validation-0" = {Resource = {status = {atProvider = {fqdn = "_abc.test.example.com."}}}}
    "certificate-validation" = {Resource = {status = {
        atProvider = {certificateArn = _tlsCertificateArn}
        conditions = [{"type" = "Ready", status = "True"}]
    }}}
}

# Cold start: nothing observed, so only the certificate is requested.
test_tlsCertificate_requests_a_dns_validated_certificate = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, {})

    assert len(result) == 1
    cert = result[0]
    assert cert.apiVersion == "acm.aws.m.upbound.io/v1beta1"
    assert cert.kind == "Certificate"
    assert cert.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "certificate"
    assert cert.spec.forProvider.domainName == "test.example.com"
    assert cert.spec.forProvider.validationMethod == "DNS"
}

test_tlsCertificate_defaults_to_us_east_1 = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, {})

    assert result[0].spec.forProvider.region == "us-east-1"
}

test_tlsCertificate_passes_subject_alternative_names_when_set = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "TlsCertificate"
        metadata.name = "my-cert"
        spec = {
            domainName = "test.example.com"
            hostedZoneId = "Z123EXAMPLE"
            subjectAlternativeNames = ["www.test.example.com"]
        }
    }

    result = tlscertificate.composeTlsCertificate(oxr, {})

    assert result[0].spec.forProvider.subjectAlternativeNames == ["www.test.example.com"]
}

test_tlsCertificate_omits_subject_alternative_names_when_unset = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, {})

    # Undefined is dropped when serialised, so the field is never sent to AWS.
    assert not result[0].spec.forProvider.subjectAlternativeNames
}

# Empty atProvider: the certificate exists but ACM has not reported an ARN yet.
test_tlsCertificate_empty_atprovider_emits_only_the_certificate = lambda {
    ocds = {certificate = {Resource = {status = {atProvider = {}}}}}

    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, ocds)

    assert len(result) == 1
    assert result[0].kind == "Certificate"
}

# Partly observed: the ARN and options are known, so the validation records are written.
test_tlsCertificate_writes_a_dns_record_per_validation_option = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, _tlsCertificateRequested)

    # Certificate, one record, then the status report, since the ARN is known.
    assert len(result) == 3
    record = result[1]
    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.kind == "Record"
    assert record.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "validation-0"
    assert record.spec.forProvider.zoneId == "Z123EXAMPLE"
    assert record.spec.forProvider.name == "_abc.test.example.com."
    assert record.spec.forProvider["type"] == "CNAME"
    assert record.spec.forProvider.records == ["_xyz.acm-validations.aws."]
    assert record.spec.forProvider.ttl == 60
    assert record.spec.forProvider.allowOverwrite
}

test_tlsCertificate_options_not_yet_filled_write_no_records = lambda {
    ocds = {certificate = {Resource = {status = {atProvider = {
        arn = _tlsCertificateArn
        domainValidationOptions = [{domainName = "test.example.com"}]
    }}}}}

    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, ocds)

    assert len([r for r in result if r.kind == "Record"]) == 0
    assert "CertificateValidation" not in [r.kind for r in result]
}

# The records exist but the validation resource is not written until every record name is known.
test_tlsCertificate_no_validation_until_record_names_are_observed = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, _tlsCertificateRequested)

    assert "CertificateValidation" not in [r.kind for r in result]
}

test_tlsCertificate_validation_waits_for_every_record = lambda {
    _secondOption = {
        domainName = "www.test.example.com"
        resourceRecordName = "_def.www.test.example.com."
        resourceRecordType = "CNAME"
        resourceRecordValue = "_uvw.acm-validations.aws."
    }
    _certificateObserved = {
        arn = _tlsCertificateArn
        domainValidationOptions = [_tlsCertificateOption, _secondOption]
    }
    _firstRecordObserved = {Resource = {status = {atProvider = {fqdn = "_abc.test.example.com."}}}}
    ocds = {certificate = {Resource = {status = {atProvider = _certificateObserved}}}, "validation-0" = _firstRecordObserved}

    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, ocds)

    assert "CertificateValidation" not in [r.kind for r in result]
    assert len([r for r in result if r.kind == "Record"]) == 2
}

# Fully observed: the validation resource is written with the record names.
test_tlsCertificate_writes_validation_once_records_exist = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, _tlsCertificateRecordCreated)

    validation = [r for r in result if r.kind == "CertificateValidation"][0]
    assert validation.kind == "CertificateValidation"
    assert validation.apiVersion == "acm.aws.m.upbound.io/v1beta1"
    assert validation.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "certificate-validation"
    assert validation.spec.forProvider.certificateArn == _tlsCertificateArn
    assert validation.spec.forProvider.validationRecordFqdns == ["_abc.test.example.com."]
    assert validation.spec.forProvider.region == "us-east-1"
}

# Status is not reported before the ARN exists.
test_tlsCertificate_reports_no_status_before_the_arn_exists = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, {})

    assert len(result) == 1
}

test_tlsCertificate_reports_arn_before_validation = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, _tlsCertificateRequested)

    xr = result[-1]
    assert xr.kind == "TlsCertificate"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.metadata.name == "my-cert"
    assert xr.status.certificateArn == _tlsCertificateArn
    assert xr.status.validated == False
}

test_tlsCertificate_reports_validated_once_the_validation_is_ready = lambda {
    result = tlscertificate.composeTlsCertificate(_tlsCertificateOxr, _tlsCertificateValidated)

    xr = result[-1]
    assert xr.kind == "TlsCertificate"
    assert xr.status.certificateArn == _tlsCertificateArn
    assert xr.status.validated == True
}
