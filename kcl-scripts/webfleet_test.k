import .webfleet
import .schemas_compositions

_wfOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "WebFleet"
    metadata = {name = "web-fleet"}
    spec = {
        name = "web"
        vpcId = "vpc-0123456789abcdef0"
        subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
        imageId = "ami-0123456789abcdef0"
    }
}

_wfUserData = "#!/bin/bash\necho hello from the fleet\n"
_wfUserDataBase64 = "IyEvYmluL2Jhc2gKZWNobyBoZWxsbyBmcm9tIHRoZSBmbGVldAo="

_wfAlbSgArn = "sg-0alb0000000000000"
_wfAlbSg = {"alb-security-group" = {Resource = {status = {atProvider = {id = "sg-0alb0000000000000"}}}}}
_wfInstanceSg = {"instance-security-group" = {Resource = {status = {atProvider = {id = "sg-0inst000000000000"}}}}}
_wfTargetGroup = {"target-group" = {Resource = {status = {atProvider = {arn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:targetgroup/web/0123456789"}}}}}
_wfLoadBalancer = {"load-balancer" = {Resource = {status = {atProvider = {
    arn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:loadbalancer/app/web/abcdef"
    dnsName = "web-123456.us-east-1.elb.amazonaws.com"
}}}}}
_wfLaunchTemplate = {"launch-template" = {Resource = {status = {atProvider = {id = "lt-0123456789abcdef0"}}}}}
_wfListener = {"listener" = {Resource = {status = {atProvider = {arn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:listener/app/web/abcdef/0123"}}}}}

_wfStageSgs = _wfAlbSg | _wfInstanceSg
_wfStageLbs = _wfAlbSg | _wfInstanceSg | _wfTargetGroup | _wfLoadBalancer | _wfLaunchTemplate
_wfStageAll = _wfStageLbs | _wfListener

_wfComposed = lambda resources {
    [r for r in resources if r.kind != "WebFleet"]
}

_wfXr = lambda resources {
    [r for r in resources if r.kind == "WebFleet"]
}

_wfNamed = lambda resources, name {
    [r for r in _wfComposed(resources) if r.metadata.annotations["krm.kcl.dev/composition-resource-name"] == name]
}

test_webFleet_cold_start_emits_security_groups_and_target_group = lambda {
    result = webfleet.composeWebFleet(_wfOxr, {})

    assert len(_wfComposed(result)) == 3, "cold start: two security groups and the target group"
    assert len(_wfXr(result)) == 0, "cold start reports no status"
}

test_webFleet_security_groups_are_named_and_placed_in_the_vpc = lambda {
    result = webfleet.composeWebFleet(_wfOxr, {})
    albSg = _wfNamed(result, "alb-security-group")[0]
    instanceSg = _wfNamed(result, "instance-security-group")[0]

    assert albSg.apiVersion == "ec2.aws.m.upbound.io/v1beta1"
    assert albSg.kind == "SecurityGroup"
    assert albSg.spec.forProvider.name == "web-alb"
    assert albSg.spec.forProvider.vpcId == "vpc-0123456789abcdef0"
    assert albSg.spec.forProvider.region == "us-east-1"
    assert instanceSg.spec.forProvider.name == "web-instances"
    assert instanceSg.spec.forProvider.vpcId == "vpc-0123456789abcdef0"
}

test_webFleet_target_group_forwards_to_the_app_port = lambda {
    result = webfleet.composeWebFleet(_wfOxr, {})
    tg = _wfNamed(result, "target-group")[0]

    assert tg.apiVersion == "elbv2.aws.m.upbound.io/v1beta1"
    assert tg.kind == "LBTargetGroup"
    assert tg.spec.forProvider.name == "web"
    assert tg.spec.forProvider.port == 80, "port defaults to 80"
    assert tg.spec.forProvider.$protocol == "HTTP"
    assert tg.spec.forProvider.targetType == "instance"
    assert tg.spec.forProvider.vpcId == "vpc-0123456789abcdef0"
    assert tg.spec.forProvider.healthCheck.path == "/", "health check path defaults to /"
}

test_webFleet_port_and_health_check_path_are_passed_through = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebFleet"
        metadata = {name = "web-fleet"}
        spec = {
            name = "web"
            vpcId = "vpc-0123456789abcdef0"
            subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
            imageId = "ami-0123456789abcdef0"
            port = 8080
            healthCheckPath = "/healthz"
        }
    }
    result = webfleet.composeWebFleet(oxr, _wfStageLbs)
    tg = _wfNamed(result, "target-group")[0]
    instanceIngress = _wfNamed(result, "instance-ingress")[0]

    assert tg.spec.forProvider.port == 8080
    assert tg.spec.forProvider.healthCheck.path == "/healthz"
    assert instanceIngress.spec.forProvider.fromPort == 8080
    assert instanceIngress.spec.forProvider.toPort == 8080
}

test_webFleet_alb_ingress_opens_the_listener_port_to_the_world = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg)
    ingressRule = _wfNamed(result, "alb-ingress")[0]

    assert ingressRule.apiVersion == "ec2.aws.m.upbound.io/v1beta1"
    assert ingressRule.kind == "SecurityGroupRule"
    assert ingressRule.spec.forProvider.securityGroupId == _wfAlbSgArn
    assert ingressRule.spec.forProvider.$type == "ingress"
    assert ingressRule.spec.forProvider.$protocol == "tcp"
    assert ingressRule.spec.forProvider.fromPort == 80
    assert ingressRule.spec.forProvider.toPort == 80
    assert ingressRule.spec.forProvider.cidrBlocks == ["0.0.0.0/0"]
}

test_webFleet_alb_ingress_waits_for_the_alb_security_group = lambda {
    result = webfleet.composeWebFleet(_wfOxr, {})

    assert len(_wfNamed(result, "alb-ingress")) == 0, "no ALB ingress ingressRule until the ALB security group is observed"
    assert len(_wfNamed(result, "load-balancer")) == 0, "no load balancer until the ALB security group is observed"
}

test_webFleet_launch_template_carries_user_data_base64_encoded = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebFleet"
        metadata = {name = "web-fleet"}
        spec = {
            name = "web"
            vpcId = "vpc-0123456789abcdef0"
            subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
            imageId = "ami-0123456789abcdef0"
            userData = _wfUserData
        }
    }
    result = webfleet.composeWebFleet(oxr, _wfStageSgs)
    lt = _wfNamed(result, "launch-template")[0]

    assert lt.spec.forProvider.userData == _wfUserDataBase64, "user data must be base64-encoded in the launch template"
}

test_webFleet_launch_template_without_user_data_sets_none = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageSgs)
    lt = _wfNamed(result, "launch-template")[0]

    assert not lt.spec.forProvider.userData, "no user data given, so none is set"
}

test_webFleet_launch_template_uses_image_type_and_instance_security_group = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageSgs)
    lt = _wfNamed(result, "launch-template")[0]

    assert lt.apiVersion == "ec2.aws.m.upbound.io/v1beta1"
    assert lt.kind == "LaunchTemplate"
    assert lt.spec.forProvider.name == "web"
    assert lt.spec.forProvider.region == "us-east-1"
    assert lt.spec.forProvider.imageId == "ami-0123456789abcdef0"
    assert lt.spec.forProvider.instanceType == "t3.micro", "instance type defaults to t3.micro"
    assert lt.spec.forProvider.vpcSecurityGroupIds == ["sg-0inst000000000000"]
}

