import .webservice

_webServiceCertificateArn = "arn:aws:acm:us-east-1:111111111111:certificate/example"
_webServiceLoadBalancerZoneId = "Z35SXDOTRQ7X7K"
_webServiceLoadBalancerDnsName = "shop-1234567890.us-east-1.elb.amazonaws.com"

_webServiceOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "WebService"
    metadata.name = "shop"
    spec = {
        domainName = "shop.example.com"
        hostedZoneId = "Z123EXAMPLE"
        vpcId = "vpc-0123456789abcdef0"
        loadBalancerSubnetIds = ["subnet-pub-aaaa", "subnet-pub-bbbb"]
        instanceSubnetIds = ["subnet-priv-aaaa", "subnet-priv-bbbb"]
        loadBalancerSecurityGroupIds = ["sg-lb0123456789abcd"]
        instanceSecurityGroupIds = ["sg-inst0123456789ab"]
        imageId = "ami-0123456789abcdef0"
    }
}

# The certificate has an ARN but ACM has not issued it yet.
_webServiceCertificatePending = {Resource = {status = {
    certificateArn = _webServiceCertificateArn
    validated = False
}}}

# The certificate is issued. It carries conditions too, as a real XR does.
_webServiceCertificateValidated = {Resource = {status = {
    certificateArn = _webServiceCertificateArn
    validated = True
    conditions = [{"type" = "Ready", status = "True"}]
}}}

# The load balancer exists and reports its DNS name and hosted zone.
_webServiceLoadBalancerObserved = {Resource = {status = {
    loadBalancerArn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:loadbalancer/app/shop/abc123"
    dnsName = _webServiceLoadBalancerDnsName
    zoneId = _webServiceLoadBalancerZoneId
    conditions = [{"type" = "Ready", status = "True"}]
}}}

_webServiceKinds = lambda result -> [str] {
    [r.kind for r in result]
}

# Cold start: nothing observed, so the certificate and the auto-scaling group are requested.
test_webService_cold_start_requests_the_certificate_and_auto_scaling_group = lambda {
    result = webservice.composeWebService(_webServiceOxr, {})

    assert _webServiceKinds(result) == ["TlsCertificate", "AutoScalingGroup"]
}

test_webService_requests_a_certificate_for_the_domain = lambda {
    result = webservice.composeWebService(_webServiceOxr, {})

    cert = result[0]
    assert cert.apiVersion == "platform.demotw.com/v1alpha1"
    assert cert.kind == "TlsCertificate"
    assert cert.metadata.name == "shop-certificate"
    assert cert.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "certificate"
    assert cert.spec.domainName == "shop.example.com"
    assert cert.spec.hostedZoneId == "Z123EXAMPLE"
    assert cert.spec.region == "us-east-1"
}

# An ALB only accepts a certificate from its own region, so the certificate follows the load balancer.
test_webService_certificate_and_load_balancer_share_the_region = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebService"
        metadata.name = "shop"
        spec = {
            domainName = "shop.example.com"
            hostedZoneId = "Z123EXAMPLE"
            region = "eu-west-1"
            vpcId = "vpc-0123456789abcdef0"
            loadBalancerSubnetIds = ["subnet-pub-aaaa", "subnet-pub-bbbb"]
        instanceSubnetIds = ["subnet-priv-aaaa", "subnet-priv-bbbb"]
            loadBalancerSecurityGroupIds = ["sg-lb0123456789abcd"]
        instanceSecurityGroupIds = ["sg-inst0123456789ab"]
            imageId = "ami-0123456789abcdef0"
        }
    }
    ocds = {certificate = _webServiceCertificateValidated}

    result = webservice.composeWebService(oxr, ocds)

    assert [r for r in result if r.kind == "TlsCertificate"][0].spec.region == "eu-west-1"
    assert [r for r in result if r.kind == "AutoScalingGroup"][0].spec.region == "eu-west-1"
    assert [r for r in result if r.kind == "LoadBalancer"][0].spec.region == "eu-west-1"
}

