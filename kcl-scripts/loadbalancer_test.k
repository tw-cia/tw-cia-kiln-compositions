import .loadbalancer

_loadBalancerCertificateArn = "arn:aws:acm:us-east-1:111111111111:certificate/example"

_loadBalancerOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "LoadBalancer"
    metadata.name = "web-lb"
    spec = {
        vpcId = "vpc-0123456789abcdef0"
        subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
        securityGroupIds = ["sg-0123456789abcdef0"]
        certificateArn = _loadBalancerCertificateArn
    }
}

_loadBalancerArn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:loadbalancer/app/web-lb/abc123"
_loadBalancerDnsName = "web-lb-1234567890.us-east-1.elb.amazonaws.com"
_loadBalancerTargetGroupArn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:targetgroup/web-lb/def456"

# The load balancer exists and reports its ARN and DNS name.
_loadBalancerObserved = {Resource = {status = {atProvider = {
    arn = _loadBalancerArn
    dnsName = _loadBalancerDnsName
    zoneId = "Z35SXDOTRQ7X7K"
}}}}

# The target group exists and reports its ARN.
_loadBalancerTargetGroupObserved = {Resource = {status = {atProvider = {
    arn = _loadBalancerTargetGroupArn
}}}}

_loadBalancerKinds = lambda result -> [str] {
    [r.kind for r in result]
}

# Cold start: nothing observed, so the load balancer and its target group are requested.
test_loadBalancer_cold_start_requests_the_load_balancer_and_target_group = lambda {
    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, {})

    assert _loadBalancerKinds(result) == ["LB", "LBTargetGroup"]
}

test_loadBalancer_is_an_internet_facing_application_load_balancer = lambda {
    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, {})

    lb = result[0]
    assert lb.apiVersion == "elbv2.aws.m.upbound.io/v1beta1"
    assert lb.kind == "LB"
    assert lb.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "load-balancer"
    # The provider reads an external name as the load balancer's ARN, so the name goes in forProvider.
    assert lb.spec.forProvider.name == "web-lb"
    assert "crossplane.io/external-name" not in lb.metadata.annotations
    assert lb.spec.forProvider.region == "us-east-1"
    assert lb.spec.forProvider.loadBalancerType == "application"
    assert lb.spec.forProvider.internal == False
    assert lb.spec.forProvider.subnets == ["subnet-aaaa1111", "subnet-bbbb2222"]
    assert lb.spec.forProvider.securityGroups == ["sg-0123456789abcdef0"]
}

test_loadBalancer_target_group_forwards_http_to_port_80_by_default = lambda {
    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, {})

    group = result[1]
    assert group.apiVersion == "elbv2.aws.m.upbound.io/v1beta1"
    assert group.kind == "LBTargetGroup"
    assert group.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "target-group"
    # The provider requires the name in forProvider, so it cannot come from the external-name alone.
    assert group.spec.forProvider.name == "web-lb"
    assert group.spec.forProvider.vpcId == "vpc-0123456789abcdef0"
    assert group.spec.forProvider.port == 80
    assert group.spec.forProvider["protocol"] == "HTTP"
    assert group.spec.forProvider.targetType == "instance"
}

test_loadBalancer_target_port_can_be_set = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "LoadBalancer"
        metadata.name = "web-lb"
        spec = {
            vpcId = "vpc-0123456789abcdef0"
            subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
            securityGroupIds = ["sg-0123456789abcdef0"]
            certificateArn = _loadBalancerCertificateArn
            targetPort = 8080
        }
    }

    result = loadbalancer.composeLoadBalancer(oxr, {})

    assert result[1].spec.forProvider.port == 8080
}

test_loadBalancer_region_can_be_set = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "LoadBalancer"
        metadata.name = "web-lb"
        spec = {
            region = "eu-west-1"
            vpcId = "vpc-0123456789abcdef0"
            subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
            securityGroupIds = ["sg-0123456789abcdef0"]
            certificateArn = _loadBalancerCertificateArn
        }
    }

    result = loadbalancer.composeLoadBalancer(oxr, {})

    assert result[0].spec.forProvider.region == "eu-west-1"
    assert result[1].spec.forProvider.region == "eu-west-1"
}

# The load balancer exists but has no ARN yet: the listener is not written.
test_loadBalancer_no_listener_until_the_load_balancer_is_observed = lambda {
    ocds = {"target-group" = _loadBalancerTargetGroupObserved}

    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, ocds)

    assert "LBListener" not in _loadBalancerKinds(result)
}

# The load balancer exists but the target group has no ARN yet: the listener is not written.
test_loadBalancer_no_listener_until_the_target_group_is_observed = lambda {
    ocds = {"load-balancer" = _loadBalancerObserved}

    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, ocds)

    assert "LBListener" not in _loadBalancerKinds(result)
}