test_webFleet_launch_template_waits_for_the_instance_security_group = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg)

    assert len(_wfNamed(result, "launch-template")) == 0, "no launch template until the instance security group is observed"
}

test_webFleet_instance_ingress_only_from_the_alb = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageSgs)
    ingressRule = _wfNamed(result, "instance-ingress")[0]

    assert ingressRule.kind == "SecurityGroupRule"
    assert ingressRule.spec.forProvider.securityGroupId == "sg-0inst000000000000"
    assert ingressRule.spec.forProvider.sourceSecurityGroupId == "sg-0alb0000000000000"
    assert ingressRule.spec.forProvider.$type == "ingress"
    assert ingressRule.spec.forProvider.fromPort == 80
    assert ingressRule.spec.forProvider.toPort == 80
    assert not ingressRule.spec.forProvider.cidrBlocks, "instances take no CIDR ingress"
}

test_webFleet_load_balancer_is_an_application_lb_in_the_subnets = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg)
    lb = _wfNamed(result, "load-balancer")[0]

    assert lb.apiVersion == "elbv2.aws.m.upbound.io/v1beta1"
    assert lb.kind == "LB"
    assert lb.spec.forProvider.name == "web"
    assert lb.spec.forProvider.loadBalancerType == "application"
    assert lb.spec.forProvider.internal == False
    assert lb.spec.forProvider.subnets == ["subnet-aaaa1111", "subnet-bbbb2222"]
    assert lb.spec.forProvider.securityGroups == [_wfAlbSgArn]
    assert lb.spec.forProvider.region == "us-east-1"
}

