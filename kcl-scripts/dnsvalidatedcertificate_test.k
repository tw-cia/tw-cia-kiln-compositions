import .dnsvalidatedcertificate

_dnsCertBaseSpec = {
    domainName = "example.com"
    region = "us-east-1"
    zoneId = "Z123456ABCDEFG"
}

_dnsCertBaseOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "DnsValidatedCertificate"
    metadata = {name = "example-cert"}
    spec = _dnsCertBaseSpec
}

_dnsCertArn = "arn:aws:acm:us-east-1:123456789012:certificate/abc"

_dnsCertOption = lambda name, record, value -> {str:any} {
    _option = {
        domainName = name
        resourceRecordName = record
        resourceRecordType = "CNAME"
        resourceRecordValue = value
    }
    _option
}

_dnsCertValidated = [{type = "Ready", status = "True"}]

# --- Cold start and pass-through -------------------------------------------

test_dnscert_cold_start_requests_only_the_certificate = lambda {
    oxr = {spec = _dnsCertBaseSpec}
    ocds = {}

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, ocds)

    assert len(result) == 1
    cert = result[0]
    assert cert.kind == "Certificate"
    assert cert.apiVersion == "acm.aws.m.upbound.io/v1beta1"
    assert cert.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "certificate"
    assert cert.spec.forProvider.domainName == "example.com"
    assert cert.spec.forProvider.region == "us-east-1"
    assert cert.spec.forProvider.validationMethod == "DNS"
}

test_dnscert_passes_optional_fields_through_when_set = lambda {
    oxr = {spec = {
        domainName = "example.com"
        region = "us-east-1"
        zoneId = "Z123456ABCDEFG"
        subjectAlternativeNames = ["www.example.com", "api.example.com"]
        tags = {team = "web"}
    }}

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, {})

    cert = result[0]
    assert cert.spec.forProvider.subjectAlternativeNames == ["www.example.com", "api.example.com"]
    assert cert.spec.forProvider.tags == {team = "web"}
}

test_dnscert_leaves_optional_fields_absent_when_not_set = lambda {
    result = dnsvalidatedcertificate.composeDnsValidatedCertificate({spec = _dnsCertBaseSpec}, {})

    cert = result[0]
    assert not cert.spec.forProvider.subjectAlternativeNames
    assert not cert.spec.forProvider.tags
}

test_dnscert_tolerates_extra_fields_the_real_control_plane_injects = lambda {
    oxr = {
        spec = {
            domainName = "example.com"
            region = "us-east-1"
            zoneId = "Z123456ABCDEFG"
            crossplane = {compositionRef = {name = "dnsvalidatedcertificate-demotw"}}
        }
    }

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(oxr, {})

    assert len(result) == 1
}

# --- Observed stages --------------------------------------------------------

test_dnscert_empty_observed_certificate_adds_nothing_new = lambda {
    ocds = {
        "certificate" = {Resource = {status = {atProvider = {}}}}
    }

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(_dnsCertBaseOxr, ocds)

    assert len(result) == 1
}

test_dnscert_arn_without_validation_options_reports_no_status = lambda {
    ocds = {
        "certificate" = {Resource = {status = {atProvider = {arn = _dnsCertArn}}}}
    }

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(_dnsCertBaseOxr, ocds)

    assert len(result) == 1
}

test_dnscert_validation_options_create_record_and_validation_but_no_status_until_ready = lambda {
    ocds = {
        "certificate" = {
            Resource = {
                status = {
                    atProvider = {
                        arn = _dnsCertArn
                        domainValidationOptions = [
                            _dnsCertOption("example.com", "_acme.example.com.", "_xyz.acm-validations.aws.")
                        ]
                    }
                }
            }
        }
    }

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(_dnsCertBaseOxr, ocds)

    assert len(result) == 3
    record = result[1]
    assert record.kind == "Record"
    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.spec.forProvider.zoneId == "Z123456ABCDEFG"
    assert record.spec.forProvider.name == "_acme.example.com."
    assert record.spec.forProvider.$type == "CNAME"
    assert record.spec.forProvider.records == ["_xyz.acm-validations.aws."]
    assert record.spec.forProvider.ttl == 300

    validation = result[2]
    assert validation.kind == "CertificateValidation"
    assert validation.spec.forProvider.region == "us-east-1"
    assert validation.spec.forProvider.certificateArn == _dnsCertArn
    assert validation.spec.forProvider.validationRecordFqdns == ["_acme.example.com."]
}

