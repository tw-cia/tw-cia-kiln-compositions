import .webfleet
import .schemas_compositions

_wfDomain = {name = "web.example.com", hostedZoneId = "Z0123456789ABCDEFGHIJ"}

_wfOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "WebFleet"
    metadata = {name = "web-fleet"}
    spec = {
        name = "web"
        domain = _wfDomain
        network = {vpcId = "vpc-0123456789abcdef0", publicSubnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"], privateSubnetIds = ["subnet-cccc3333", "subnet-dddd4444"]}
        imageId = "ami-0123456789abcdef0"
    }
}

_wfUserData = "#!/bin/bash\necho hello from the fleet\n"
_wfUserDataBase64 = "IyEvYmluL2Jhc2gKZWNobyBoZWxsbyBmcm9tIHRoZSBmbGVldAo="

_wfCertArn = "arn:aws:acm:us-east-1:111111111111:certificate/web-example"
_wfLbArn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:loadbalancer/app/web/abcdef"
_wfTargetGroupArn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:targetgroup/web/0123456789"
_wfLbDnsName = "web-123456.us-east-1.elb.amazonaws.com"
_wfLbZoneId = "Z35SXDOTRQ7X7K"

_wfAlbSgArn = "sg-0alb0000000000000"
_wfAlbSg = {"alb-security-group" = {Resource = {status = {atProvider = {id = "sg-0alb0000000000000"}}}}}
_wfInstanceSg = {"instance-security-group" = {Resource = {status = {atProvider = {id = "sg-0inst000000000000"}}}}}
_wfTargetGroup = {"target-group" = {Resource = {status = {atProvider = {arn = _wfTargetGroupArn}}}}}
_wfLoadBalancer = {"load-balancer" = {Resource = {status = {atProvider = {
    arn = _wfLbArn
    dnsName = _wfLbDnsName
    zoneId = _wfLbZoneId
}}}}}
_wfLaunchTemplate = {"launch-template" = {Resource = {status = {atProvider = {id = "lt-0123456789abcdef0"}}}}}

# The certificate is a child XR: its status is read uncast, so it carries conditions too.
_wfCertPending = {certificate = {Resource = {status = {certificateArn = _wfCertArn, validated = False, conditions = [{"type" = "Ready", status = "False"}]}}}}
_wfCertValidated = {certificate = {Resource = {status = {certificateArn = _wfCertArn, validated = True, conditions = [{"type" = "Ready", status = "True"}]}}}}

_wfStageSgs = _wfAlbSg | _wfInstanceSg
_wfStageLbs = _wfAlbSg | _wfInstanceSg | _wfTargetGroup | _wfLoadBalancer | _wfLaunchTemplate
_wfStageAll = _wfStageLbs | _wfCertValidated

_wfComposed = lambda resources {
    [r for r in resources if r.kind != "WebFleet"]
}

_wfXr = lambda resources {
    [r for r in resources if r.kind == "WebFleet"]
}

_wfNamed = lambda resources, name {
    [r for r in _wfComposed(resources) if r.metadata.annotations["krm.kcl.dev/composition-resource-name"] == name]
}

_wfOfKind = lambda resources, kind {
    [r for r in _wfComposed(resources) if r.kind == kind]
}

test_webFleet_cold_start_emits_security_groups_target_group_and_certificate = lambda {
    result = webfleet.composeWebFleet(_wfOxr, {})

    assert len(_wfComposed(result)) == 4, "cold start: two security groups, the target group and the certificate"
    assert len(_wfXr(result)) == 0, "cold start reports no status"
}

test_webFleet_certificate_is_a_child_tls_certificate_for_the_domain = lambda {
    result = webfleet.composeWebFleet(_wfOxr, {})
    cert = _wfNamed(result, "certificate")[0]

    assert cert.apiVersion == "platform.demotw.com/v1alpha1"
    assert cert.kind == "TlsCertificate"
    assert cert.spec.domainName == "web.example.com"
    assert cert.spec.hostedZoneId == "Z0123456789ABCDEFGHIJ"
    assert cert.spec.region == "us-east-1"
}

