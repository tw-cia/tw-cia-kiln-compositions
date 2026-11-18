import .environment

_envOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "Environment"
    metadata = {name = "prod-environment"}
    spec = {
        name = "prod"
        network = {
            vpcId = "vpc-0123456789abcdef0"
            publicSubnetIds = ["subnet-pub-a", "subnet-pub-b"]
            privateSubnetIds = ["subnet-priv-a", "subnet-priv-b"]
        }
        webFleets = [{name = "web", imageId = "ami-0123456789abcdef0"}]
    }
}

_envOxrTwoFleets = _envOxr | {spec.webFleets = [
    {name = "web", imageId = "ami-0123456789abcdef0"}
    {name = "api", imageId = "ami-0fedcba9876543210", port = 8080, minSize = 2, maxSize = 4}
]}

_envOxrNoFleets = _envOxr | {spec.webFleets = []}

# The composed WebFleet child XRs, and the environment's own status.
_envChildren = lambda resources {
    [r for r in resources if r.kind != "Environment"]
}

_envXr = lambda resources {
    [r for r in resources if r.kind == "Environment"]
}

_envNamed = lambda resources, name {
    [r for r in _envChildren(resources) if r.metadata.annotations["krm.kcl.dev/composition-resource-name"] == name]
}

# A WebFleet child observed with its load balancer, as the cluster reports it.
_envWebFleetObserved = lambda dnsName {
    {Resource = {status = {
        loadBalancerDnsName = dnsName
        loadBalancerArn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:loadbalancer/app/prod-web/abcdef"
        conditions = [{"type" = "Ready", status = "True"}]
    }}}
}

test_environment_cold_start_emits_one_web_fleet_per_application = lambda {
    result = environment.composeEnvironment(_envOxr, {})

    assert len(_envChildren(result)) == 1, "one WebFleet child for the one application"
    assert _envChildren(result)[0].kind == "WebFleet"
    assert _envChildren(result)[0].apiVersion == "platform.demotw.com/v1alpha1"
    assert len(_envXr(result)) == 0, "cold start reports no status"
}

test_environment_web_fleet_child_is_named_after_environment_and_application = lambda {
    result = environment.composeEnvironment(_envOxr, {})
    child = _envNamed(result, "web-fleet-web")[0]

    assert child.spec.name == "prod-web", "AWS names are prefixed with the environment name"
    assert child.spec.region == "us-east-1"
}

test_environment_web_fleet_child_takes_the_environments_network = lambda {
    result = environment.composeEnvironment(_envOxr, {})
    spec = _envNamed(result, "web-fleet-web")[0].spec

    assert spec.network.vpcId == "vpc-0123456789abcdef0"
    assert spec.network.publicSubnetIds == ["subnet-pub-a", "subnet-pub-b"], "the load balancer uses the public subnets"
    assert spec.network.privateSubnetIds == ["subnet-priv-a", "subnet-priv-b"], "the instances use the private subnets"
}

test_environment_web_fleet_child_gets_the_application_defaults = lambda {
    result = environment.composeEnvironment(_envOxr, {})
    spec = _envNamed(result, "web-fleet-web")[0].spec

    assert spec.imageId == "ami-0123456789abcdef0"
    assert spec.instanceType == "t3.micro"
    assert spec.port == 80
    assert spec.healthCheckPath == "/"
    assert spec.minSize == 1
    assert spec.maxSize == 2
}

test_environment_web_fleet_child_passes_application_fields_through = lambda {
    oxr = _envOxr | {spec.webFleets = [{
        name = "api"
        imageId = "ami-0fedcba9876543210"
        instanceType = "m5.large"
        port = 8080
        healthCheckPath = "/health"
        minSize = 2
        maxSize = 6
        userData = "#!/bin/bash\necho api\n"
    }]}
    result = environment.composeEnvironment(oxr, {})
    spec = _envNamed(result, "web-fleet-api")[0].spec

    assert spec.name == "prod-api"
    assert spec.instanceType == "m5.large"
    assert spec.port == 8080
    assert spec.healthCheckPath == "/health"
    assert spec.minSize == 2
    assert spec.maxSize == 6
    assert spec.userData == "#!/bin/bash\necho api\n"
}

test_environment_emits_no_children_without_applications = lambda {
    result = environment.composeEnvironment(_envOxrNoFleets, {})

    assert len(_envChildren(result)) == 0, "an environment with no applications has only its network"
    assert len(_envXr(result)) == 0
}

test_environment_one_child_per_application_with_distinct_names = lambda {
    result = environment.composeEnvironment(_envOxrTwoFleets, {})

    assert len(_envChildren(result)) == 2
    assert len(_envNamed(result, "web-fleet-web")) == 1
    assert len(_envNamed(result, "web-fleet-api")) == 1
    assert _envNamed(result, "web-fleet-api")[0].spec.port == 8080
    assert _envNamed(result, "web-fleet-api")[0].spec.minSize == 2
}

test_environment_status_is_absent_until_a_fleet_has_a_load_balancer = lambda {
    result = environment.composeEnvironment(_envOxrTwoFleets, {"web-fleet-web": {Resource = {status = {}}}})

    assert len(_envXr(result)) == 0, "no load balancer observed yet, so no status"
}

test_environment_status_reports_observed_fleets_only = lambda {
    ocds = {"web-fleet-web": _envWebFleetObserved("prod-web-123.us-east-1.elb.amazonaws.com")}
    result = environment.composeEnvironment(_envOxrTwoFleets, ocds)
    xr = _envXr(result)[0]

    assert len(xr.status.webFleetDnsNames) == 1, "only the web fleet is observed, so only it is reported"
    assert xr.status.webFleetDnsNames["web"] == "prod-web-123.us-east-1.elb.amazonaws.com"
}

test_environment_status_reports_every_fleet_once_all_are_observed = lambda {
    ocds = {
        "web-fleet-web": _envWebFleetObserved("prod-web-123.us-east-1.elb.amazonaws.com")
        "web-fleet-api": _envWebFleetObserved("prod-api-456.us-east-1.elb.amazonaws.com")
    }
    result = environment.composeEnvironment(_envOxrTwoFleets, ocds)
    xr = _envXr(result)[0]

    assert len(xr.status.webFleetDnsNames) == 2
    assert xr.status.webFleetDnsNames["api"] == "prod-api-456.us-east-1.elb.amazonaws.com"
}

test_environment_children_keep_emitting_while_status_is_reported = lambda {
    ocds = {"web-fleet-web": _envWebFleetObserved("prod-web-123.us-east-1.elb.amazonaws.com")}
    result = environment.composeEnvironment(_envOxrTwoFleets, ocds)

    assert len(_envChildren(result)) == 2, "the children stay in the desired state after their status is reported"
}