test_webFleet_listener_forwards_to_the_target_group = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageLbs)
    listener = _wfNamed(result, "listener")[0]
    action = listener.spec.forProvider.defaultAction[0]

    assert listener.kind == "LBListener"
    assert listener.spec.forProvider.port == 80
    assert listener.spec.forProvider.$protocol == "HTTP"
    assert listener.spec.forProvider.loadBalancerArn == "arn:aws:elasticloadbalancing:us-east-1:111111111111:loadbalancer/app/web/abcdef"
    assert action.$type == "forward"
    assert action.targetGroupArn == "arn:aws:elasticloadbalancing:us-east-1:111111111111:targetgroup/web/0123456789"
}

test_webFleet_listener_waits_for_the_load_balancer = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg | _wfInstanceSg | _wfTargetGroup)

    assert len(_wfNamed(result, "listener")) == 0, "no listener until the load balancer is observed"
}

test_webFleet_autoscaling_group_sizes_and_subnets_default = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageAll)
    asg = _wfNamed(result, "autoscaling-group")[0]

    assert asg.apiVersion == "autoscaling.aws.m.upbound.io/v1beta1"
    assert asg.kind == "AutoscalingGroup"
    assert asg.spec.forProvider.minSize == 1
    assert asg.spec.forProvider.maxSize == 2
    assert asg.spec.forProvider.vpcZoneIdentifier == ["subnet-aaaa1111", "subnet-bbbb2222"]
    assert asg.spec.forProvider.region == "us-east-1"
}

test_webFleet_autoscaling_group_uses_the_launch_template_and_attaches_the_target_group = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageAll)
    asg = _wfNamed(result, "autoscaling-group")[0]

    assert asg.spec.forProvider.launchTemplate.id == "lt-0123456789abcdef0"
    assert asg.spec.forProvider.launchTemplate.version == "$Latest"
    assert asg.spec.forProvider.trafficSource[0].identifier == "arn:aws:elasticloadbalancing:us-east-1:111111111111:targetgroup/web/0123456789"
    assert asg.spec.forProvider.trafficSource[0].$type == "elbv2"
}

test_webFleet_autoscaling_group_waits_for_the_launch_template = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg | _wfInstanceSg | _wfTargetGroup | _wfLoadBalancer)

    assert len(_wfNamed(result, "autoscaling-group")) == 0, "no ASG until the launch template is observed"
}

test_webFleet_stages_emit_what_is_ready = lambda {
    assert len(_wfComposed(webfleet.composeWebFleet(_wfOxr, _wfAlbSg))) == 5, "ALB security group observed: adds the ALB ingress ingressRule and the load balancer"
    assert len(_wfComposed(webfleet.composeWebFleet(_wfOxr, _wfStageSgs))) == 9, "both security groups observed: adds the launch template, ingress and egress rules"
    assert len(_wfComposed(webfleet.composeWebFleet(_wfOxr, _wfStageLbs))) == 11, "load balancer, target group and launch template observed: adds the listener and the ASG"
    assert len(_wfComposed(webfleet.composeWebFleet(_wfOxr, _wfStageAll))) == 11, "fully observed emits the same resources"
}