test_webFleet_certificate_is_in_the_load_balancer_region = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebFleet"
        metadata = {name = "web-fleet"}
        spec = {
            name = "web"
            domain = _wfDomain
            region = "eu-west-1"
            network = {vpcId = "vpc-0123456789abcdef0", publicSubnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"], privateSubnetIds = ["subnet-cccc3333", "subnet-dddd4444"]}
            imageId = "ami-0123456789abcdef0"
        }
    }
    result = webfleet.composeWebFleet(oxr, {})

    assert _wfNamed(result, "certificate")[0].spec.region == "eu-west-1", "an ALB needs its certificate in its own region"
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
            domain = _wfDomain
            network = {vpcId = "vpc-0123456789abcdef0", publicSubnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"], privateSubnetIds = ["subnet-cccc3333", "subnet-dddd4444"]}
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

test_webFleet_alb_ingress_opens_port_80_to_the_world = lambda {
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

test_webFleet_alb_ingress_opens_port_443_to_the_world = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg)
    ingressRule = _wfNamed(result, "alb-https-ingress")[0]

    assert ingressRule.kind == "SecurityGroupRule"
    assert ingressRule.spec.forProvider.securityGroupId == _wfAlbSgArn
    assert ingressRule.spec.forProvider.$type == "ingress"
    assert ingressRule.spec.forProvider.fromPort == 443
    assert ingressRule.spec.forProvider.toPort == 443
    assert ingressRule.spec.forProvider.cidrBlocks == ["0.0.0.0/0"]
}

test_webFleet_alb_ingress_waits_for_the_alb_security_group = lambda {
    result = webfleet.composeWebFleet(_wfOxr, {})

    assert len(_wfNamed(result, "alb-ingress")) == 0, "no ALB ingress rule until the ALB security group is observed"
    assert len(_wfNamed(result, "alb-https-ingress")) == 0, "no HTTPS ingress rule until the ALB security group is observed"
    assert len(_wfNamed(result, "load-balancer")) == 0, "no load balancer until the ALB security group is observed"
}

test_webFleet_launch_template_carries_user_data_base64_encoded = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebFleet"
        metadata = {name = "web-fleet"}
        spec = {
            name = "web"
            domain = _wfDomain
            network = {vpcId = "vpc-0123456789abcdef0", publicSubnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"], privateSubnetIds = ["subnet-cccc3333", "subnet-dddd4444"]}
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

test_webFleet_https_listener_terminates_tls_and_forwards_to_the_target_group = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageAll)
    listener = _wfNamed(result, "https-listener")[0]
    action = listener.spec.forProvider.defaultAction[0]

    assert listener.kind == "LBListener"
    assert listener.spec.forProvider.port == 443
    assert listener.spec.forProvider.$protocol == "HTTPS"
    assert listener.spec.forProvider.certificateArn == _wfCertArn, "the validated certificate from the child"
    assert listener.spec.forProvider.sslPolicy == "ELBSecurityPolicy-TLS13-1-2-2021-06"
    assert listener.spec.forProvider.loadBalancerArn == _wfLbArn
    assert action.$type == "forward"
    assert action.targetGroupArn == _wfTargetGroupArn
}

test_webFleet_https_listener_waits_for_the_validated_certificate = lambda {
    pending = webfleet.composeWebFleet(_wfOxr, _wfStageLbs | _wfCertPending)

    assert len(_wfNamed(pending, "https-listener")) == 0, "no HTTPS listener until the certificate is validated"
    assert len(_wfNamed(webfleet.composeWebFleet(_wfOxr, _wfStageLbs), "https-listener")) == 0, "no certificate observed yet"
}

test_webFleet_http_listener_redirects_everything_to_https = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageAll)
    listener = _wfNamed(result, "http-listener")[0]
    action = listener.spec.forProvider.defaultAction[0]

    assert listener.spec.forProvider.port == 80
    assert listener.spec.forProvider.$protocol == "HTTP"
    assert action.$type == "redirect"
    assert action.redirect.$protocol == "HTTPS"
    assert action.redirect.port == "443"
    assert action.redirect.statusCode == "HTTP_301"
}

test_webFleet_http_listener_waits_for_the_validated_certificate = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageLbs | _wfCertPending)

    assert len(_wfNamed(result, "http-listener")) == 0, "no redirect to an HTTPS listener that does not exist yet"
}

test_webFleet_domain_points_at_the_load_balancer = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageAll)
    record = _wfNamed(result, "alias-record")[0]

    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.kind == "Record"
    assert record.spec.forProvider.zoneId == "Z0123456789ABCDEFGHIJ"
    assert record.spec.forProvider.name == "web.example.com"
    assert record.spec.forProvider.$type == "A"
    assert record.spec.forProvider.alias.name == _wfLbDnsName
    assert record.spec.forProvider.alias.zoneId == _wfLbZoneId, "the load balancer's own zone, as AWS reports it per region"
    assert record.spec.forProvider.alias.evaluateTargetHealth == True
}

test_webFleet_domain_waits_for_the_load_balancer = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg)

    assert len(_wfNamed(result, "alias-record")) == 0, "no record until the load balancer has a DNS name"
}

