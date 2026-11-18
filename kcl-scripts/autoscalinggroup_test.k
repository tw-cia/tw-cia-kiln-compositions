import .autoscalinggroup

_autoScalingGroupOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "AutoScalingGroup"
    metadata.name = "web-asg"
    spec = {
        imageId = "ami-0123456789abcdef0"
        subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
    }
}

# The launch template exists and reports its id.
_autoScalingGroupLaunchTemplateObserved = {Resource = {status = {atProvider = {
    id = "lt-0123456789abcdef0"
    arn = "arn:aws:ec2:us-east-1:111111111111:launch-template/lt-0123456789abcdef0"
    latestVersion = 1
}}}}

_autoScalingGroupUserData = "#!/bin/bash\necho hello\n"

# The launch template and the group both exist; the group reports its ARN.
_autoScalingGroupGroupObserved = {Resource = {status = {atProvider = {
    arn = "arn:aws:autoscaling:us-east-1:111111111111:autoScalingGroup:uuid:autoScalingGroupName/web-asg"
}}}}

_autoScalingGroupFullyObserved = {
    "launch-template" = _autoScalingGroupLaunchTemplateObserved
    "auto-scaling-group" = _autoScalingGroupGroupObserved
}

_autoScalingGroupKinds = lambda result -> [str] {
    [r.kind for r in result]
}

# Cold start: nothing observed, so only the launch template is requested.
test_autoScalingGroup_cold_start_requests_only_the_launch_template = lambda {
    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, {})

    assert _autoScalingGroupKinds(result) == ["LaunchTemplate"]
}

test_autoScalingGroup_launch_template_is_named_after_the_xr = lambda {
    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, {})

    template = result[0]
    assert template.apiVersion == "ec2.aws.m.upbound.io/v1beta1"
    assert template.kind == "LaunchTemplate"
    assert template.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "launch-template"
    assert template.metadata.annotations["crossplane.io/external-name"] == "web-asg"
    assert template.spec.forProvider.region == "us-east-1"
    assert template.spec.forProvider.imageId == "ami-0123456789abcdef0"
    assert template.spec.forProvider.instanceType == "t3.micro"
}

test_autoScalingGroup_launch_template_passes_security_groups_when_set = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "AutoScalingGroup"
        metadata.name = "web-asg"
        spec = {
            imageId = "ami-0123456789abcdef0"
            instanceType = "m5.large"
            subnetIds = ["subnet-aaaa1111", "subnet-bbbb2222"]
            securityGroupIds = ["sg-0123456789abcdef0"]
        }
    }

    result = autoscalinggroup.composeAutoScalingGroup(oxr, {})

    assert result[0].spec.forProvider.instanceType == "m5.large"
    assert result[0].spec.forProvider.vpcSecurityGroupIds == ["sg-0123456789abcdef0"]
}

test_autoScalingGroup_launch_template_omits_security_groups_when_unset = lambda {
    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, {})

    # Undefined is dropped when serialised, so the field is never sent to AWS.
    assert not result[0].spec.forProvider.vpcSecurityGroupIds
}

# Empty atProvider: the template exists but has no id yet, so the group is not requested.
test_autoScalingGroup_empty_launch_template_observation_requests_no_group = lambda {
    ocds = {"launch-template" = {Resource = {status = {atProvider = {}}}}}

    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, ocds)

    assert _autoScalingGroupKinds(result) == ["LaunchTemplate"]
}

# Partly observed: the template has its id, so the group is requested from it.
test_autoScalingGroup_requests_the_group_once_the_template_has_an_id = lambda {
    ocds = {"launch-template" = _autoScalingGroupLaunchTemplateObserved}

    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, ocds)

    assert _autoScalingGroupKinds(result) == ["LaunchTemplate", "AutoscalingGroup"]
    group = result[1]
    assert group.apiVersion == "autoscaling.aws.m.upbound.io/v1beta1"
    assert group.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "auto-scaling-group"
    assert group.metadata.annotations["crossplane.io/external-name"] == "web-asg"
    assert group.spec.forProvider.region == "us-east-1"
    assert group.spec.forProvider.launchTemplate.id == "lt-0123456789abcdef0"
    # Pinned to the template's latest version, so a changed template is a new version the group can roll to.
    assert group.spec.forProvider.launchTemplate.version == "1"
    assert group.spec.forProvider.vpcZoneIdentifier == ["subnet-aaaa1111", "subnet-bbbb2222"]
}

