import .schemas_compositions
import .schemas_providers

webServiceCertificateName = "certificate"
webServiceAutoScalingGroupName = "auto-scaling-group"
webServiceLoadBalancerName = "load-balancer"
webServiceAliasName = "domain-alias"

composeWebService = lambda oxr, ocds -> [any] {
    # Bound to a local, so the dicts below can use `spec` as a key without shadowing the XR's spec.
    _webSpec: schemas_compositions.WebServiceSpec = oxr.spec

    # Each child takes a name from the XR, so the cloud objects are easy to find and the group's name is known.
    _name = oxr.metadata.name
    _certificateChildName = "${_name}-certificate"
    _autoScalingGroupChildName = "${_name}-asg"
    _loadBalancerChildName = "${_name}-lb"

    # The certificate is requested in the load balancer's region: an ALB only accepts certificates from its own region.
    _certificate = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "TlsCertificate"
        metadata = {
            name = _certificateChildName
            annotations = {"krm.kcl.dev/composition-resource-name" = webServiceCertificateName}
        }
        spec = schemas_compositions.TlsCertificateSpec {
            domainName = _webSpec.domainName
            hostedZoneId = _webSpec.hostedZoneId
            region = _webSpec.region
        }
    }

    _autoScalingGroup = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "AutoScalingGroup"
        metadata = {
            name = _autoScalingGroupChildName
            annotations = {"krm.kcl.dev/composition-resource-name" = webServiceAutoScalingGroupName}
        }
        spec = schemas_compositions.AutoScalingGroupSpec {
            region = _webSpec.region
            imageId = _webSpec.imageId
            instanceType = _webSpec.instanceType
            subnetIds = _webSpec.instanceSubnetIds
            securityGroupIds = _webSpec.instanceSecurityGroupIds
            minSize = _webSpec.minSize
            maxSize = _webSpec.maxSize
            desiredCapacity = _webSpec.desiredCapacity
            userData = _webSpec.userData
        }
    }

    # The certificate reports validated only once ACM has issued it. The load balancer's HTTPS listener needs an issued certificate.
    _certificateStatus = ocds[webServiceCertificateName]?.Resource?.status
    _certificateArn = _certificateStatus?.certificateArn if _certificateStatus?.validated else None

    _loadBalancer = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "LoadBalancer"
        metadata = {
            name = _loadBalancerChildName
            annotations = {"krm.kcl.dev/composition-resource-name" = webServiceLoadBalancerName}
        }
        spec = schemas_compositions.LoadBalancerSpec {
            region = _webSpec.region
            vpcId = _webSpec.vpcId
            subnetIds = _webSpec.loadBalancerSubnetIds
            securityGroupIds = _webSpec.loadBalancerSecurityGroupIds
            certificateArn = _certificateArn
            targetPort = _webSpec.targetPort
            autoScalingGroupName = _autoScalingGroupChildName
        }
    } if _certificateArn else None

    # The alias needs the load balancer's DNS name and hosted zone, which it reports once it exists.
    _loadBalancerStatus = ocds[webServiceLoadBalancerName]?.Resource?.status
    _loadBalancerDnsName = _loadBalancerStatus?.dnsName
    _loadBalancerZoneId = _loadBalancerStatus?.zoneId

    _alias = {
        apiVersion = "route53.aws.m.upbound.io/v1beta1"
        kind = "Record"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = webServiceAliasName}
        spec.forProvider = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProvider {
            zoneId = _webSpec.hostedZoneId
            name = _webSpec.domainName
            $type = "A"
            alias = schemas_providers.Route53AwsmUpboundIoV1beta1RecordSpecForProviderAlias {
                name = _loadBalancerDnsName
                zoneId = _loadBalancerZoneId
                evaluateTargetHealth = True
            }
        }
    } if _loadBalancerDnsName and _loadBalancerZoneId else None

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.WebServiceStatus {
            url = "https://${_webSpec.domainName}"
            loadBalancerDnsName = _loadBalancerDnsName
        }
    } if _alias else None

    [_certificate, _autoScalingGroup] + ([_loadBalancer] if _loadBalancer else []) + ([_alias] if _alias else []) + ([_xr] if _xr else [])
}
