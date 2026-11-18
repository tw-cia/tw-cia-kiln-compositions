import base64
import .schemas_compositions
import .schemas_providers

# WebFleet: an auto-scaling group of web instances behind an application load
# balancer. Each resource waits for the observed values it needs, so the
# function is staged the same way as the cluster reports them.
awsResource = lambda apiVersion, kind, name, forProvider -> {str:any} {
    {
        apiVersion = apiVersion
        kind = kind
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = name}
        spec.forProvider = forProvider
    }
}

composeWebFleet = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.WebFleetSpec = oxr.spec

    # Bind XR values to locals before building resource dicts (see kcl-primer).
    _name = spec.name
    _region = spec.region
    _vpcId = spec.vpcId
    _subnetIds = spec.subnetIds
    _instanceSubnetIds = spec.instanceSubnetIds or spec.subnetIds
    _port = spec.port
    _healthCheckPath = spec.healthCheckPath
    _minSize = spec.minSize
    _maxSize = spec.maxSize
    _imageId = spec.imageId
    _instanceType = spec.instanceType
    _userData = spec.userData
    _scalingSchedules = spec.scalingSchedules or []

    _albSgName = "alb-security-group"
    _instanceSgName = "instance-security-group"
    _albIngressName = "alb-ingress"
    _instanceIngressName = "instance-ingress"
    _albEgressName = "alb-egress"
    _instanceEgressName = "instance-egress"
    _launchTemplateName = "launch-template"
    _loadBalancerName = "load-balancer"
    _targetGroupName = "target-group"
    _listenerName = "listener"
    _autoScalingGroupName = "autoscaling-group"

    _albSgId = ocds[_albSgName]?.Resource?.status?.atProvider?.id
    _instanceSgId = ocds[_instanceSgName]?.Resource?.status?.atProvider?.id
    _targetGroupArn = ocds[_targetGroupName]?.Resource?.status?.atProvider?.arn
    _lbAtProvider = ocds[_loadBalancerName]?.Resource?.status?.atProvider
    _lbArn = _lbAtProvider?.arn
    _lbDnsName = _lbAtProvider?.dnsName
    _launchTemplateId = ocds[_launchTemplateName]?.Resource?.status?.atProvider?.id

    # Ungated: these two security groups are the first things created.
    _albSecurityGroupForProvider: schemas_providers.Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProvider = {
        name = "${_name}-alb"
        description = "Load balancer for ${_name}"
        vpcId = _vpcId
        region = _region
    }
    _albSecurityGroup = awsResource("ec2.aws.m.upbound.io/v1beta1", "SecurityGroup", _albSgName, _albSecurityGroupForProvider)

    _instanceSecurityGroupForProvider: schemas_providers.Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProvider = {
        name = "${_name}-instances"
        description = "Instances of ${_name}"
        vpcId = _vpcId
        region = _region
    }
    _instanceSecurityGroup = awsResource("ec2.aws.m.upbound.io/v1beta1", "SecurityGroup", _instanceSgName, _instanceSecurityGroupForProvider)

    # Ungated: the target group needs only the VPC and the port.
    _targetGroups = [awsResource("elbv2.aws.m.upbound.io/v1beta1", "LBTargetGroup", _targetGroupName, schemas_providers.Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProvider {
        name = _name
        region = _region
        vpcId = _vpcId
        port = _port
        $protocol = "HTTP"
        targetType = "instance"
        healthCheck = {path = _healthCheckPath}
    })]

    _albIngressRules = [awsResource("ec2.aws.m.upbound.io/v1beta1", "SecurityGroupRule", _albIngressName, schemas_providers.Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProvider {
        region = _region
        securityGroupId = _albSgId
        $type = "ingress"
        $protocol = "tcp"
        fromPort = 80
        toPort = 80
        cidrBlocks = ["0.0.0.0/0"]
    })] if _albSgId else []

    _loadBalancers = [awsResource("elbv2.aws.m.upbound.io/v1beta1", "LB", _loadBalancerName, schemas_providers.Elbv2AwsmUpboundIoV1beta1LBSpecForProvider {
        name = _name
        region = _region
        loadBalancerType = "application"
        internal = False
        subnets = _subnetIds
        securityGroups = [_albSgId]
    })] if _albSgId else []

    # The user data script is base64-encoded, as the launch template requires.
    # The key is left out entirely when no script is given.
    _launchTemplates = [awsResource("ec2.aws.m.upbound.io/v1beta1", "LaunchTemplate", _launchTemplateName, schemas_providers.Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProvider {
        name = _name
        region = _region
        imageId = _imageId
        instanceType = _instanceType
        vpcSecurityGroupIds = [_instanceSgId]
        **({"userData" = base64.encode(_userData)} if _userData else {})
    })] if _instanceSgId else []

    _instanceIngressRules = [awsResource("ec2.aws.m.upbound.io/v1beta1", "SecurityGroupRule", _instanceIngressName, schemas_providers.Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProvider {
        region = _region
        securityGroupId = _instanceSgId
        sourceSecurityGroupId = _albSgId
        $type = "ingress"
        $protocol = "tcp"
        fromPort = _port
        toPort = _port
    })] if _albSgId and _instanceSgId else []

    # Security groups created without egress rules have none: the provider does
    # not keep AWS's default allow-all outbound rule. Both groups need explicit egress.
    _albEgressRules = [awsResource("ec2.aws.m.upbound.io/v1beta1", "SecurityGroupRule", _albEgressName, schemas_providers.Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProvider {
        region = _region
        securityGroupId = _albSgId
        sourceSecurityGroupId = _instanceSgId
        $type = "egress"
        $protocol = "tcp"
        fromPort = _port
        toPort = _port
    })] if _albSgId and _instanceSgId else []

    _instanceEgressRules = [awsResource("ec2.aws.m.upbound.io/v1beta1", "SecurityGroupRule", _instanceEgressName, schemas_providers.Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProvider {
        region = _region
        securityGroupId = _instanceSgId
        $type = "egress"
        $protocol = "-1"
        fromPort = 0
        toPort = 0
        cidrBlocks = ["0.0.0.0/0"]
    })] if _instanceSgId else []

    _listeners = [awsResource("elbv2.aws.m.upbound.io/v1beta1", "LBListener", _listenerName, schemas_providers.Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProvider {
        region = _region
        loadBalancerArn = _lbArn
        port = 80
        $protocol = "HTTP"
        defaultAction = [schemas_providers.Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultAction {
            $type = "forward"
            targetGroupArn = _targetGroupArn
        }]
    })] if _lbArn and _targetGroupArn else []

    _autoScalingGroups = [awsResource("autoscaling.aws.m.upbound.io/v1beta1", "AutoscalingGroup", _autoScalingGroupName, schemas_providers.AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProvider {
        region = _region
        vpcZoneIdentifier = _instanceSubnetIds
        minSize = _minSize
        maxSize = _maxSize
        healthCheckType = "ELB"
        healthCheckGracePeriod = 300
        launchTemplate = schemas_providers.AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplate {
            id = _launchTemplateId
            version = "$Latest"
        }
        trafficSource = [schemas_providers.AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderTrafficSource {
            identifier = _targetGroupArn
            $type = "elbv2"
        }]
    })] if _launchTemplateId and _targetGroupArn else []

    # One scheduled action per scalingSchedules entry, once the ASG exists. Each one
    # finds the fleet's own ASG through its controller reference. AWS treats an
    # omitted size as 0, so a size the consumer left out is sent as -1 (unchanged).
    _scalingScheduleActions = [awsResource("autoscaling.aws.m.upbound.io/v1beta1", "Schedule", "scaling-schedule-${s.name}", schemas_providers.AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProvider {
        region = _region
        autoscalingGroupNameSelector = {matchControllerRef = True}
        recurrence = s.recurrence
        minSize = s.minSize if s.minSize is not Undefined else -1
        maxSize = s.maxSize if s.maxSize is not Undefined else -1
        desiredCapacity = s.desiredCapacity if s.desiredCapacity is not Undefined else -1
        **({"timeZone" = s.timeZone} if s.timeZone else {})
    }) for s in _scalingSchedules] if _autoScalingGroups else []

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.WebFleetStatus {loadBalancerArn = _lbArn, loadBalancerDnsName = _lbDnsName}
    } if _lbDnsName else None

    [_albSecurityGroup, _instanceSecurityGroup] + _targetGroups + _albIngressRules + _loadBalancers + _launchTemplates + _instanceIngressRules + _albEgressRules + _instanceEgressRules + _listeners + _autoScalingGroups + _scalingScheduleActions + ([_xr] if _xr else [])
}