test_webService_auto_scaling_group_takes_the_instance_settings = lambda {
    result = webservice.composeWebService(_webServiceOxr, {})

    group = [r for r in result if r.kind == "AutoScalingGroup"][0]
    assert group.apiVersion == "platform.demotw.com/v1alpha1"
    assert group.metadata.name == "shop-asg"
    assert group.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "auto-scaling-group"
    assert group.spec.imageId == "ami-0123456789abcdef0"
    assert group.spec.instanceType == "t3.micro"
    assert group.spec.subnetIds == ["subnet-priv-aaaa", "subnet-priv-bbbb"]
    assert group.spec.securityGroupIds == ["sg-inst0123456789ab"]
    assert group.spec.minSize == 1
    assert group.spec.maxSize == 3
}

test_webService_auto_scaling_group_omits_desired_capacity_when_unset = lambda {
    result = webservice.composeWebService(_webServiceOxr, {})

    group = [r for r in result if r.kind == "AutoScalingGroup"][0]
    assert not group.spec.desiredCapacity
}

test_webService_passes_sizing_through_when_set = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebService"
        metadata.name = "shop"
        spec = {
            domainName = "shop.example.com"
            hostedZoneId = "Z123EXAMPLE"
            vpcId = "vpc-0123456789abcdef0"
            loadBalancerSubnetIds = ["subnet-pub-aaaa", "subnet-pub-bbbb"]
        instanceSubnetIds = ["subnet-priv-aaaa", "subnet-priv-bbbb"]
            loadBalancerSecurityGroupIds = ["sg-lb0123456789abcd"]
        instanceSecurityGroupIds = ["sg-inst0123456789ab"]
            imageId = "ami-0123456789abcdef0"
            instanceType = "m5.large"
            minSize = 2
            maxSize = 8
            desiredCapacity = 4
        }
    }

    result = webservice.composeWebService(oxr, {})

    group = [r for r in result if r.kind == "AutoScalingGroup"][0]
    assert group.spec.instanceType == "m5.large"
    assert group.spec.minSize == 2
    assert group.spec.maxSize == 8
    assert group.spec.desiredCapacity == 4
}

# The certificate has an ARN but is not issued: the load balancer waits for it.
test_webService_no_load_balancer_until_the_certificate_is_validated = lambda {
    ocds = {certificate = _webServiceCertificatePending}

    result = webservice.composeWebService(_webServiceOxr, ocds)

    assert "LoadBalancer" not in _webServiceKinds(result)
}

# Once issued, the load balancer is requested with the reused certificate, from the group's name.
test_webService_load_balancer_reuses_the_validated_certificate = lambda {
    ocds = {certificate = _webServiceCertificateValidated}

    result = webservice.composeWebService(_webServiceOxr, ocds)

    lb = [r for r in result if r.kind == "LoadBalancer"][0]
    assert lb.apiVersion == "platform.demotw.com/v1alpha1"
    assert lb.metadata.name == "shop-lb"
    assert lb.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "load-balancer"
    assert lb.spec.certificateArn == _webServiceCertificateArn
    assert lb.spec.vpcId == "vpc-0123456789abcdef0"
    assert lb.spec.subnetIds == ["subnet-pub-aaaa", "subnet-pub-bbbb"]
    assert lb.spec.securityGroupIds == ["sg-lb0123456789abcd"]
    assert lb.spec.targetPort == 80
    assert lb.spec.autoScalingGroupName == "shop-asg"
}

test_webService_load_balancer_passes_the_target_port_through = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebService"
        metadata.name = "shop"
        spec = {
            domainName = "shop.example.com"
            hostedZoneId = "Z123EXAMPLE"
            vpcId = "vpc-0123456789abcdef0"
            loadBalancerSubnetIds = ["subnet-pub-aaaa", "subnet-pub-bbbb"]
        instanceSubnetIds = ["subnet-priv-aaaa", "subnet-priv-bbbb"]
            loadBalancerSecurityGroupIds = ["sg-lb0123456789abcd"]
        instanceSecurityGroupIds = ["sg-inst0123456789ab"]
            imageId = "ami-0123456789abcdef0"
            targetPort = 8080
        }
    }
    ocds = {certificate = _webServiceCertificateValidated}

    result = webservice.composeWebService(oxr, ocds)

    assert [r for r in result if r.kind == "LoadBalancer"][0].spec.targetPort == 8080
}