test_webFleet_autoscaling_group_sizes_and_private_subnets = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageAll)
    asg = _wfNamed(result, "autoscaling-group")[0]

    assert asg.apiVersion == "autoscaling.aws.m.upbound.io/v1beta1"
    assert asg.kind == "AutoscalingGroup"
    assert asg.spec.forProvider.minSize == 1
    assert asg.spec.forProvider.maxSize == 2
    assert asg.spec.forProvider.vpcZoneIdentifier == ["subnet-cccc3333", "subnet-dddd4444"], "instances run in the private subnets"
    assert asg.spec.forProvider.region == "us-east-1"
}

test_webFleet_autoscaling_group_uses_the_launch_template_and_attaches_the_target_group = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageAll)
    asg = _wfNamed(result, "autoscaling-group")[0]

    assert asg.spec.forProvider.launchTemplate.id == "lt-0123456789abcdef0"
    assert asg.spec.forProvider.launchTemplate.version == "$Latest"
    assert asg.spec.forProvider.trafficSource[0].identifier == _wfTargetGroupArn
    assert asg.spec.forProvider.trafficSource[0].$type == "elbv2"
}

test_webFleet_autoscaling_group_waits_for_the_launch_template = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg | _wfInstanceSg | _wfTargetGroup | _wfLoadBalancer)

    assert len(_wfNamed(result, "autoscaling-group")) == 0, "no ASG until the launch template is observed"
}

test_webFleet_stages_emit_what_is_ready = lambda {
    assert len(_wfComposed(webfleet.composeWebFleet(_wfOxr, _wfAlbSg))) == 7, "ALB security group observed: adds the two ALB ingress rules and the load balancer"
    assert len(_wfComposed(webfleet.composeWebFleet(_wfOxr, _wfStageSgs))) == 11, "both security groups observed: adds the launch template, instance rules and ALB egress"
    assert len(_wfComposed(webfleet.composeWebFleet(_wfOxr, _wfStageLbs))) == 13, "load balancer, target group and launch template observed: adds the ASG and the domain's record, no listeners until the certificate is validated"
    assert len(_wfComposed(webfleet.composeWebFleet(_wfOxr, _wfStageAll))) == 15, "certificate validated: adds the HTTPS and redirect listeners and the domain's record"
}

test_webFleet_status_reports_the_load_balancer_once_its_dns_name_is_known = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageLbs)
    xr = _wfXr(result)[0]

    assert xr.kind == "WebFleet"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.status.loadBalancerArn == _wfLbArn
    assert xr.status.loadBalancerDnsName == _wfLbDnsName
}

test_webFleet_no_status_before_the_load_balancer_has_a_dns_name = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfAlbSg | _wfInstanceSg | _wfTargetGroup)

    assert len(_wfXr(result)) == 0, "no status until the load balancer has a DNS name"
}

test_webFleet_spec_accepts_two_subnets_and_ordered_sizes = lambda {
    spec = schemas_compositions.WebFleetSpec {
        name = "web"
        domain = _wfDomain
        network = {vpcId = "vpc-0123456789abcdef0", publicSubnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"], privateSubnetIds = ["subnet-cccc3333", "subnet-dddd4444"]}
        imageId = "ami-0123456789abcdef0"
        minSize = 2
        maxSize = 4
    }

    assert spec.region == "us-east-1"
    assert spec.instanceType == "t3.micro"
    assert spec.domain.name == "web.example.com"
}

test_webFleet_load_balancer_uses_public_subnets_and_instances_use_private_ones = lambda {
    result = webfleet.composeWebFleet(_wfOxr, _wfStageAll)
    asg = _wfNamed(result, "autoscaling-group")[0]
    lb = _wfNamed(result, "load-balancer")[0]

    assert lb.spec.forProvider.subnets == ["subnet-aaaa1111", "subnet-bbbb2222"], "the load balancer is internet-facing, so it uses the public subnets"
    assert asg.spec.forProvider.vpcZoneIdentifier == ["subnet-cccc3333", "subnet-dddd4444"], "the instances use the private subnets"
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

_wfScheduledOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "WebFleet"
    metadata = {name = "web-fleet"}
    spec = {
        name = "web"
        domain = _wfDomain
        network = {vpcId = "vpc-0123456789abcdef0", publicSubnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"], privateSubnetIds = ["subnet-cccc3333", "subnet-dddd4444"]}
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
    assert len(_wfComposed(webfleet.composeWebFleet(_wfScheduledOxr, _wfStageAll))) == 18, "fully observed: the 15 fleet resources plus one schedule per entry"
}

test_webFleet_scaling_schedule_spec_accepts_a_size_change = lambda {
    spec = schemas_compositions.ScalingScheduleSpec {
        name = "evening"
        recurrence = "0 18 * * *"
        minSize = 0
    }

    assert spec.minSize == 0, "zero is a real size, not a value left out"
}
