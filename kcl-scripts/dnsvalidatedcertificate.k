import .schemas_compositions
import .schemas_providers

composeDnsValidatedCertificate = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.DnsValidatedCertificateSpec = oxr.spec

    _certificateName = "certificate"
    _validationName = "certificate-validation"

    _certificateForProvider: schemas_providers.AcmAwsmUpboundIoV1beta1CertificateSpecForProvider = {
        region = spec.region
        domainName = spec.domainName
        subjectAlternativeNames = spec.subjectAlternativeNames
        tags = spec.tags
        validationMethod = "DNS"
    }

    _certificate = {
        apiVersion = "acm.aws.m.upbound.io/v1beta1"
        kind = "Certificate"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _certificateName
        }
        spec.forProvider = _certificateForProvider
    }

    _observedCertificate = ocds[_certificateName]?.Resource?.status?.atProvider
    _arn = _observedCertificate?.arn
    _validationOptions = _observedCertificate?.domainValidationOptions or []

    # ACM gives a wildcard and its apex the same validation CNAME. Create each
    # distinct record once, or Route53 rejects the duplicate.
    _uniqueOptions = [opt for i, opt in _validationOptions if not any_true([prior.resourceRecordName == opt.resourceRecordName for prior in _validationOptions[0:i]])]

    _validationRecords = [{
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = "validation-record-${i}"
        }
        spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
            zoneId = spec.zoneId
            name = opt.resourceRecordName
            $type = opt.resourceRecordType
            records = [opt.resourceRecordValue]
            ttl = 300
        }
    } for i, opt in _uniqueOptions]

    _validationFqdns = [opt.resourceRecordName for opt in _uniqueOptions]

    _certificateValidation = {
        apiVersion = "acm.aws.m.upbound.io/v1beta1"
        kind = "CertificateValidation"
        metadata.annotations = {
            "krm.kcl.dev/composition-resource-name" = _validationName
        }
        spec.forProvider = schemas_providers.AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProvider {
            region = spec.region
            certificateArn = _arn
            validationRecordFqdns = _validationFqdns
        }
    } if _arn and len(_validationFqdns) > 0 else None

    # Report the ARN only once ACM has issued the certificate, so a consumer
    # (the StaticWebsite distribution) never attaches a pending certificate.
    _validationConditions = ocds[_validationName]?.Resource?.status?.conditions or []
    _validated = any_true([c.type == "Ready" and c.status == "True" for c in _validationConditions])

    _dxr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.DnsValidatedCertificateStatus {certificateArn = _arn}
    } if _validated and _arn else None

    [_certificate] + _validationRecords + ([_certificateValidation] if _certificateValidation else []) + ([_dxr] if _dxr else [])
}
