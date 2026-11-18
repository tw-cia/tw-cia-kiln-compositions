import .schemas_compositions
import .schemas_providers

# A DNS-validated ACM certificate: the certificate, one Route53 record per
# validation option ACM reports, and a CertificateValidation that waits for issue.
#
# Staging: the ARN and validation options only exist once the certificate is
# observed, so the records and the validation are emitted in later reconciles.

_certificateName = "certificate"
_certificateValidationName = "certificateValidation"

_certificateValidationRecord = lambda zoneId: str, i: int, option: any -> any {
    _record = {
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = "validationRecord-${i}"
        }
        spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
            zoneId = zoneId
            name = option.resourceRecordName
            $type = option.resourceRecordType
            records = [option.resourceRecordValue]
            ttl = 60
            allowOverwrite = True
        }
    }
    _record
}

composeCertificate = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.CertificateSpec = oxr.spec

    # Read every XR value into a local first: inside a dict that sets its own
    # spec.<x>, `spec.<y>` would refer to that dict's spec.
    _domainName = spec.domainName
    _sans = spec.subjectAlternativeNames
    _zoneId = spec.hostedZoneId
    _region = spec.region

    _observed = ocds[_certificateName]?.Resource?.status?.atProvider
    _arn = _observed?.arn
    _options = _observed?.domainValidationOptions or []

    _acm = {
        apiVersion = "acm.aws.m.upbound.io/v1beta1"
        kind = "Certificate"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _certificateName
        }
        spec.forProvider = schemas_providers.AcmAwsmUpboundIoV1beta1CertificateSpecForProvider {
            domainName = _domainName
            subjectAlternativeNames = _sans
            validationMethod = "DNS"
            region = _region
        }
    }

    _records = [_certificateValidationRecord(_zoneId, i, _options[i]) for i in range(len(_options))]

    _validation = {
        apiVersion = "acm.aws.m.upbound.io/v1beta1"
        kind = "CertificateValidation"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _certificateValidationName
        }
        spec.forProvider = schemas_providers.AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProvider {
            certificateArn = _arn
            region = _region
        }
    }

    # The Ready condition of the validation is the signal that ACM has issued
    # the certificate. status.atProvider can lag, so don't gate on it.
    _conditions = ocds[_certificateValidationName]?.Resource?.status?.conditions or []
    _validated = len([c for c in _conditions if c["type"] == "Ready" and c["status"] == "True"]) > 0

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.CertificateStatus {
            arn = _arn
            validated = _validated
        }
    } if _arn else None

    [_acm] + _records + ([_validation] if _arn else []) + ([_xr] if _xr else [])
}