test_dnscert_reports_arn_once_validation_is_ready = lambda {
    ocds = {
        "certificate" = {
            Resource = {
                status = {
                    atProvider = {
                        arn = _dnsCertArn
                        domainValidationOptions = [
                            _dnsCertOption("example.com", "_acme.example.com.", "_xyz.acm-validations.aws.")
                        ]
                    }
                }
            }
        }
        "certificate-validation" = {
            Resource = {status = {conditions = _dnsCertValidated}}
        }
    }

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(_dnsCertBaseOxr, ocds)

    assert len(result) == 4
    dxr = result[3]
    assert dxr.apiVersion == "platform.demotw.com/v1alpha1"
    assert dxr.kind == "DnsValidatedCertificate"
    assert dxr.metadata.name == "example-cert"
    assert dxr.status.certificateArn == _dnsCertArn
}

test_dnscert_does_not_report_arn_while_validation_is_pending = lambda {
    ocds = {
        "certificate" = {
            Resource = {
                status = {
                    atProvider = {
                        arn = _dnsCertArn
                        domainValidationOptions = [
                            _dnsCertOption("example.com", "_acme.example.com.", "_xyz.acm-validations.aws.")
                        ]
                    }
                }
            }
        }
        "certificate-validation" = {
            Resource = {status = {conditions = [{type = "Ready", status = "False"}]}}
        }
    }

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate(_dnsCertBaseOxr, ocds)

    assert len(result) == 3
}

# --- Multiple names ---------------------------------------------------------

test_dnscert_creates_one_record_per_distinct_validation_name = lambda {
    ocds = {
        "certificate" = {
            Resource = {
                status = {
                    atProvider = {
                        arn = _dnsCertArn
                        domainValidationOptions = [
                            _dnsCertOption("example.com", "_apex.example.com.", "_apex-value.acm-validations.aws."),
                            _dnsCertOption("www.example.com", "_www.example.com.", "_www-value.acm-validations.aws.")
                        ]
                    }
                }
            }
        }
    }

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate({
        spec = {
            domainName = "example.com"
            region = "us-east-1"
            zoneId = "Z123456ABCDEFG"
            subjectAlternativeNames = ["www.example.com"]
        }
    }, ocds)

    assert len(result) == 4
    assert result[1].kind == "Record"
    assert result[2].kind == "Record"
    assert result[1].spec.forProvider.name == "_apex.example.com."
    assert result[2].spec.forProvider.name == "_www.example.com."
    assert result[1].metadata.annotations["krm.kcl.dev/composition-resource-name"] != result[2].metadata.annotations["krm.kcl.dev/composition-resource-name"]
    validation = result[3]
    assert validation.spec.forProvider.validationRecordFqdns == ["_apex.example.com.", "_www.example.com."]
}

test_dnscert_wildcard_and_apex_sharing_one_record_create_it_once = lambda {
    # ACM gives "example.com" and "*.example.com" the same validation CNAME.
    ocds = {
        "certificate" = {
            Resource = {
                status = {
                    atProvider = {
                        arn = _dnsCertArn
                        domainValidationOptions = [
                            _dnsCertOption("example.com", "_shared.example.com.", "_shared-value.acm-validations.aws."),
                            _dnsCertOption("*.example.com", "_shared.example.com.", "_shared-value.acm-validations.aws.")
                        ]
                    }
                }
            }
        }
    }

    result = dnsvalidatedcertificate.composeDnsValidatedCertificate({
        spec = {
            domainName = "example.com"
            region = "us-east-1"
            zoneId = "Z123456ABCDEFG"
            subjectAlternativeNames = ["*.example.com"]
        }
    }, ocds)

    assert len(result) == 3
    assert result[1].kind == "Record"
    assert result[2].spec.forProvider.validationRecordFqdns == ["_shared.example.com."]
}
