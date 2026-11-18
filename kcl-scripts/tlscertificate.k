import .schemas_compositions
import .schemas_providers

tlsCertificateCertificateName = "certificate"
tlsCertificateValidationName = "certificate-validation"

# One DNS validation record per ACM validation option, named by its index.
tlsCertificateRecordName = lambda i -> str {
    "validation-${i}"
}

# Reads the observed certificate through its imported schema, so a misspelt field is a compile error.
tlsCertificateObserved = lambda atProvider -> schemas_providers.AcmAwsmUpboundIoV1beta1CertificateStatusAtProvider {
    _status: schemas_providers.AcmAwsmUpboundIoV1beta1CertificateStatusAtProvider = atProvider
    _status
}

composeTlsCertificate = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.TlsCertificateSpec = oxr.spec

    _sans = spec.subjectAlternativeNames or []

    _certificate = {
        apiVersion = "acm.aws.m.upbound.io/v1beta1"
        kind = "Certificate"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = tlsCertificateCertificateName}
        spec.forProvider = schemas_providers.AcmAwsmUpboundIoV1beta1CertificateSpecForProvider {
            domainName = spec.domainName
            region = spec.region
            validationMethod = "DNS"
            subjectAlternativeNames = _sans if _sans else Undefined
        }
    }

    _observedAtProvider = ocds[tlsCertificateCertificateName]?.Resource?.status?.atProvider
    _observed = tlsCertificateObserved(_observedAtProvider) if _observedAtProvider else None
    _certificateArn = _observed?.arn
    _options = _observed?.domainValidationOptions or []

    _optionsReady = len(_options) > 0 and all_true([bool(o.resourceRecordName) and bool(o.resourceRecordValue) for o in _options])

    _records = [
        {
            apiVersion = "route53.aws.m.upbound.io/v1beta1"
            kind = "Record"
            metadata.annotations = {"krm.kcl.dev/composition-resource-name" = tlsCertificateRecordName(i)}
            spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
                zoneId = spec.hostedZoneId
                name = option.resourceRecordName or ""
                $type = option.resourceRecordType or "CNAME"
                records = [option.resourceRecordValue or ""]
                ttl = 60
                allowOverwrite = True
            }
        }
        for i, option in _options
    ] if _optionsReady else []

    _recordNames = [tlsCertificateRecordName(i) for i, option in _options]
    _fqdns = [ocds[n]?.Resource?.status?.atProvider?.fqdn or "" for n in _recordNames]
    _fqdnsReady = len(_recordNames) > 0 and all_true([bool(f) for f in _fqdns])

    _validation = {
        apiVersion = "acm.aws.m.upbound.io/v1beta1"
        kind = "CertificateValidation"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = tlsCertificateValidationName}
        spec.forProvider = schemas_providers.AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProvider {
            certificateArn = _certificateArn or ""
            region = spec.region
            validationRecordFqdns = _fqdns
        }
    } if _certificateArn and _fqdnsReady else None

    _validationConditions = ocds[tlsCertificateValidationName]?.Resource?.status?.conditions or []
    _validated = any_true([c["type"] == "Ready" and c.status == "True" for c in _validationConditions])

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.TlsCertificateStatus {
            certificateArn = _certificateArn
            validated = _validated
        }
    } if _certificateArn else None

    [_certificate] + _records + ([_validation] if _validation else []) + ([_xr] if _xr else [])
}
