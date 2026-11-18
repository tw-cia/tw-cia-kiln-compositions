import .schemas_compositions
import .schemas_providers

# TlsCertificate: an ACM certificate validated through DNS records in a Route 53
# hosted zone. Staged by what is observed:
#   cold start              -> the certificate only
#   ARN known               -> the certificate, plus status with validated = false
#   validation options known -> the validation record and CertificateValidation
#   validation Ready        -> status with validated = true
composeTlsCertificate = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.TlsCertificateSpec = oxr.spec

    # Bind XR values to locals before building resource dicts (see kcl-primer).
    _domainName = spec.domainName
    _hostedZoneId = spec.hostedZoneId
    _region = spec.region

    _certificateName = "certificate"
    _validationRecordName = "validation-record"
    _certificateValidationName = "certificate-validation"

    _certificateForProvider: schemas_providers.AcmAwsmUpboundIoV1beta1CertificateSpecForProvider = {
        domainName = _domainName
        region = _region
        validationMethod = "DNS"
    }
    _certificate = {
        apiVersion = "acm.aws.m.upbound.io/v1beta1"
        kind = "Certificate"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _certificateName}
        spec.forProvider = _certificateForProvider
    }

    _atProvider = ocds["certificate"]?.Resource?.status?.atProvider
    _certificateArn = _atProvider?.arn
    _validationOptions = _atProvider?.domainValidationOptions or []
    _validationOption = _validationOptions[0] if _validationOptions else None

    _validationRecords = [{
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _validationRecordName}
        spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
            zoneId = _hostedZoneId
            name = _validationOption.resourceRecordName
            $type = "CNAME"
            records = [_validationOption.resourceRecordValue]
            ttl = 60
            allowOverwrite = True
        }
    }] if _validationOption else []

    _certificateValidations = [{
        apiVersion = "acm.aws.m.upbound.io/v1beta1"
        kind = "CertificateValidation"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _certificateValidationName}
        spec.forProvider = schemas_providers.AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProvider {
            certificateArn = _certificateArn
            region = _region
            validationRecordFqdns = [_validationOption.resourceRecordName]
        }
    }] if _certificateArn and _validationOption else []

    _conditions = ocds["certificate-validation"]?.Resource?.status?.conditions or []
    _validated = any_true([c["type"] == "Ready" and c.status == "True" for c in _conditions])

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.TlsCertificateStatus {certificateArn = _certificateArn, validated = _validated}
    } if _certificateArn else None

    [_certificate] + _validationRecords + _certificateValidations + ([_xr] if _xr else [])
}
