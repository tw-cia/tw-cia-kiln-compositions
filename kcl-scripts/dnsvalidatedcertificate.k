import .schemas_compositions
import .schemas_providers

_dvcCertificateRes = "certificate"
_dvcValidationRes = "certificate-validation"
_dvcValidationRecordPrefix = "validation-record-"

# Typed read of the observed certificate. Only called once the atProvider exists.
_dvcCertificateStatus = lambda atProvider -> schemas_providers.AcmAwsmUpboundIoV1beta1CertificateStatusAtProvider {
    _status: schemas_providers.AcmAwsmUpboundIoV1beta1CertificateStatusAtProvider = atProvider
    _status
}

_dvcValidationRecordForProvider = lambda zoneId, opt -> schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
    _forProvider: schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider = {
        zoneId = zoneId
        name = opt.resourceRecordName
        $type = opt.resourceRecordType
        records = [opt.resourceRecordValue]
        ttl = 60
        allowOverwrite = True
    }
    _forProvider
}

composeDnsValidatedCertificate = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.DnsValidatedCertificateSpec = oxr.spec
    _domainName = spec.domainName
    _zoneId = spec.zoneId
    _region = spec.region

    _observedCertAtProvider = ocds[_dvcCertificateRes]?.Resource?.status?.atProvider
    _observedCert = _dvcCertificateStatus(_observedCertAtProvider) if _observedCertAtProvider else None
    _certArn = _observedCert?.arn
    _validationOptions = _observedCert?.domainValidationOptions or []
    _validationFqdns = [opt.resourceRecordName for opt in _validationOptions]

    _certForProvider: schemas_providers.AcmAwsmUpboundIoV1beta1CertificateSpecForProvider = {
        domainName = _domainName
        validationMethod = "DNS"
        region = _region
    }
    _certificate = {
        apiVersion = "acm.aws.m.upbound.io/v1beta1"
        kind = "Certificate"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _dvcCertificateRes
        }
        spec.forProvider = _certForProvider
    }

    _validationRecords = [{
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = "${_dvcValidationRecordPrefix}${i}"
        }
        spec.forProvider = _dvcValidationRecordForProvider(_zoneId, opt)
    } for i, opt in _validationOptions]

    _validationForProvider: schemas_providers.AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProvider = {
        certificateArn = _certArn
        region = _region
        validationRecordFqdns = _validationFqdns
    }
    _validation = {
        apiVersion = "acm.aws.m.upbound.io/v1beta1"
        kind = "CertificateValidation"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _dvcValidationRes
        }
        spec.forProvider = _validationForProvider
    } if _certArn and len(_validationFqdns) > 0 else None

    _validationConditions = ocds[_dvcValidationRes]?.Resource?.status?.conditions or []
    _validated = len([c for c in _validationConditions if c.type == "Ready" and c.status == "True"]) > 0

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.DnsValidatedCertificateStatus {certificateArn = _certArn}
    } if _validated and _certArn else None

    [_certificate] + _validationRecords + ([_validation] if _validation else []) + ([_xr] if _xr else [])
}