test_autoScalingGroup_group_defaults_to_one_to_three_instances = lambda {
    ocds = {"launch-template" = _autoScalingGroupLaunchTemplateObserved}

    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, ocds)

    assert result[1].spec.forProvider.minSize == 1
    assert result[1].spec.forProvider.maxSize == 3
}

test_autoScalingGroup_passes_sizes_and_desired_capacity_when_set = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "AutoScalingGroup"
        metadata.name = "web-asg"
        spec = {
            imageId = "ami-0123456789abcdef0"
            subnetIds = ["subnet-aaaa1111"]
            minSize = 2
            maxSize = 6
            desiredCapacity = 4
        }
    }
    ocds = {"launch-template" = _autoScalingGroupLaunchTemplateObserved}

    result = autoscalinggroup.composeAutoScalingGroup(oxr, ocds)

    assert result[1].spec.forProvider.minSize == 2
    assert result[1].spec.forProvider.maxSize == 6
    assert result[1].spec.forProvider.desiredCapacity == 4
}

test_autoScalingGroup_omits_desired_capacity_when_unset = lambda {
    ocds = {"launch-template" = _autoScalingGroupLaunchTemplateObserved}

    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, ocds)

    assert not result[1].spec.forProvider.desiredCapacity
}

test_autoScalingGroup_accepts_a_zero_minimum_with_zero_desired_capacity = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "AutoScalingGroup"
        metadata.name = "web-asg"
        spec = {
            imageId = "ami-0123456789abcdef0"
            subnetIds = ["subnet-aaaa1111"]
            minSize = 0
            maxSize = 2
            desiredCapacity = 0
        }
    }
    ocds = {"launch-template" = _autoScalingGroupLaunchTemplateObserved}

    result = autoscalinggroup.composeAutoScalingGroup(oxr, ocds)

    assert result[1].spec.forProvider.desiredCapacity == 0
}

# No status until the group exists.
test_autoScalingGroup_reports_no_status_before_the_group_exists = lambda {
    ocds = {"launch-template" = _autoScalingGroupLaunchTemplateObserved}

    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, ocds)

    assert "AutoScalingGroup" not in _autoScalingGroupKinds(result)
}

test_autoScalingGroup_reports_the_group_arn_once_it_exists = lambda {
    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, _autoScalingGroupFullyObserved)

    xr = result[-1]
    assert xr.kind == "AutoScalingGroup"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.metadata.name == "web-asg"
    assert xr.status.autoScalingGroupArn == "arn:aws:autoscaling:us-east-1:111111111111:autoScalingGroup:uuid:autoScalingGroupName/web-asg"
}

test_autoScalingGroup_empty_group_observation_reports_no_status = lambda {
    ocds = {
        "launch-template" = _autoScalingGroupLaunchTemplateObserved
        "auto-scaling-group" = {Resource = {status = {atProvider = {}}}}
    }

    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, ocds)

    assert "AutoScalingGroup" not in _autoScalingGroupKinds(result)
}

# The provider takes the script base64-encoded; the consumer writes it as plain text.
test_autoScalingGroup_launch_template_base64_encodes_user_data = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "AutoScalingGroup"
        metadata.name = "web-asg"
        spec = {
            imageId = "ami-0123456789abcdef0"
            subnetIds = ["subnet-aaaa1111"]
            userData = _autoScalingGroupUserData
        }
    }

    result = autoscalinggroup.composeAutoScalingGroup(oxr, {})

    assert result[0].spec.forProvider.userData == "IyEvYmluL2Jhc2gKZWNobyBoZWxsbwo="
}

test_autoScalingGroup_launch_template_omits_user_data_when_unset = lambda {
    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, {})

    assert not result[0].spec.forProvider.userData
}

# A change to the template (its user data included) rolls the group, so instances pick it up.
test_autoScalingGroup_rolls_instances_when_the_template_changes = lambda {
    ocds = {"launch-template" = _autoScalingGroupLaunchTemplateObserved}

    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, ocds)

    refresh = result[1].spec.forProvider.instanceRefresh
    assert refresh.strategy == "Rolling"
    assert refresh.triggers == ["launch_template"]
    assert refresh.preferences.minHealthyPercentage == 50
}

# The group needs the template's latest version as well as its id, or it cannot name a version.
test_autoScalingGroup_no_group_until_the_template_version_is_observed = lambda {
    ocds = {"launch-template" = {Resource = {status = {atProvider = {id = "lt-0123456789abcdef0"}}}}}

    result = autoscalinggroup.composeAutoScalingGroup(_autoScalingGroupOxr, ocds)

    assert _autoScalingGroupKinds(result) == ["LaunchTemplate"]
}
