import .schemas_compositions
import .schemas_providers

loadBalancerLoadBalancerName = "load-balancer"
loadBalancerTargetGroupName = "target-group"
loadBalancerListenerName = "https-listener"
loadBalancerAttachmentName = "asg-attachment"

# AWS's predefined TLS 1.3 policy, which still accepts TLS 1.2 for older clients.
loadBalancerSslPolicy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

# Reads observed resources through their imported status schemas, so a misspelt field is a compile error.
loadBalancerObservedLoadBalancer = lambda atProvider -> schemas_providers.Elbv2AwsmUpboundIoV1beta1LBStatusAtProvider {
    _status: schemas_providers.Elbv2AwsmUpboundIoV1beta1LBStatusAtProvider = atProvider
    _status
}

loadBalancerObservedTargetGroup = lambda atProvider -> schemas_providers.Elbv2AwsmUpboundIoV1beta1LBTargetGroupStatusAtProvider {
    _status: schemas_providers.Elbv2AwsmUpboundIoV1beta1LBTargetGroupStatusAtProvider = atProvider
    _status
}

composeLoadBalancer = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.LoadBalancerSpec = oxr.spec

    # The load balancer and its target group take the XR's name, so the cloud objects are easy to find.
    _name = oxr.metadata.name

    _loadBalancer = {
        apiVersion = "elbv2.aws.m.upbound.io/v1beta1"
        kind = "LB"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = loadBalancerLoadBalancerName}
        spec.forProvider = schemas_providers.Elbv2AwsmUpboundIoV1beta1LBSpecForProvider {
            region = spec.region
            # Named here, not by external name: the provider reads an external name as the load balancer's ARN.
            name = _name
            loadBalancerType = "application"
            internal = False
            ipAddressType = "ipv4"
            subnets = spec.subnetIds
            securityGroups = spec.securityGroupIds
        }
    }

    _targetGroup = {
        apiVersion = "elbv2.aws.m.upbound.io/v1beta1"
        kind = "LBTargetGroup"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = loadBalancerTargetGroupName}
        spec.forProvider = schemas_providers.Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProvider {
            region = spec.region
            name = _name
            port = spec.targetPort
            $protocol = "HTTP"
            vpcId = spec.vpcId
            targetType = "instance"
        }
    }

    _observedLoadBalancerAtProvider = ocds[loadBalancerLoadBalancerName]?.Resource?.status?.atProvider
    _observedLoadBalancer = loadBalancerObservedLoadBalancer(_observedLoadBalancerAtProvider) if _observedLoadBalancerAtProvider else None
    _loadBalancerArn = _observedLoadBalancer?.arn
    _dnsName = _observedLoadBalancer?.dnsName
    _zoneId = _observedLoadBalancer?.zoneId

    _observedTargetGroupAtProvider = ocds[loadBalancerTargetGroupName]?.Resource?.status?.atProvider
    _observedTargetGroup = loadBalancerObservedTargetGroup(_observedTargetGroupAtProvider) if _observedTargetGroupAtProvider else None
    _targetGroupArn = _observedTargetGroup?.arn

    # The HTTPS listener serves the existing validated certificate, so no new certificate is requested.
    _listener = {
        apiVersion = "elbv2.aws.m.upbound.io/v1beta1"
        kind = "LBListener"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = loadBalancerListenerName}
        spec.forProvider = schemas_providers.Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProvider {
            region = spec.region
            loadBalancerArn = _loadBalancerArn
            port = 443
            $protocol = "HTTPS"
            certificateArn = spec.certificateArn
            sslPolicy = loadBalancerSslPolicy
            defaultAction = [schemas_providers.Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionItems0 {
                $type = "forward"
                targetGroupArn = _targetGroupArn
            }]
        }
    } if _loadBalancerArn and _targetGroupArn else None

    # Instances join the target group only when the consumer names their auto-scaling group.
    _attachment = {
        apiVersion = "autoscaling.aws.m.upbound.io/v1beta1"
        kind = "Attachment"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = loadBalancerAttachmentName}
        spec.forProvider = schemas_providers.AutoscalingAwsmUpboundIoV1beta1AttachmentSpecForProvider {
            region = spec.region
            autoscalingGroupName = spec.autoScalingGroupName
            lbTargetGroupArn = _targetGroupArn
        }
    } if _targetGroupArn and spec.autoScalingGroupName else None

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.LoadBalancerStatus {
            dnsName = _dnsName
            loadBalancerArn = _loadBalancerArn
            zoneId = _zoneId
        }
    } if _dnsName else None

    [_loadBalancer, _targetGroup] + ([_listener] if _listener else []) + ([_attachment] if _attachment else []) + ([_xr] if _xr else [])
}
