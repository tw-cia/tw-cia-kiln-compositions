import base64
import .schemas_compositions
import .schemas_providers

autoScalingGroupLaunchTemplateName = "launch-template"
autoScalingGroupGroupName = "auto-scaling-group"

# Reads the observed launch template through its imported schema, so a misspelt field is a compile error.
autoScalingGroupLaunchTemplateObserved = lambda atProvider -> schemas_providers.Ec2AwsmUpboundIoV1beta1LaunchTemplateStatusAtProvider {
    _status: schemas_providers.Ec2AwsmUpboundIoV1beta1LaunchTemplateStatusAtProvider = atProvider
    _status
}

# Reads the observed group through its imported schema, so a misspelt field is a compile error.
autoScalingGroupGroupObserved = lambda atProvider -> schemas_providers.AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupStatusAtProvider {
    _status: schemas_providers.AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupStatusAtProvider = atProvider
    _status
}

composeAutoScalingGroup = lambda oxr, ocds -> [any] {
    spec: schemas_compositions.AutoScalingGroupSpec = oxr.spec

    # The launch template and the group both take the XR's name, so the cloud objects are easy to find.
    _name = oxr.metadata.name
    _securityGroupIds = spec.securityGroupIds or []
    _userData = spec.userData or ""

    _launchTemplate = {
        apiVersion = "ec2.aws.m.upbound.io/v1beta1"
        kind = "LaunchTemplate"
        metadata.annotations = {
            "crossplane.io/external-name" = _name
            "krm.kcl.dev/composition-resource-name" = autoScalingGroupLaunchTemplateName
        }
        spec.forProvider = schemas_providers.Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProvider {
            region = spec.region
            imageId = spec.imageId
            instanceType = spec.instanceType
            vpcSecurityGroupIds = _securityGroupIds if _securityGroupIds else Undefined
            # AWS takes the boot script base64-encoded; the consumer writes it as plain text.
            userData = base64.encode(_userData) if _userData else Undefined
        }
    }

    _observedLaunchTemplateAtProvider = ocds[autoScalingGroupLaunchTemplateName]?.Resource?.status?.atProvider
    _observedLaunchTemplate = autoScalingGroupLaunchTemplateObserved(_observedLaunchTemplateAtProvider) if _observedLaunchTemplateAtProvider else None
    _launchTemplateId = _observedLaunchTemplate?.id
    _latestVersion = _observedLaunchTemplate?.latestVersion

    # The group is requested only once the launch template has an id and a version to refer to.
    _group = {
        apiVersion = "autoscaling.aws.m.upbound.io/v1beta1"
        kind = "AutoscalingGroup"
        metadata.annotations = {
            "crossplane.io/external-name" = _name
            "krm.kcl.dev/composition-resource-name" = autoScalingGroupGroupName
        }
        spec.forProvider = schemas_providers.AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProvider {
            region = spec.region
            minSize = spec.minSize
            maxSize = spec.maxSize
            desiredCapacity = spec.desiredCapacity if spec.desiredCapacity != None else Undefined
            vpcZoneIdentifier = spec.subnetIds
            launchTemplate = schemas_providers.AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplate {
                id = _launchTemplateId
                # Pinned to the template's latest version. A changed template is a new version, which the refresh below rolls to.
                version = str(int(_latestVersion))
            }
            # Replaces the instances whenever the launch template changes, so a new boot script reaches every instance.
            instanceRefresh = schemas_providers.AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRefresh {
                strategy = "Rolling"
                triggers = ["launch_template"]
                preferences = schemas_providers.AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRefreshPreferences {
                    minHealthyPercentage = 50
                }
            }
        }
    } if _launchTemplateId and _latestVersion else None

    _observedGroupAtProvider = ocds[autoScalingGroupGroupName]?.Resource?.status?.atProvider
    _observedGroup = autoScalingGroupGroupObserved(_observedGroupAtProvider) if _observedGroupAtProvider else None
    _groupArn = _observedGroup?.arn

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.AutoScalingGroupStatus {autoScalingGroupArn = _groupArn}
    } if _groupArn else None

    [_launchTemplate] + ([_group] if _group else []) + ([_xr] if _xr else [])
}
