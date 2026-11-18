import .dnsvalidatedcertificate

_dvcOxrFor = lambda specIn {
    _oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "DnsValidatedCertificate"
        metadata = {name = "my-cert"}
        spec = specIn
    }
    _oxr
}

_dvcFind = lambda resources, kind {
    [r for r in resources if r.kind == kind][0]
}

_dvcSpec = {domainName = "test.trololo.demotw.com", zoneId = "Z0510802PA88E7HZZ597"}
_dvcArn = "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"
_dvcValidationName = "_abc123.test.trololo.demotw.com."
_dvcValidationValue = "_xyz789.acm-validations.aws."

# Observed stages. Keys are the composition-resource-names used in the compose function.
_dvcCertNoOptionsObs = {
    Resource = {status = {atProvider = {arn = _dvcArn, domainName = "test.trololo.demotw.com"}}}
}
_dvcCertObs = {
    Resource = {status = {atProvider = {
        arn = _dvcArn
        domainName = "test.trololo.demotw.com"
        domainValidationOptions = [{
            domainName = "test.trololo.demotw.com"
            resourceRecordName = _dvcValidationName
            resourceRecordType = "CNAME"
            resourceRecordValue = _dvcValidationValue
        }]
    }}}
}
_dvcValidatedObs = {
    Resource = {status = {conditions = [{type = "Ready", status = "True"}]}}
}
_dvcNotReadyObs = {
    Resource = {status = {conditions = [{type = "Ready", status = "False"}]}}
}

test_dnsValidatedCertificate_cold_start_composes_only_the_certificate = lambda {
    oxr = _dvcOxrFor(_dvcSpec)

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, {})

    kinds = [r.kind for r in result]
    assert kinds == ["Certificate"]
    cert = _dvcFind(result, "Certificate")
    assert cert.apiVersion == "acm.aws.m.upbound.io/v1beta1"
    assert cert.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "certificate"
    assert cert.spec.forProvider.domainName == "test.trololo.demotw.com"
    assert cert.spec.forProvider.validationMethod == "DNS"
    assert cert.spec.forProvider.region == "us-east-1"
}

test_dnsValidatedCertificate_region_can_be_set = lambda {
    oxr = _dvcOxrFor({domainName = "test.trololo.demotw.com", zoneId = "Z1", region = "eu-west-1"})

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, {})

    assert _dvcFind(result, "Certificate").spec.forProvider.region == "eu-west-1"
}

test_dnsValidatedCertificate_no_records_until_validation_options_are_observed = lambda {
    oxr = _dvcOxrFor(_dvcSpec)

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, {certificate = _dvcCertNoOptionsObs})

    kinds = [r.kind for r in result]
    assert "Record" not in kinds
    assert "CertificateValidation" not in kinds
}

test_dnsValidatedCertificate_composes_a_validation_record_per_option = lambda {
    oxr = _dvcOxrFor(_dvcSpec)

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, {certificate = _dvcCertObs})

    records = [r for r in result if r.kind == "Record"]
    assert len(records) == 1
    record = records[0]
    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "validation-record-0"
    assert record.spec.forProvider.zoneId == "Z0510802PA88E7HZZ597"
    assert record.spec.forProvider.name == _dvcValidationName
    assert record.spec.forProvider.$type == "CNAME"
    assert record.spec.forProvider.records == [_dvcValidationValue]
    assert record.spec.forProvider.ttl == 60
    assert record.spec.forProvider.allowOverwrite
}

test_dnsValidatedCertificate_validation_waits_for_certificate_and_names_its_records = lambda {
    oxr = _dvcOxrFor(_dvcSpec)

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, {certificate = _dvcCertObs})

    validation = _dvcFind(result, "CertificateValidation")
    assert validation.apiVersion == "acm.aws.m.upbound.io/v1beta1"
    assert validation.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "certificate-validation"
    assert validation.spec.forProvider.certificateArn == _dvcArn
    assert validation.spec.forProvider.region == "us-east-1"
    assert validation.spec.forProvider.validationRecordFqdns == [_dvcValidationName]
}

test_dnsValidatedCertificate_ignores_extra_control_plane_fields_in_spec = lambda {
    oxr = _dvcOxrFor({domainName = "test.trololo.demotw.com", zoneId = "Z1", crossplane = {}})

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, {})

    assert len(result) == 1
}

test_dnsValidatedCertificate_status_reports_arn_only_once_validated = lambda {
    oxr = _dvcOxrFor(_dvcSpec)

    beforeReady = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, {certificate = _dvcCertObs, "certificate-validation" = _dvcNotReadyObs})
    assert "DnsValidatedCertificate" not in [r.kind for r in beforeReady]

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, {certificate = _dvcCertObs, "certificate-validation" = _dvcValidatedObs})

    xr = _dvcFind(result, "DnsValidatedCertificate")
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.metadata.name == "my-cert"
    assert xr.status.certificateArn == _dvcArn
}