# Both exist: the HTTPS listener uses the existing validated certificate.
test_loadBalancer_listener_reuses_the_certificate_on_port_443 = lambda {
    ocds = {"load-balancer" = _loadBalancerObserved, "target-group" = _loadBalancerTargetGroupObserved}

    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, ocds)

    listener = [r for r in result if r.kind == "LBListener"][0]
    assert listener.apiVersion == "elbv2.aws.m.upbound.io/v1beta1"
    assert listener.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "https-listener"
    assert listener.spec.forProvider.loadBalancerArn == _loadBalancerArn
    assert listener.spec.forProvider.port == 443
    assert listener.spec.forProvider["protocol"] == "HTTPS"
    assert listener.spec.forProvider.certificateArn == _loadBalancerCertificateArn
    assert listener.spec.forProvider.sslPolicy == "ELBSecurityPolicy-TLS13-1-2-2021-06"
    assert listener.spec.forProvider.region == "us-east-1"
}

test_loadBalancer_listener_forwards_to_the_target_group = lambda {
    ocds = {"load-balancer" = _loadBalancerObserved, "target-group" = _loadBalancerTargetGroupObserved}

    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, ocds)

    listener = [r for r in result if r.kind == "LBListener"][0]
    action = listener.spec.forProvider.defaultAction[0]
    assert action["type"] == "forward"
    assert action.targetGroupArn == _loadBalancerTargetGroupArn
}

# No attachment when the consumer names no auto-scaling group.
test_loadBalancer_no_attachment_without_an_auto_scaling_group = lambda {
    ocds = {"load-balancer" = _loadBalancerObserved, "target-group" = _loadBalancerTargetGroupObserved}

    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, ocds)

    assert "Attachment" not in _loadBalancerKinds(result)
}

_loadBalancerWithGroupOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "LoadBalancer"
    metadata.name = "web-lb"
    spec = {
        vpcId = "vpc-0123456789abcdef0"
        subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
        securityGroupIds = ["sg-0123456789abcdef0"]
        certificateArn = _loadBalancerCertificateArn
        autoScalingGroupName = "web-asg"
    }
}

# The group is named but the target group has no ARN yet: nothing to attach to.
test_loadBalancer_no_attachment_until_the_target_group_is_observed = lambda {
    ocds = {"load-balancer" = _loadBalancerObserved}

    result = loadbalancer.composeLoadBalancer(_loadBalancerWithGroupOxr, ocds)

    assert "Attachment" not in _loadBalancerKinds(result)
}

test_loadBalancer_attaches_the_auto_scaling_group_to_the_target_group = lambda {
    ocds = {"load-balancer" = _loadBalancerObserved, "target-group" = _loadBalancerTargetGroupObserved}

    result = loadbalancer.composeLoadBalancer(_loadBalancerWithGroupOxr, ocds)

    attachment = [r for r in result if r.kind == "Attachment"][0]
    assert attachment.apiVersion == "autoscaling.aws.m.upbound.io/v1beta1"
    assert attachment.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "asg-attachment"
    assert attachment.spec.forProvider.autoscalingGroupName == "web-asg"
    assert attachment.spec.forProvider.lbTargetGroupArn == _loadBalancerTargetGroupArn
    assert attachment.spec.forProvider.region == "us-east-1"
}

# No status until the load balancer exists.
test_loadBalancer_reports_no_status_before_the_load_balancer_exists = lambda {
    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, {"target-group" = _loadBalancerTargetGroupObserved})

    assert "LoadBalancer" not in _loadBalancerKinds(result)
}

test_loadBalancer_empty_load_balancer_observation_reports_no_status = lambda {
    ocds = {"load-balancer" = {Resource = {status = {atProvider = {}}}}}

    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, ocds)

    assert "LoadBalancer" not in _loadBalancerKinds(result)
    assert "LBListener" not in _loadBalancerKinds(result)
}

test_loadBalancer_reports_its_dns_name_and_arn_once_observed = lambda {
    ocds = {"load-balancer" = _loadBalancerObserved, "target-group" = _loadBalancerTargetGroupObserved}

    result = loadbalancer.composeLoadBalancer(_loadBalancerOxr, ocds)

    xr = result[-1]
    assert xr.kind == "LoadBalancer"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.metadata.name == "web-lb"
    assert xr.status.dnsName == _loadBalancerDnsName
    assert xr.status.loadBalancerArn == _loadBalancerArn
    # The hosted zone is what a parent needs to point a DNS alias at the load balancer.
    assert xr.status.zoneId == "Z35SXDOTRQ7X7K"
}