# The load balancer is requested but has no DNS name yet: no alias record.
test_webService_no_alias_record_until_the_load_balancer_is_observed = lambda {
    ocds = {certificate = _webServiceCertificateValidated}

    result = webservice.composeWebService(_webServiceOxr, ocds)

    assert "Record" not in _webServiceKinds(result)
}

test_webService_points_the_domain_at_the_load_balancer = lambda {
    ocds = {certificate = _webServiceCertificateValidated, "load-balancer" = _webServiceLoadBalancerObserved}

    result = webservice.composeWebService(_webServiceOxr, ocds)

    record = [r for r in result if r.kind == "Record"][0]
    assert record.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert record.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "domain-alias"
    assert record.spec.forProvider.zoneId == "Z123EXAMPLE"
    assert record.spec.forProvider.name == "shop.example.com"
    assert record.spec.forProvider["type"] == "A"
    assert record.spec.forProvider.alias.name == _webServiceLoadBalancerDnsName
    assert record.spec.forProvider.alias.zoneId == _webServiceLoadBalancerZoneId
    assert record.spec.forProvider.alias.evaluateTargetHealth
}

# No status until the alias exists, so the site is not reported before it is reachable.
test_webService_reports_no_status_before_the_alias_exists = lambda {
    ocds = {certificate = _webServiceCertificateValidated}

    result = webservice.composeWebService(_webServiceOxr, ocds)

    assert "WebService" not in _webServiceKinds(result)
}

test_webService_reports_url_and_load_balancer_name_once_the_alias_exists = lambda {
    ocds = {certificate = _webServiceCertificateValidated, "load-balancer" = _webServiceLoadBalancerObserved}

    result = webservice.composeWebService(_webServiceOxr, ocds)

    xr = result[-1]
    assert xr.kind == "WebService"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.metadata.name == "shop"
    assert xr.status.url == "https://shop.example.com"
    assert xr.status.loadBalancerDnsName == _webServiceLoadBalancerDnsName
}

# An empty observation is not an issued certificate, so nothing beyond the cold start is requested.
test_webService_empty_certificate_observation_requests_nothing_more = lambda {
    ocds = {certificate = {Resource = {status = {}}}}

    result = webservice.composeWebService(_webServiceOxr, ocds)

    assert _webServiceKinds(result) == ["TlsCertificate", "AutoScalingGroup"]
}

# The script is passed to the group as plain text: the group's function does the encoding.
test_webService_passes_user_data_to_the_auto_scaling_group = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebService"
        metadata.name = "shop"
        spec = {
            domainName = "shop.example.com"
            hostedZoneId = "Z123EXAMPLE"
            vpcId = "vpc-0123456789abcdef0"
            loadBalancerSubnetIds = ["subnet-pub-aaaa", "subnet-pub-bbbb"]
        instanceSubnetIds = ["subnet-priv-aaaa", "subnet-priv-bbbb"]
            loadBalancerSecurityGroupIds = ["sg-lb0123456789abcd"]
        instanceSecurityGroupIds = ["sg-inst0123456789ab"]
            imageId = "ami-0123456789abcdef0"
            userData = "#!/bin/bash\necho hello\n"
        }
    }

    result = webservice.composeWebService(oxr, {})

    group = [r for r in result if r.kind == "AutoScalingGroup"][0]
    assert group.spec.userData == "#!/bin/bash\necho hello\n"
}

test_webService_omits_user_data_when_unset = lambda {
    result = webservice.composeWebService(_webServiceOxr, {})

    group = [r for r in result if r.kind == "AutoScalingGroup"][0]
    assert not group.spec.userData
}