test_webFleet_status_reports_the_load_balancer_once_its_dns_name_is_known = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageLbs)
    xr = _wfXr(result)[0]

    assert xr.kind == "WebFleet"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.status.loadBalancerArn == "arn:aws:elasticloadbalancing:us-east-1:111111111111:loadbalancer/app/web/abcdef"
    assert xr.status.loadBalancerDnsName == "web-123456.us-east-1.elb.amazonaws.com"
}

test_webFleet_no_status_before_the_load_balancer_has_a_dns_name = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg | _wfInstanceSg | _wfTargetGroup)

    assert len(_wfXr(result)) == 0, "no status until the load balancer has a DNS name"
}

test_webFleet_spec_accepts_two_subnets_and_ordered_sizes = lambda {
    spec = schemas_compositions.WebFleetSpec {
        name = "web"
        vpcId = "vpc-0123456789abcdef0"
        subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
        imageId = "ami-0123456789abcdef0"
        minSize = 2
        maxSize = 4
    }

    assert spec.region == "us-east-1"
    assert spec.instanceType == "t3.micro"
}

test_webFleet_instances_use_instance_subnets_when_given = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebFleet"
        metadata = {name = "web-fleet"}
        spec = {
            name = "web"
            vpcId = "vpc-0123456789abcdef0"
            subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
            instanceSubnetIds = ["subnet-cccc3333", "subnet-dddd4444"]
            imageId = "ami-0123456789abcdef0"
        }
    }
    result = webfleet.composeWebFleet(oxr, _wfStageAll)
    asg = _wfNamed(result, "autoscaling-group")[0]
    lb = _wfNamed(result, "load-balancer")[0]

    assert asg.spec.forProvider.vpcZoneIdentifier == ["subnet-cccc3333", "subnet-dddd4444"], "instances use their own subnets"
    assert lb.spec.forProvider.subnets == ["subnet-aaaa1111", "subnet-bbbb2222"], "the load balancer keeps subnetIds"
}

test_webFleet_alb_egress_reaches_the_instances_on_the_app_port = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageSgs)
    egressRule = _wfNamed(result, "alb-egress")[0]

    assert egressRule.kind == "SecurityGroupRule"
    assert egressRule.spec.forProvider.$type == "egress", "egress is a rule the ALB sends"
    assert egressRule.spec.forProvider.securityGroupId == "sg-0alb0000000000000"
    assert egressRule.spec.forProvider.sourceSecurityGroupId == "sg-0inst000000000000", "destination: the instances"
    assert egressRule.spec.forProvider.fromPort == 80
    assert egressRule.spec.forProvider.toPort == 80
}

test_webFleet_alb_egress_waits_for_both_security_groups = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg)

    assert len(_wfNamed(result, "alb-egress")) == 0, "no ALB egress until the instance security group is observed"
}

test_webFleet_instance_egress_allows_outbound_for_package_installs = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageSgs)
    egressRule = _wfNamed(result, "instance-egress")[0]

    assert egressRule.spec.forProvider.$type == "egress"
    assert egressRule.spec.forProvider.securityGroupId == "sg-0inst000000000000"
    assert egressRule.spec.forProvider.$protocol == "-1", "all protocols, so the bootstrap can reach package mirrors"
    assert egressRule.spec.forProvider.cidrBlocks == ["0.0.0.0/0"]
}

test_webFleet_instance_egress_waits_for_the_instance_security_group = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg)

    assert len(_wfNamed(result, "instance-egress")) == 0, "no instance egress until the instance security group is observed"
}

_wfOfKind = lambda resources, kind {
    [r for r in _wfComposed(resources) if r.kind == kind]
}

_wfScheduledOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "WebFleet"
    metadata = {name = "web-fleet"}
    spec = {
        name = "web"
        vpcId = "vpc-0123456789abcdef0"
        subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
        imageId = "ami-0123456789abcdef0"
        scalingSchedules = [
            {name = "morning", recurrence = "0 8 * * MON-FRI", timeZone = "Europe/London", minSize = 2, maxSize = 6}
            {name = "night", recurrence = "0 20 * * *", minSize = 1, maxSize = 2}
            {name = "burst", recurrence = "0 12 * * SAT", desiredCapacity = 4}
        ]
    }
}

test_webFleet_scaling_schedules_are_absent_by_default = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageAll)

    assert len(_wfOfKind(result, "Schedule")) == 0, "no scheduled actions unless the spec asks for them"
}

test_webFleet_scaling_schedule_is_a_scheduled_action_on_the_fleet_asg = lambda {
    result = webfleet.composeWebFleet(_wfScheduledOxr, _wfStageAll)
    sched = _wfNamed(result, "scaling-schedule-morning")[0]

    assert sched.apiVersion == "autoscaling.aws.m.upbound.io/v1beta1"
    assert sched.kind == "Schedule"
    assert sched.spec.forProvider.region == "us-east-1"
    assert sched.spec.forProvider.recurrence == "0 8 * * MON-FRI"
    assert sched.spec.forProvider.autoscalingGroupNameSelector.matchControllerRef == True, "targets the ASG this fleet composes, found by controller reference"
}

test_webFleet_scaling_schedule_passes_sizes_and_time_zone = lambda {
    result = webfleet.composeWebFleet(_wfScheduledOxr, _wfStageAll)
    sched = _wfNamed(result, "scaling-schedule-morning")[0]

    assert sched.spec.forProvider.minSize == 2
    assert sched.spec.forProvider.maxSize == 6
    assert sched.spec.forProvider.timeZone == "Europe/London"
    assert sched.spec.forProvider.desiredCapacity == -1, "desired capacity not given: AWS leaves it unchanged"
}

test_webFleet_scaling_schedule_sends_minus_one_for_sizes_left_out = lambda {
    result = webfleet.composeWebFleet(_wfScheduledOxr, _wfStageAll)
    night = _wfNamed(result, "scaling-schedule-night")[0]

    assert night.spec.forProvider.desiredCapacity == -1, "AWS defaults an omitted size to 0, so -1 keeps it"
    assert night.spec.forProvider.minSize == 1
    assert night.spec.forProvider.maxSize == 2
    assert not night.spec.forProvider.timeZone, "no time zone given, so none is set"
}

test_webFleet_scaling_schedule_can_change_only_desired_capacity = lambda {
    result = webfleet.composeWebFleet(_wfScheduledOxr, _wfStageAll)
    burst = _wfNamed(result, "scaling-schedule-burst")[0]

    assert burst.spec.forProvider.recurrence == "0 12 * * SAT"
    assert burst.spec.forProvider.desiredCapacity == 4
    assert burst.spec.forProvider.minSize == -1, "minimum left unchanged"
    assert burst.spec.forProvider.maxSize == -1, "maximum left unchanged"
}

test_webFleet_scaling_schedules_wait_for_the_autoscaling_group = lambda {
    result = webfleet.composeWebFleet(_wfScheduledOxr, _wfAlbSg | _wfInstanceSg | _wfTargetGroup | _wfLoadBalancer)

    assert len(_wfOfKind(result, "Schedule")) == 0, "no scheduled actions until the ASG is emitted"
}

test_webFleet_scaling_schedules_add_one_resource_each = lambda {
    assert len(_wfComposed(webfleet.composeWebFleet(_wfScheduledOxr, _wfStageAll))) == 14, "fully observed: the 11 fleet resources plus one schedule per entry"
}

test_webFleet_scaling_schedule_spec_accepts_a_size_change = lambda {
    spec = schemas_compositions.ScalingScheduleSpec {
        name = "evening"
        recurrence = "0 18 * * *"
        minSize = 0
    }

    assert spec.minSize == 0, "zero is a real size, not a value left out"
}
