# Curated provider schemas. `kiln import <crd>` appends here.

schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderArnRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderArnSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderBlockDeviceMappings:
    r"""
    launch template v1beta1 at provider block device mappings

    Attributes
    ----------
    deviceName : str, default is Undefined, optional
        The name of the device to mount.
    ebs : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderBlockDeviceMappingsEbs, default is Undefined, optional
        ebs
    noDevice : str, default is Undefined, optional
        Suppresses the specified device included in the AMI's block device mapping.
    virtualName : str, default is Undefined, optional
        The Instance Store Device
        Name
        (e.g., "ephemeral0").
    """


    deviceName?: str

    ebs?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderBlockDeviceMappingsEbs

    noDevice?: str

    virtualName?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderBlockDeviceMappingsEbs:
    r"""
    Configure EBS volume properties.

    Attributes
    ----------
    deleteOnTermination : str, default is Undefined, optional
        Whether the volume should be destroyed on instance termination.
        See Preserving Amazon EBS Volumes on Instance Termination for more information.
    encrypted : str, default is Undefined, optional
        Enables EBS encryption on the volume.
        Cannot be used with snapshot_id.
    iops : float, default is Undefined, optional
        The amount of provisioned IOPS.
        This must be set with a volume_type of "io1/io2/gp3".
    kmsKeyId : str, default is Undefined, optional
        Identifier (key ID, key alias, key ARN, or alias ARN) of the customer managed KMS key to use for EBS encryption.
        encrypted must be set to true when this is set.
    snapshotId : str, default is Undefined, optional
        The Snapshot ID to mount.
    throughput : float, default is Undefined, optional
        The throughput to provision for a gp3 volume in MiB/s (specified as an integer, e.g., 500), with a maximum of 1,000 MiB/s.
    volumeInitializationRate : float, default is Undefined, optional
        The volume initialization rate in MiB/s (specified as an integer, e.g. 100), with a minimum of 100 MiB/s and maximum of 300 MiB/s.
    volumeSize : float, default is Undefined, optional
        The size of the volume in gigabytes.
    volumeType : str, default is Undefined, optional
        The volume type.
        Can be one of standard, gp2, gp3, io1, io2, sc1 or st1.
    """


    deleteOnTermination?: str

    encrypted?: str

    iops?: float

    kmsKeyId?: str

    snapshotId?: str

    throughput?: float

    volumeInitializationRate?: float

    volumeSize?: float

    volumeType?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCapacityReservationSpecification:
    r"""
    Targeting for EC2 capacity reservations. See Capacity Reservation Specification below for more details.

    Attributes
    ----------
    capacityReservationPreference : str, default is Undefined, optional
        Indicates the instance's Capacity Reservation preferences. Can be capacity-reservations-only, open or none. If capacity_reservation_id or capacity_reservation_resource_group_arn is specified in capacity_reservation_target block, either omit capacity_reservation_preference or set it to capacity-reservations-only.
    capacityReservationTarget : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCapacityReservationSpecificationCapacityReservationTarget, default is Undefined, optional
        capacity reservation target
    """


    capacityReservationPreference?: str

    capacityReservationTarget?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCapacityReservationSpecificationCapacityReservationTarget




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCapacityReservationSpecificationCapacityReservationTarget:
    r"""
    Used to target a specific Capacity Reservation:

    Attributes
    ----------
    capacityReservationId : str, default is Undefined, optional
        The ID of the Capacity Reservation in which to run the instance.
    capacityReservationResourceGroupArn : str, default is Undefined, optional
        The ARN of the Capacity Reservation resource group in which to run the instance.
    """


    capacityReservationId?: str

    capacityReservationResourceGroupArn?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCPUOptions:
    r"""
    The CPU options for the instance. See CPU Options below for more details.

    Attributes
    ----------
    amdSevSnp : str, default is Undefined, optional
        Indicates whether to enable the instance for AMD SEV-SNP. AMD SEV-SNP is supported with M6a, R6a, and C6a instance types only. Valid values are enabled and disabled.
    coreCount : float, default is Undefined, optional
        The number of CPU cores for the instance.
    nestedVirtualization : str, default is Undefined, optional
        Indicates whether to enable the instance for nested virtualization. Nested virtualization is supported on 8th generation Intel-based instance types (C8i, M8i, R8i, and their flex variants) only. When nested virtualization is enabled, Virtual Secure Mode (VSM) is automatically disabled for the instance. Valid values are enabled and disabled.
    threadsPerCore : float, default is Undefined, optional
        The number of threads per CPU core.
        To disable Intel Hyper-Threading Technology for the instance, specify a value of 1.
        Otherwise, specify the default value of 2.
    """


    amdSevSnp?: str

    coreCount?: float

    nestedVirtualization?: str

    threadsPerCore?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCreditSpecification:
    r"""
    Customize the credit specification of the instance. See Credit
    Specification below for more details.

    Attributes
    ----------
    cpuCredits : str, default is Undefined, optional
        The credit option for CPU usage.
        Can be standard or unlimited.
        T3 instances are launched as unlimited by default.
        T2 instances are launched as standard by default.
    """


    cpuCredits?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderEnclaveOptions:
    r"""
    Enable Nitro Enclaves on launched instances. See Enclave Options below for more details.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        If set to true, Nitro Enclaves will be enabled on the instance.
    """


    enabled?: bool




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderHibernationOptions:
    r"""
    The hibernation options for the instance. See Hibernation Options below for more details.

    Attributes
    ----------
    configured : bool, default is Undefined, optional
        If set to true, the launched EC2 instance will hibernation enabled.
    """


    configured?: bool




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderIamInstanceProfile:
    r"""
    The IAM Instance Profile to launch the instance with. See Instance Profile
    below for more details.

    Attributes
    ----------
    arn : str, default is Undefined, optional
        ARN of the instance profile. Conflicts with name.
    name : str, default is Undefined, optional
        The name of the instance profile.
    """


    arn?: str

    name?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceMarketOptions:
    r"""
    The market (purchasing) option for the instance. See Market Options
    below for details.

    Attributes
    ----------
    marketType : str, default is Undefined, optional
        The market type. Can be spot.
    spotOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceMarketOptionsSpotOptions, default is Undefined, optional
        spot options
    """


    marketType?: str

    spotOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceMarketOptionsSpotOptions




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceMarketOptionsSpotOptions:
    r"""
    The options for Spot Instance

    Attributes
    ----------
    blockDurationMinutes : float, default is Undefined, optional
        The required duration in minutes. This value must be a multiple of 60.
    instanceInterruptionBehavior : str, default is Undefined, optional
        The behavior when a Spot Instance is interrupted. Can be hibernate,
        stop, or terminate. (Default: terminate).
    maxPrice : str, default is Undefined, optional
        The maximum hourly price you're willing to pay for the Spot Instances.
    spotInstanceType : str, default is Undefined, optional
        The Spot Instance request type. Can be one-time, or persistent.
    validUntil : str, default is Undefined, optional
        The end date of the request.
    """


    blockDurationMinutes?: float

    instanceInterruptionBehavior?: str

    maxPrice?: str

    spotInstanceType?: str

    validUntil?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirements:
    r"""
    The attribute requirements for the type of instance. If present then instance_type cannot be present.

    Attributes
    ----------
    acceleratorCount : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsAcceleratorCount, default is Undefined, optional
        accelerator count
    acceleratorManufacturers : [str], default is Undefined, optional
        List of accelerator manufacturer names. Default is any manufacturer.
    acceleratorNames : [str], default is Undefined, optional
        List of accelerator names. Default is any acclerator.
    acceleratorTotalMemoryMib : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsAcceleratorTotalMemoryMib, default is Undefined, optional
        accelerator total memory mib
    acceleratorTypes : [str], default is Undefined, optional
        List of accelerator types. Default is any accelerator type.
    allowedInstanceTypes : [str], default is Undefined, optional
        List of instance types to apply your specified attributes against. All other instance types are ignored, even if they match your specified attributes. You can use strings with one or more wild cards, represented by an asterisk (*), to allow an instance type, size, or generation. The following are examples: m5.8xlarge, c5*.*, m5a.*, r*, *3*. For example, if you specify c5*, you are allowing the entire C5 instance family, which includes all C5a and C5n instance types. If you specify m5a.*, you are allowing all the M5a instance types, but not the M5n instance types. Maximum of 400 entries in the list; each entry is limited to 30 characters. Default is all instance types.
    bareMetal : str, default is Undefined, optional
        Indicate whether bare metal instace types should be included, excluded, or required. Default is excluded.
    baselineEbsBandwidthMbps : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsBaselineEbsBandwidthMbps, default is Undefined, optional
        baseline ebs bandwidth mbps
    burstablePerformance : str, default is Undefined, optional
        Indicate whether burstable performance instance types should be included, excluded, or required. Default is excluded.
    cpuManufacturers : [str], default is Undefined, optional
        List of CPU manufacturer names. Default is any manufacturer.
    excludedInstanceTypes : [str], default is Undefined, optional
        List of instance types to exclude. You can use strings with one or more wild cards, represented by an asterisk (*), to exclude an instance type, size, or generation. The following are examples: m5.8xlarge, c5*.*, m5a.*, r*, *3*. For example, if you specify c5*, you are excluding the entire C5 instance family, which includes all C5a and C5n instance types. If you specify m5a.*, you are excluding all the M5a instance types, but not the M5n instance types. Maximum of 400 entries in the list; each entry is limited to 30 characters. Default is no excluded instance types.
    instanceGenerations : [str], default is Undefined, optional
        List of instance generation names. Default is any generation.
    localStorage : str, default is Undefined, optional
        Indicate whether instance types with local storage volumes are included, excluded, or required. Default is included.
    localStorageTypes : [str], default is Undefined, optional
        List of local storage type names. Default any storage type.
    maxSpotPriceAsPercentageOfOptimalOnDemandPrice : float, default is Undefined, optional
        The price protection threshold for Spot Instances. This is the maximum you’ll pay for a Spot Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Conflicts with spot_max_price_percentage_over_lowest_price
    memoryGibPerVcpu : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsMemoryGibPerVcpu, default is Undefined, optional
        memory gib per vcpu
    memoryMib : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsMemoryMib, default is Undefined, optional
        memory mib
    networkBandwidthGbps : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsNetworkBandwidthGbps, default is Undefined, optional
        network bandwidth gbps
    networkInterfaceCount : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsNetworkInterfaceCount, default is Undefined, optional
        network interface count
    onDemandMaxPricePercentageOverLowestPrice : float, default is Undefined, optional
        The price protection threshold for On-Demand Instances. This is the maximum you’ll pay for an On-Demand Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Default is 20.
    requireHibernateSupport : bool, default is Undefined, optional
        Indicate whether instance types must support On-Demand Instance Hibernation, either true or false. Default is false.
    spotMaxPricePercentageOverLowestPrice : float, default is Undefined, optional
        The price protection threshold for Spot Instances. This is the maximum you’ll pay for a Spot Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Default is 100. Conflicts with max_spot_price_as_percentage_of_optimal_on_demand_price
    totalLocalStorageGb : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsTotalLocalStorageGb, default is Undefined, optional
        total local storage gb
    vcpuCount : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsVcpuCount, default is Undefined, optional
        vcpu count
    """


    acceleratorCount?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsAcceleratorCount

    acceleratorManufacturers?: [str]

    acceleratorNames?: [str]

    acceleratorTotalMemoryMib?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsAcceleratorTotalMemoryMib

    acceleratorTypes?: [str]

    allowedInstanceTypes?: [str]

    bareMetal?: str

    baselineEbsBandwidthMbps?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsBaselineEbsBandwidthMbps

    burstablePerformance?: str

    cpuManufacturers?: [str]

    excludedInstanceTypes?: [str]

    instanceGenerations?: [str]

    localStorage?: str

    localStorageTypes?: [str]

    maxSpotPriceAsPercentageOfOptimalOnDemandPrice?: float

    memoryGibPerVcpu?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsMemoryGibPerVcpu

    memoryMib?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsMemoryMib

    networkBandwidthGbps?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsNetworkBandwidthGbps

    networkInterfaceCount?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsNetworkInterfaceCount

    onDemandMaxPricePercentageOverLowestPrice?: float

    requireHibernateSupport?: bool

    spotMaxPricePercentageOverLowestPrice?: float

    totalLocalStorageGb?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsTotalLocalStorageGb

    vcpuCount?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsVcpuCount




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsAcceleratorCount:
    r"""
    Block describing the minimum and maximum number of accelerators (GPUs, FPGAs, or AWS Inferentia chips). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsAcceleratorTotalMemoryMib:
    r"""
    Block describing the minimum and maximum total memory of the accelerators. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsBaselineEbsBandwidthMbps:
    r"""
    Block describing the minimum and maximum baseline EBS bandwidth, in Mbps. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsMemoryGibPerVcpu:
    r"""
    Block describing the minimum and maximum amount of memory (GiB) per vCPU. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsMemoryMib:
    r"""
    Block describing the minimum and maximum amount of memory (MiB). Default is no maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsNetworkBandwidthGbps:
    r"""
    Block describing the minimum and maximum amount of network bandwidth, in gigabits per second (Gbps). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsNetworkInterfaceCount:
    r"""
    Block describing the minimum and maximum number of network interfaces. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsTotalLocalStorageGb:
    r"""
    Block describing the minimum and maximum total local storage (GB). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirementsVcpuCount:
    r"""
    Block describing the minimum and maximum number of vCPUs. Default is no maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderLicenseSpecification:
    r"""
    launch template v1beta1 at provider license specification

    Attributes
    ----------
    licenseConfigurationArn : str, default is Undefined, optional
        ARN of the license configuration.
    """


    licenseConfigurationArn?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderMaintenanceOptions:
    r"""
    The maintenance options for the instance. See Maintenance Options below for more details.

    Attributes
    ----------
    autoRecovery : str, default is Undefined, optional
        Disables the automatic recovery behavior of your instance or sets it to default. Can be "default" or "disabled". See Recover your instance for more details.
    """


    autoRecovery?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderMetadataOptions:
    r"""
    Customize the metadata options for the instance. See Metadata Options below for more details.

    Attributes
    ----------
    httpEndpoint : str, default is Undefined, optional
        Whether the metadata service is available. Can be "enabled" or "disabled". (Default: "enabled").
    httpProtocolIpv6 : str, default is Undefined, optional
        Enables or disables the IPv6 endpoint for the instance metadata service. Can be "enabled" or "disabled".
    httpPutResponseHopLimit : float, default is Undefined, optional
        The desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further instance metadata requests can travel. Can be an integer from 1 to 64. (Default: 1).
    httpTokens : str, default is Undefined, optional
        Whether or not the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2 (IMDSv2). Can be "optional" or "required". (Default: "optional").
    instanceMetadataTags : str, default is Undefined, optional
        Enables or disables access to instance tags from the instance metadata service. Can be "enabled" or "disabled".
    """


    httpEndpoint?: str

    httpProtocolIpv6?: str

    httpPutResponseHopLimit?: float

    httpTokens?: str

    instanceMetadataTags?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderMonitoring:
    r"""
    The monitoring option for the instance. See Monitoring below for more details.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        If true, the launched EC2 instance will have detailed monitoring enabled.
    """


    enabled?: bool




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfaces:
    r"""
    launch template v1beta1 at provider network interfaces

    Attributes
    ----------
    associateCarrierIpAddress : str, default is Undefined, optional
        Associate a Carrier IP address with eth0 for a new network interface. Use this option when you launch an instance in a Wavelength Zone and want to associate a Carrier IP address with the network interface. Boolean value, can be left unset.
    associatePublicIpAddress : str, default is Undefined, optional
        Associate a public ip address with the network interface. Boolean value, can be left unset.
    connectionTrackingSpecification : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfacesConnectionTrackingSpecification, default is Undefined, optional
        connection tracking specification
    deleteOnTermination : str, default is Undefined, optional
        Whether the network interface should be destroyed on instance termination.
    description : str, default is Undefined, optional
        Description of the network interface.
    deviceIndex : float, default is Undefined, optional
        The integer index of the network interface attachment.
    enaQueueCount : float, default is Undefined, optional
        The number of ENA queues to be created with the instance. Requires an instance type and operating system that support ENA queue configuration.
    enaSrdSpecification : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfacesEnaSrdSpecification, default is Undefined, optional
        ena srd specification
    interfaceType : str, default is Undefined, optional
        The type of network interface. To create an Elastic Fabric Adapter (EFA), specify efa.
    ipv4AddressCount : float, default is Undefined, optional
        The number of secondary private IPv4 addresses to assign to a network interface. Conflicts with ipv4_addresses
    ipv4Addresses : [str], default is Undefined, optional
        One or more private IPv4 addresses to associate. Conflicts with ipv4_address_count
    ipv4PrefixCount : float, default is Undefined, optional
        The number of IPv4 prefixes to be automatically assigned to the network interface. Conflicts with ipv4_prefixes
    ipv4Prefixes : [str], default is Undefined, optional
        One or more IPv4 prefixes to be assigned to the network interface. Conflicts with ipv4_prefix_count
    ipv6AddressCount : float, default is Undefined, optional
        The number of IPv6 addresses to assign to a network interface. Conflicts with ipv6_addresses
    ipv6Addresses : [str], default is Undefined, optional
        One or more specific IPv6 addresses from the IPv6 CIDR block range of your subnet. Conflicts with ipv6_address_count
    ipv6PrefixCount : float, default is Undefined, optional
        The number of IPv6 prefixes to be automatically assigned to the network interface. Conflicts with ipv6_prefixes
    ipv6Prefixes : [str], default is Undefined, optional
        One or more IPv6 prefixes to be assigned to the network interface. Conflicts with ipv6_prefix_count
    networkCardIndex : float, default is Undefined, optional
        The index of the network card. Some instance types support multiple network cards. The primary network interface must be assigned to network card index 0. The default is network card index 0.
    networkInterfaceId : str, default is Undefined, optional
        The ID of the network interface to attach.
    primaryIpv6 : str, default is Undefined, optional
        Whether the first IPv6 GUA will be made the primary IPv6 address.
    privateIpAddress : str, default is Undefined, optional
        The primary private IPv4 address.
    securityGroups : [str], default is Undefined, optional
        A list of security group IDs to associate.
    subnetId : str, default is Undefined, optional
        The VPC Subnet ID to associate.
    """


    associateCarrierIpAddress?: str

    associatePublicIpAddress?: str

    connectionTrackingSpecification?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfacesConnectionTrackingSpecification

    deleteOnTermination?: str

    description?: str

    deviceIndex?: float

    enaQueueCount?: float

    enaSrdSpecification?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfacesEnaSrdSpecification

    interfaceType?: str

    ipv4AddressCount?: float

    ipv4Addresses?: [str]

    ipv4PrefixCount?: float

    ipv4Prefixes?: [str]

    ipv6AddressCount?: float

    ipv6Addresses?: [str]

    ipv6PrefixCount?: float

    ipv6Prefixes?: [str]

    networkCardIndex?: float

    networkInterfaceId?: str

    primaryIpv6?: str

    privateIpAddress?: str

    securityGroups?: [str]

    subnetId?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfacesConnectionTrackingSpecification:
    r"""
    The Connection Tracking Configuration for the network interface. See Amazon EC2 security group connection tracking

    Attributes
    ----------
    tcpEstablishedTimeout : float, default is Undefined, optional
        Timeout (in seconds) for idle TCP connections in an established state. Min: 60 seconds. Max: 432000 seconds (5 days). Default: 432000 seconds. Recommended: Less than 432000 seconds.
    udpStreamTimeout : float, default is Undefined, optional
        Timeout (in seconds) for idle UDP flows classified as streams which have seen more than one request-response transaction. Min: 60 seconds. Max: 180 seconds (3 minutes). Default: 180 seconds.
    udpTimeout : float, default is Undefined, optional
        Timeout (in seconds) for idle UDP flows that have seen traffic only in a single direction or a single request-response transaction. Min: 30 seconds. Max: 60 seconds. Default: 30 seconds.
    """


    tcpEstablishedTimeout?: float

    udpStreamTimeout?: float

    udpTimeout?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfacesEnaSrdSpecification:
    r"""
    Configuration for Elastic Network Adapter (ENA) Express settings. Applies to network interfaces that use the ena Express feature. See details below.

    Attributes
    ----------
    enaSrdEnabled : bool, default is Undefined, optional
        Whether to enable ENA Express. ENA Express uses AWS Scalable Reliable Datagram (SRD) technology to improve the performance of TCP traffic.
    enaSrdUdpSpecification : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfacesEnaSrdSpecificationEnaSrdUDPSpecification, default is Undefined, optional
        ena srd Udp specification
    """


    enaSrdEnabled?: bool

    enaSrdUdpSpecification?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfacesEnaSrdSpecificationEnaSrdUDPSpecification




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfacesEnaSrdSpecificationEnaSrdUDPSpecification:
    r"""
    Configuration for ENA Express UDP optimization. See details below.

    Attributes
    ----------
    enaSrdUdpEnabled : bool, default is Undefined, optional
        Whether to enable UDP traffic optimization through ENA Express. Requires ena_srd_enabled to be true.
    """


    enaSrdUdpEnabled?: bool




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkPerformanceOptions:
    r"""
    launch template v1beta1 at provider network performance options

    Attributes
    ----------
    bandwidthWeighting : str, default is Undefined, optional
        Specify the bandwidth weighting option to boost the associated type of baseline bandwidth. Valid values: default, vpc-1, ebs-1. Default value is default. Setting vpc-1 boosts networking baseline bandwidth and reduces EBS baseline bandwidth. Setting ebs-1 boosts EBS baseline bandwidth and reduces networking baseline bandwidth. Only supported on select instance types. See AWS Documentation for more information.
    """


    bandwidthWeighting?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderPlacement:
    r"""
    The placement of the instance. See Placement below for more details.

    Attributes
    ----------
    affinity : str, default is Undefined, optional
        The affinity setting for an instance on a Dedicated Host.
    availabilityZone : str, default is Undefined, optional
        The Availability Zone for the instance.
    groupId : str, default is Undefined, optional
        The ID of the placement group for the instance. Conflicts with group_name.
    groupName : str, default is Undefined, optional
        The name of the placement group for the instance. Conflicts with group_id.
    hostId : str, default is Undefined, optional
        The ID of the Dedicated Host for the instance.
    hostResourceGroupArn : str, default is Undefined, optional
        The ARN of the Host Resource Group in which to launch instances.
    partitionNumber : float, default is Undefined, optional
        The number of the partition the instance should launch in. Valid only if the placement group strategy is set to partition.
    spreadDomain : str, default is Undefined, optional
        Reserved for future use.
    tenancy : str, default is Undefined, optional
        The tenancy of the instance (if the instance is running in a VPC). Can be default, dedicated, or host.
    """


    affinity?: str

    availabilityZone?: str

    groupId?: str

    groupName?: str

    hostId?: str

    hostResourceGroupArn?: str

    partitionNumber?: float

    spreadDomain?: str

    tenancy?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderPrivateDNSNameOptions:
    r"""
    The options for the instance hostname. The default values are inherited from the subnet. See Private DNS Name Options below for more details.

    Attributes
    ----------
    enableResourceNameDnsARecord : bool, default is Undefined, optional
        Indicates whether to respond to DNS queries for instance hostnames with DNS A records.
    enableResourceNameDnsAaaaRecord : bool, default is Undefined, optional
        Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records.
    hostnameType : str, default is Undefined, optional
        The type of hostname for Amazon EC2 instances. For IPv4 only subnets, an instance DNS name must be based on the instance IPv4 address. For IPv6 native subnets, an instance DNS name must be based on the instance ID. For dual-stack subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID. Valid values: ip-name and resource-name.
    """


    enableResourceNameDnsARecord?: bool

    enableResourceNameDnsAaaaRecord?: bool

    hostnameType?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderSecondaryInterfaces:
    r"""
    launch template v1beta1 at provider secondary interfaces

    Attributes
    ----------
    deleteOnTermination : bool, default is Undefined, optional
        Whether the secondary interface is deleted when the instance is terminated. The only supported value is true.
    deviceIndex : float, default is Undefined, optional
        Device index for the secondary interface attachment.
    interfaceType : str, default is Undefined, optional
        Type of secondary interface. The only supported value is: secondary.
    networkCardIndex : float, default is Undefined, optional
        Index of the network card.
    privateIpAddressCount : float, default is Undefined, optional
        Number of private IPv4 addresses to assign to the secondary interface.
    privateIpAddresses : [str], default is Undefined, optional
        Private IPv4 addresses to assign to the secondary interface.
    secondarySubnetId : str, default is Undefined, optional
        ID of the secondary subnet.
    """


    deleteOnTermination?: bool

    deviceIndex?: float

    interfaceType?: str

    networkCardIndex?: float

    privateIpAddressCount?: float

    privateIpAddresses?: [str]

    secondarySubnetId?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderTagSpecifications:
    r"""
    launch template v1beta1 at provider tag specifications

    Attributes
    ----------
    resourceType : str, default is Undefined, optional
        The type of resource to tag.
    tags : {str:str}, default is Undefined, optional
        A map of tags to assign to the resource.
    """


    resourceType?: str

    tags?: {str:str}




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderBlockDeviceMappingsEbs:
    r"""
    Configure EBS volume properties.

    Attributes
    ----------
    deleteOnTermination : str, default is Undefined, optional
        Whether the volume should be destroyed on instance termination.
        See Preserving Amazon EBS Volumes on Instance Termination for more information.
    encrypted : str, default is Undefined, optional
        Enables EBS encryption on the volume.
        Cannot be used with snapshot_id.
    iops : float, default is Undefined, optional
        The amount of provisioned IOPS.
        This must be set with a volume_type of "io1/io2/gp3".
    kmsKeyId : str, default is Undefined, optional
        Identifier (key ID, key alias, key ARN, or alias ARN) of the customer managed KMS key to use for EBS encryption.
        encrypted must be set to true when this is set.
    kmsKeyIdRef : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEbsKmsKeyIDRef, default is Undefined, optional
        kms key Id ref
    kmsKeyIdSelector : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEbsKmsKeyIDSelector, default is Undefined, optional
        kms key Id selector
    snapshotId : str, default is Undefined, optional
        The Snapshot ID to mount.
    throughput : float, default is Undefined, optional
        The throughput to provision for a gp3 volume in MiB/s (specified as an integer, e.g., 500), with a maximum of 1,000 MiB/s.
    volumeInitializationRate : float, default is Undefined, optional
        The volume initialization rate in MiB/s (specified as an integer, e.g. 100), with a minimum of 100 MiB/s and maximum of 300 MiB/s.
    volumeSize : float, default is Undefined, optional
        The size of the volume in gigabytes.
    volumeType : str, default is Undefined, optional
        The volume type.
        Can be one of standard, gp2, gp3, io1, io2, sc1 or st1.
    """


    deleteOnTermination?: str

    encrypted?: str

    iops?: float

    kmsKeyId?: str

    kmsKeyIdRef?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEbsKmsKeyIDRef

    kmsKeyIdSelector?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEbsKmsKeyIDSelector

    snapshotId?: str

    throughput?: float

    volumeInitializationRate?: float

    volumeSize?: float

    volumeType?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCapacityReservationSpecificationCapacityReservationTarget:
    r"""
    Used to target a specific Capacity Reservation:

    Attributes
    ----------
    capacityReservationId : str, default is Undefined, optional
        The ID of the Capacity Reservation in which to run the instance.
    capacityReservationResourceGroupArn : str, default is Undefined, optional
        The ARN of the Capacity Reservation resource group in which to run the instance.
    """


    capacityReservationId?: str

    capacityReservationResourceGroupArn?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEbsKmsKeyIDRef:
    r"""
    Reference to a Key in kms to populate kmsKeyId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderKmsKeyIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderKmsKeyIDRefPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEbsKmsKeyIDSelector:
    r"""
    Selector for a Key in kms to populate kmsKeyId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderKmsKeyIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderKmsKeyIDSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEnaSrdSpecificationEnaSrdUDPSpecification:
    r"""
    Configuration for ENA Express UDP optimization. See details below.

    Attributes
    ----------
    enaSrdUdpEnabled : bool, default is Undefined, optional
        Whether to enable UDP traffic optimization through ENA Express. Requires ena_srd_enabled to be true.
    """


    enaSrdUdpEnabled?: bool




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderBlockDeviceMappings:
    r"""
    launch template v1beta1 for provider block device mappings

    Attributes
    ----------
    deviceName : str, default is Undefined, optional
        The name of the device to mount.
    ebs : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderBlockDeviceMappingsEbs, default is Undefined, optional
        ebs
    noDevice : str, default is Undefined, optional
        Suppresses the specified device included in the AMI's block device mapping.
    virtualName : str, default is Undefined, optional
        The Instance Store Device
        Name
        (e.g., "ephemeral0").
    """


    deviceName?: str

    ebs?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderBlockDeviceMappingsEbs

    noDevice?: str

    virtualName?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCapacityReservationSpecification:
    r"""
    Targeting for EC2 capacity reservations. See Capacity Reservation Specification below for more details.

    Attributes
    ----------
    capacityReservationPreference : str, default is Undefined, optional
        Indicates the instance's Capacity Reservation preferences. Can be capacity-reservations-only, open or none. If capacity_reservation_id or capacity_reservation_resource_group_arn is specified in capacity_reservation_target block, either omit capacity_reservation_preference or set it to capacity-reservations-only.
    capacityReservationTarget : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCapacityReservationSpecificationCapacityReservationTarget, default is Undefined, optional
        capacity reservation target
    """


    capacityReservationPreference?: str

    capacityReservationTarget?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCapacityReservationSpecificationCapacityReservationTarget




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCPUOptions:
    r"""
    The CPU options for the instance. See CPU Options below for more details.

    Attributes
    ----------
    amdSevSnp : str, default is Undefined, optional
        Indicates whether to enable the instance for AMD SEV-SNP. AMD SEV-SNP is supported with M6a, R6a, and C6a instance types only. Valid values are enabled and disabled.
    coreCount : float, default is Undefined, optional
        The number of CPU cores for the instance.
    nestedVirtualization : str, default is Undefined, optional
        Indicates whether to enable the instance for nested virtualization. Nested virtualization is supported on 8th generation Intel-based instance types (C8i, M8i, R8i, and their flex variants) only. When nested virtualization is enabled, Virtual Secure Mode (VSM) is automatically disabled for the instance. Valid values are enabled and disabled.
    threadsPerCore : float, default is Undefined, optional
        The number of threads per CPU core.
        To disable Intel Hyper-Threading Technology for the instance, specify a value of 1.
        Otherwise, specify the default value of 2.
    """


    amdSevSnp?: str

    coreCount?: float

    nestedVirtualization?: str

    threadsPerCore?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCreditSpecification:
    r"""
    Customize the credit specification of the instance. See Credit
    Specification below for more details.

    Attributes
    ----------
    cpuCredits : str, default is Undefined, optional
        The credit option for CPU usage.
        Can be standard or unlimited.
        T3 instances are launched as unlimited by default.
        T2 instances are launched as standard by default.
    """


    cpuCredits?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEnclaveOptions:
    r"""
    Enable Nitro Enclaves on launched instances. See Enclave Options below for more details.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        If set to true, Nitro Enclaves will be enabled on the instance.
    """


    enabled?: bool




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderHibernationOptions:
    r"""
    The hibernation options for the instance. See Hibernation Options below for more details.

    Attributes
    ----------
    configured : bool, default is Undefined, optional
        If set to true, the launched EC2 instance will hibernation enabled.
    """


    configured?: bool




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfile:
    r"""
    The IAM Instance Profile to launch the instance with. See Instance Profile
    below for more details.

    Attributes
    ----------
    arn : str, default is Undefined, optional
        ARN of the instance profile. Conflicts with name.
    arnRef : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileArnRef, default is Undefined, optional
        arn ref
    arnSelector : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileArnSelector, default is Undefined, optional
        arn selector
    name : str, default is Undefined, optional
        The name of the instance profile.
    nameRef : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileNameRef, default is Undefined, optional
        name ref
    nameSelector : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileNameSelector, default is Undefined, optional
        name selector
    """


    arn?: str

    arnRef?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileArnRef

    arnSelector?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileArnSelector

    name?: str

    nameRef?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileNameRef

    nameSelector?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileNameSelector




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceMarketOptions:
    r"""
    The market (purchasing) option for the instance. See Market Options
    below for details.

    Attributes
    ----------
    marketType : str, default is Undefined, optional
        The market type. Can be spot.
    spotOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceMarketOptionsSpotOptions, default is Undefined, optional
        spot options
    """


    marketType?: str

    spotOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceMarketOptionsSpotOptions




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirements:
    r"""
    The attribute requirements for the type of instance. If present then instance_type cannot be present.

    Attributes
    ----------
    acceleratorCount : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsAcceleratorCount, default is Undefined, optional
        accelerator count
    acceleratorManufacturers : [str], default is Undefined, optional
        List of accelerator manufacturer names. Default is any manufacturer.
    acceleratorNames : [str], default is Undefined, optional
        List of accelerator names. Default is any acclerator.
    acceleratorTotalMemoryMib : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsAcceleratorTotalMemoryMib, default is Undefined, optional
        accelerator total memory mib
    acceleratorTypes : [str], default is Undefined, optional
        List of accelerator types. Default is any accelerator type.
    allowedInstanceTypes : [str], default is Undefined, optional
        List of instance types to apply your specified attributes against. All other instance types are ignored, even if they match your specified attributes. You can use strings with one or more wild cards, represented by an asterisk (*), to allow an instance type, size, or generation. The following are examples: m5.8xlarge, c5*.*, m5a.*, r*, *3*. For example, if you specify c5*, you are allowing the entire C5 instance family, which includes all C5a and C5n instance types. If you specify m5a.*, you are allowing all the M5a instance types, but not the M5n instance types. Maximum of 400 entries in the list; each entry is limited to 30 characters. Default is all instance types.
    bareMetal : str, default is Undefined, optional
        Indicate whether bare metal instace types should be included, excluded, or required. Default is excluded.
    baselineEbsBandwidthMbps : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsBaselineEbsBandwidthMbps, default is Undefined, optional
        baseline ebs bandwidth mbps
    burstablePerformance : str, default is Undefined, optional
        Indicate whether burstable performance instance types should be included, excluded, or required. Default is excluded.
    cpuManufacturers : [str], default is Undefined, optional
        List of CPU manufacturer names. Default is any manufacturer.
    excludedInstanceTypes : [str], default is Undefined, optional
        List of instance types to exclude. You can use strings with one or more wild cards, represented by an asterisk (*), to exclude an instance type, size, or generation. The following are examples: m5.8xlarge, c5*.*, m5a.*, r*, *3*. For example, if you specify c5*, you are excluding the entire C5 instance family, which includes all C5a and C5n instance types. If you specify m5a.*, you are excluding all the M5a instance types, but not the M5n instance types. Maximum of 400 entries in the list; each entry is limited to 30 characters. Default is no excluded instance types.
    instanceGenerations : [str], default is Undefined, optional
        List of instance generation names. Default is any generation.
    localStorage : str, default is Undefined, optional
        Indicate whether instance types with local storage volumes are included, excluded, or required. Default is included.
    localStorageTypes : [str], default is Undefined, optional
        List of local storage type names. Default any storage type.
    maxSpotPriceAsPercentageOfOptimalOnDemandPrice : float, default is Undefined, optional
        The price protection threshold for Spot Instances. This is the maximum you’ll pay for a Spot Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Conflicts with spot_max_price_percentage_over_lowest_price
    memoryGibPerVcpu : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsMemoryGibPerVcpu, default is Undefined, optional
        memory gib per vcpu
    memoryMib : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsMemoryMib, default is Undefined, optional
        memory mib
    networkBandwidthGbps : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsNetworkBandwidthGbps, default is Undefined, optional
        network bandwidth gbps
    networkInterfaceCount : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsNetworkInterfaceCount, default is Undefined, optional
        network interface count
    onDemandMaxPricePercentageOverLowestPrice : float, default is Undefined, optional
        The price protection threshold for On-Demand Instances. This is the maximum you’ll pay for an On-Demand Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Default is 20.
    requireHibernateSupport : bool, default is Undefined, optional
        Indicate whether instance types must support On-Demand Instance Hibernation, either true or false. Default is false.
    spotMaxPricePercentageOverLowestPrice : float, default is Undefined, optional
        The price protection threshold for Spot Instances. This is the maximum you’ll pay for a Spot Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Default is 100. Conflicts with max_spot_price_as_percentage_of_optimal_on_demand_price
    totalLocalStorageGb : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsTotalLocalStorageGb, default is Undefined, optional
        total local storage gb
    vcpuCount : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsVcpuCount, default is Undefined, optional
        vcpu count
    """


    acceleratorCount?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsAcceleratorCount

    acceleratorManufacturers?: [str]

    acceleratorNames?: [str]

    acceleratorTotalMemoryMib?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsAcceleratorTotalMemoryMib

    acceleratorTypes?: [str]

    allowedInstanceTypes?: [str]

    bareMetal?: str

    baselineEbsBandwidthMbps?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsBaselineEbsBandwidthMbps

    burstablePerformance?: str

    cpuManufacturers?: [str]

    excludedInstanceTypes?: [str]

    instanceGenerations?: [str]

    localStorage?: str

    localStorageTypes?: [str]

    maxSpotPriceAsPercentageOfOptimalOnDemandPrice?: float

    memoryGibPerVcpu?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsMemoryGibPerVcpu

    memoryMib?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsMemoryMib

    networkBandwidthGbps?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsNetworkBandwidthGbps

    networkInterfaceCount?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsNetworkInterfaceCount

    onDemandMaxPricePercentageOverLowestPrice?: float

    requireHibernateSupport?: bool

    spotMaxPricePercentageOverLowestPrice?: float

    totalLocalStorageGb?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsTotalLocalStorageGb

    vcpuCount?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsVcpuCount




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderLicenseSpecification:
    r"""
    launch template v1beta1 for provider license specification

    Attributes
    ----------
    licenseConfigurationArn : str, default is Undefined, optional
        ARN of the license configuration.
    """


    licenseConfigurationArn?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderMaintenanceOptions:
    r"""
    The maintenance options for the instance. See Maintenance Options below for more details.

    Attributes
    ----------
    autoRecovery : str, default is Undefined, optional
        Disables the automatic recovery behavior of your instance or sets it to default. Can be "default" or "disabled". See Recover your instance for more details.
    """


    autoRecovery?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderMetadataOptions:
    r"""
    Customize the metadata options for the instance. See Metadata Options below for more details.

    Attributes
    ----------
    httpEndpoint : str, default is Undefined, optional
        Whether the metadata service is available. Can be "enabled" or "disabled". (Default: "enabled").
    httpProtocolIpv6 : str, default is Undefined, optional
        Enables or disables the IPv6 endpoint for the instance metadata service. Can be "enabled" or "disabled".
    httpPutResponseHopLimit : float, default is Undefined, optional
        The desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further instance metadata requests can travel. Can be an integer from 1 to 64. (Default: 1).
    httpTokens : str, default is Undefined, optional
        Whether or not the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2 (IMDSv2). Can be "optional" or "required". (Default: "optional").
    instanceMetadataTags : str, default is Undefined, optional
        Enables or disables access to instance tags from the instance metadata service. Can be "enabled" or "disabled".
    """


    httpEndpoint?: str

    httpProtocolIpv6?: str

    httpPutResponseHopLimit?: float

    httpTokens?: str

    instanceMetadataTags?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderMonitoring:
    r"""
    The monitoring option for the instance. See Monitoring below for more details.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        If true, the launched EC2 instance will have detailed monitoring enabled.
    """


    enabled?: bool




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfaces:
    r"""
    launch template v1beta1 for provider network interfaces

    Attributes
    ----------
    associateCarrierIpAddress : str, default is Undefined, optional
        Associate a Carrier IP address with eth0 for a new network interface. Use this option when you launch an instance in a Wavelength Zone and want to associate a Carrier IP address with the network interface. Boolean value, can be left unset.
    associatePublicIpAddress : str, default is Undefined, optional
        Associate a public ip address with the network interface. Boolean value, can be left unset.
    connectionTrackingSpecification : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesConnectionTrackingSpecification, default is Undefined, optional
        connection tracking specification
    deleteOnTermination : str, default is Undefined, optional
        Whether the network interface should be destroyed on instance termination.
    description : str, default is Undefined, optional
        Description of the network interface.
    deviceIndex : float, default is Undefined, optional
        The integer index of the network interface attachment.
    enaQueueCount : float, default is Undefined, optional
        The number of ENA queues to be created with the instance. Requires an instance type and operating system that support ENA queue configuration.
    enaSrdSpecification : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesEnaSrdSpecification, default is Undefined, optional
        ena srd specification
    interfaceType : str, default is Undefined, optional
        The type of network interface. To create an Elastic Fabric Adapter (EFA), specify efa.
    ipv4AddressCount : float, default is Undefined, optional
        The number of secondary private IPv4 addresses to assign to a network interface. Conflicts with ipv4_addresses
    ipv4Addresses : [str], default is Undefined, optional
        One or more private IPv4 addresses to associate. Conflicts with ipv4_address_count
    ipv4PrefixCount : float, default is Undefined, optional
        The number of IPv4 prefixes to be automatically assigned to the network interface. Conflicts with ipv4_prefixes
    ipv4Prefixes : [str], default is Undefined, optional
        One or more IPv4 prefixes to be assigned to the network interface. Conflicts with ipv4_prefix_count
    ipv6AddressCount : float, default is Undefined, optional
        The number of IPv6 addresses to assign to a network interface. Conflicts with ipv6_addresses
    ipv6Addresses : [str], default is Undefined, optional
        One or more specific IPv6 addresses from the IPv6 CIDR block range of your subnet. Conflicts with ipv6_address_count
    ipv6PrefixCount : float, default is Undefined, optional
        The number of IPv6 prefixes to be automatically assigned to the network interface. Conflicts with ipv6_prefixes
    ipv6Prefixes : [str], default is Undefined, optional
        One or more IPv6 prefixes to be assigned to the network interface. Conflicts with ipv6_prefix_count
    networkCardIndex : float, default is Undefined, optional
        The index of the network card. Some instance types support multiple network cards. The primary network interface must be assigned to network card index 0. The default is network card index 0.
    networkInterfaceId : str, default is Undefined, optional
        The ID of the network interface to attach.
    networkInterfaceIdRef : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesNetworkInterfaceIDRef, default is Undefined, optional
        network interface Id ref
    networkInterfaceIdSelector : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesNetworkInterfaceIDSelector, default is Undefined, optional
        network interface Id selector
    primaryIpv6 : str, default is Undefined, optional
        Whether the first IPv6 GUA will be made the primary IPv6 address.
    privateIpAddress : str, default is Undefined, optional
        The primary private IPv4 address.
    securityGroupRefs : [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSecurityGroupRefs], default is Undefined, optional
        References to SecurityGroup in ec2 to populate securityGroups.
    securityGroupSelector : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSecurityGroupSelector, default is Undefined, optional
        security group selector
    securityGroups : [str], default is Undefined, optional
        A list of security group IDs to associate.
    subnetId : str, default is Undefined, optional
        The VPC Subnet ID to associate.
    subnetIdRef : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSubnetIDRef, default is Undefined, optional
        subnet Id ref
    subnetIdSelector : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSubnetIDSelector, default is Undefined, optional
        subnet Id selector
    """


    associateCarrierIpAddress?: str

    associatePublicIpAddress?: str

    connectionTrackingSpecification?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesConnectionTrackingSpecification

    deleteOnTermination?: str

    description?: str

    deviceIndex?: float

    enaQueueCount?: float

    enaSrdSpecification?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesEnaSrdSpecification

    interfaceType?: str

    ipv4AddressCount?: float

    ipv4Addresses?: [str]

    ipv4PrefixCount?: float

    ipv4Prefixes?: [str]

    ipv6AddressCount?: float

    ipv6Addresses?: [str]

    ipv6PrefixCount?: float

    ipv6Prefixes?: [str]

    networkCardIndex?: float

    networkInterfaceId?: str

    networkInterfaceIdRef?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesNetworkInterfaceIDRef

    networkInterfaceIdSelector?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesNetworkInterfaceIDSelector

    primaryIpv6?: str

    privateIpAddress?: str

    securityGroupRefs?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSecurityGroupRefs]

    securityGroupSelector?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSecurityGroupSelector

    securityGroups?: [str]

    subnetId?: str

    subnetIdRef?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSubnetIDRef

    subnetIdSelector?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSubnetIDSelector




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkPerformanceOptions:
    r"""
    launch template v1beta1 for provider network performance options

    Attributes
    ----------
    bandwidthWeighting : str, default is Undefined, optional
        Specify the bandwidth weighting option to boost the associated type of baseline bandwidth. Valid values: default, vpc-1, ebs-1. Default value is default. Setting vpc-1 boosts networking baseline bandwidth and reduces EBS baseline bandwidth. Setting ebs-1 boosts EBS baseline bandwidth and reduces networking baseline bandwidth. Only supported on select instance types. See AWS Documentation for more information.
    """


    bandwidthWeighting?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderPlacement:
    r"""
    The placement of the instance. See Placement below for more details.

    Attributes
    ----------
    affinity : str, default is Undefined, optional
        The affinity setting for an instance on a Dedicated Host.
    availabilityZone : str, default is Undefined, optional
        The Availability Zone for the instance.
    groupId : str, default is Undefined, optional
        The ID of the placement group for the instance. Conflicts with group_name.
    groupName : str, default is Undefined, optional
        The name of the placement group for the instance. Conflicts with group_id.
    hostId : str, default is Undefined, optional
        The ID of the Dedicated Host for the instance.
    hostResourceGroupArn : str, default is Undefined, optional
        The ARN of the Host Resource Group in which to launch instances.
    partitionNumber : float, default is Undefined, optional
        The number of the partition the instance should launch in. Valid only if the placement group strategy is set to partition.
    spreadDomain : str, default is Undefined, optional
        Reserved for future use.
    tenancy : str, default is Undefined, optional
        The tenancy of the instance (if the instance is running in a VPC). Can be default, dedicated, or host.
    """


    affinity?: str

    availabilityZone?: str

    groupId?: str

    groupName?: str

    hostId?: str

    hostResourceGroupArn?: str

    partitionNumber?: float

    spreadDomain?: str

    tenancy?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderPrivateDNSNameOptions:
    r"""
    The options for the instance hostname. The default values are inherited from the subnet. See Private DNS Name Options below for more details.

    Attributes
    ----------
    enableResourceNameDnsARecord : bool, default is Undefined, optional
        Indicates whether to respond to DNS queries for instance hostnames with DNS A records.
    enableResourceNameDnsAaaaRecord : bool, default is Undefined, optional
        Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records.
    hostnameType : str, default is Undefined, optional
        The type of hostname for Amazon EC2 instances. For IPv4 only subnets, an instance DNS name must be based on the instance IPv4 address. For IPv6 native subnets, an instance DNS name must be based on the instance ID. For dual-stack subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID. Valid values: ip-name and resource-name.
    """


    enableResourceNameDnsARecord?: bool

    enableResourceNameDnsAaaaRecord?: bool

    hostnameType?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecondaryInterfaces:
    r"""
    launch template v1beta1 for provider secondary interfaces

    Attributes
    ----------
    deleteOnTermination : bool, default is Undefined, optional
        Whether the secondary interface is deleted when the instance is terminated. The only supported value is true.
    deviceIndex : float, default is Undefined, optional
        Device index for the secondary interface attachment.
    interfaceType : str, default is Undefined, optional
        Type of secondary interface. The only supported value is: secondary.
    networkCardIndex : float, default is Undefined, optional
        Index of the network card.
    privateIpAddressCount : float, default is Undefined, optional
        Number of private IPv4 addresses to assign to the secondary interface.
    privateIpAddresses : [str], default is Undefined, optional
        Private IPv4 addresses to assign to the secondary interface.
    secondarySubnetId : str, default is Undefined, optional
        ID of the secondary subnet.
    """


    deleteOnTermination?: bool

    deviceIndex?: float

    interfaceType?: str

    networkCardIndex?: float

    privateIpAddressCount?: float

    privateIpAddresses?: [str]

    secondarySubnetId?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameRefs:
    r"""
    A NamespacedReference to a named object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameRefsPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameRefsPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameSelector:
    r"""
    Selector for a list of SecurityGroup in ec2 to populate securityGroupNames.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderTagSpecifications:
    r"""
    launch template v1beta1 for provider tag specifications

    Attributes
    ----------
    resourceType : str, default is Undefined, optional
        The type of resource to tag.
    tags : {str:str}, default is Undefined, optional
        A map of tags to assign to the resource.
    """


    resourceType?: str

    tags?: {str:str}




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDRefs:
    r"""
    A NamespacedReference to a named object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDRefsPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDRefsPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDSelector:
    r"""
    Selector for a list of SecurityGroup in ec2 to populate vpcSecurityGroupIds.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileArnRef:
    r"""
    Reference to a InstanceProfile in iam to populate arn.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderArnRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderArnRefPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileArnSelector:
    r"""
    Selector for a InstanceProfile in iam to populate arn.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderArnSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderArnSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileNameRef:
    r"""
    Reference to a InstanceProfile in iam to populate name.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNameRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNameRefPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfileNameSelector:
    r"""
    Selector for a InstanceProfile in iam to populate name.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNameSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNameSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceMarketOptionsSpotOptions:
    r"""
    The options for Spot Instance

    Attributes
    ----------
    blockDurationMinutes : float, default is Undefined, optional
        The required duration in minutes. This value must be a multiple of 60.
    instanceInterruptionBehavior : str, default is Undefined, optional
        The behavior when a Spot Instance is interrupted. Can be hibernate,
        stop, or terminate. (Default: terminate).
    maxPrice : str, default is Undefined, optional
        The maximum hourly price you're willing to pay for the Spot Instances.
    spotInstanceType : str, default is Undefined, optional
        The Spot Instance request type. Can be one-time, or persistent.
    validUntil : str, default is Undefined, optional
        The end date of the request.
    """


    blockDurationMinutes?: float

    instanceInterruptionBehavior?: str

    maxPrice?: str

    spotInstanceType?: str

    validUntil?: str




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsAcceleratorCount:
    r"""
    Block describing the minimum and maximum number of accelerators (GPUs, FPGAs, or AWS Inferentia chips). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsAcceleratorTotalMemoryMib:
    r"""
    Block describing the minimum and maximum total memory of the accelerators. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsBaselineEbsBandwidthMbps:
    r"""
    Block describing the minimum and maximum baseline EBS bandwidth, in Mbps. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsMemoryGibPerVcpu:
    r"""
    Block describing the minimum and maximum amount of memory (GiB) per vCPU. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsMemoryMib:
    r"""
    Block describing the minimum and maximum amount of memory (MiB). Default is no maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsNetworkBandwidthGbps:
    r"""
    Block describing the minimum and maximum amount of network bandwidth, in gigabits per second (Gbps). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsNetworkInterfaceCount:
    r"""
    Block describing the minimum and maximum number of network interfaces. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsTotalLocalStorageGb:
    r"""
    Block describing the minimum and maximum total local storage (GB). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirementsVcpuCount:
    r"""
    Block describing the minimum and maximum number of vCPUs. Default is no maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderKmsKeyIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderKmsKeyIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNameRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNameSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfaceIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfaceIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesConnectionTrackingSpecification:
    r"""
    The Connection Tracking Configuration for the network interface. See Amazon EC2 security group connection tracking

    Attributes
    ----------
    tcpEstablishedTimeout : float, default is Undefined, optional
        Timeout (in seconds) for idle TCP connections in an established state. Min: 60 seconds. Max: 432000 seconds (5 days). Default: 432000 seconds. Recommended: Less than 432000 seconds.
    udpStreamTimeout : float, default is Undefined, optional
        Timeout (in seconds) for idle UDP flows classified as streams which have seen more than one request-response transaction. Min: 60 seconds. Max: 180 seconds (3 minutes). Default: 180 seconds.
    udpTimeout : float, default is Undefined, optional
        Timeout (in seconds) for idle UDP flows that have seen traffic only in a single direction or a single request-response transaction. Min: 30 seconds. Max: 60 seconds. Default: 30 seconds.
    """


    tcpEstablishedTimeout?: float

    udpStreamTimeout?: float

    udpTimeout?: float




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesEnaSrdSpecification:
    r"""
    Configuration for Elastic Network Adapter (ENA) Express settings. Applies to network interfaces that use the ena Express feature. See details below.

    Attributes
    ----------
    enaSrdEnabled : bool, default is Undefined, optional
        Whether to enable ENA Express. ENA Express uses AWS Scalable Reliable Datagram (SRD) technology to improve the performance of TCP traffic.
    enaSrdUdpSpecification : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEnaSrdSpecificationEnaSrdUDPSpecification, default is Undefined, optional
        ena srd Udp specification
    """


    enaSrdEnabled?: bool

    enaSrdUdpSpecification?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEnaSrdSpecificationEnaSrdUDPSpecification




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesNetworkInterfaceIDRef:
    r"""
    Reference to a NetworkInterface in ec2 to populate networkInterfaceId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfaceIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfaceIDRefPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesNetworkInterfaceIDSelector:
    r"""
    Selector for a NetworkInterface in ec2 to populate networkInterfaceId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfaceIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfaceIDSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSecurityGroupRefs:
    r"""
    A NamespacedReference to a named object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupRefsPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupRefsPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSecurityGroupSelector:
    r"""
    Selector for a list of SecurityGroup in ec2 to populate securityGroups.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSubnetIDRef:
    r"""
    Reference to a Subnet in ec2 to populate subnetId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSubnetIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSubnetIDRefPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfacesSubnetIDSelector:
    r"""
    Selector for a Subnet in ec2 to populate subnetId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSubnetIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSubnetIDSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameRefsPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupRefsPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProvider:
    r"""
    launch template v1beta1 spec for provider

    Attributes
    ----------
    blockDeviceMappings : [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderBlockDeviceMappings], default is Undefined, optional
        Specify volumes to attach to the instance besides the volumes specified by the AMI.
        See Block Devices below for details.
    capacityReservationSpecification : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCapacityReservationSpecification, default is Undefined, optional
        capacity reservation specification
    cpuOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCPUOptions, default is Undefined, optional
        cpu options
    creditSpecification : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCreditSpecification, default is Undefined, optional
        credit specification
    defaultVersion : float, default is Undefined, optional
        Default Version of the launch template.
    description : str, default is Undefined, optional
        Description of the launch template version (VersionDescription in the EC2 API). Launch templates in AWS do not have a template-level description; whenever a change to this resource creates a new version, the new version is created with this description. To give each version a distinct description, update this argument in the same apply as the other changes.
    disableApiStop : bool, default is Undefined, optional
        If true, enables EC2 Instance Stop Protection.
    disableApiTermination : bool, default is Undefined, optional
        If true, enables EC2 Instance
        Termination Protection
    ebsOptimized : str, default is Undefined, optional
        If true, the launched EC2 instance will be EBS-optimized.
    enclaveOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEnclaveOptions, default is Undefined, optional
        enclave options
    hibernationOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderHibernationOptions, default is Undefined, optional
        hibernation options
    iamInstanceProfile : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfile, default is Undefined, optional
        iam instance profile
    imageId : str, default is Undefined, optional
        The AMI from which to launch the instance or use a Systems Manager parameter convention e.g. resolve:ssm:parameter-name. See docs for more details.
    instanceInitiatedShutdownBehavior : str, default is Undefined, optional
        Shutdown behavior for the instance. Can be stop or terminate.
        (Default: stop).
    instanceMarketOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceMarketOptions, default is Undefined, optional
        instance market options
    instanceRequirements : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirements, default is Undefined, optional
        instance requirements
    instanceType : str, default is Undefined, optional
        The type of the instance. If present then instance_requirements cannot be present.
    kernelId : str, default is Undefined, optional
        The kernel ID.
    keyName : str, default is Undefined, optional
        The key name to use for the instance.
    licenseSpecification : [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderLicenseSpecification], default is Undefined, optional
        A list of license specifications to associate with. See License Specification below for more details.
    maintenanceOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderMaintenanceOptions, default is Undefined, optional
        maintenance options
    metadataOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderMetadataOptions, default is Undefined, optional
        metadata options
    monitoring : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderMonitoring, default is Undefined, optional
        monitoring
    name : str, default is Undefined, optional
        The name of the launch template.
    networkInterfaces : [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfaces], default is Undefined, optional
        Customize network interfaces to be attached at instance boot time. See Network
        Interfaces below for more details.
    networkPerformanceOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkPerformanceOptions, default is Undefined, optional
        network performance options
    placement : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderPlacement, default is Undefined, optional
        placement
    privateDnsNameOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderPrivateDNSNameOptions, default is Undefined, optional
        private Dns name options
    ramDiskId : str, default is Undefined, optional
        The ID of the RAM disk.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    secondaryInterfaces : [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecondaryInterfaces], default is Undefined, optional
        Secondary interfaces to associate with instances launched from the template. See Secondary
        Interfaces below for more details.
    securityGroupNameRefs : [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameRefs], default is Undefined, optional
        References to SecurityGroup in ec2 to populate securityGroupNames.
    securityGroupNameSelector : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameSelector, default is Undefined, optional
        security group name selector
    securityGroupNames : [str], default is Undefined, optional
        A list of security group names to associate with. If you are creating Instances in a VPC, use
        vpc_security_group_ids instead.
    tagSpecifications : [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderTagSpecifications], default is Undefined, optional
        The tags to apply to the resources during launch. See Tag Specifications below for more details. Default tags are currently not propagated to ASG created resources so you may wish to inject your default tags into this variable against the relevant child resource types created.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    updateDefaultVersion : bool, default is Undefined, optional
        Whether to update Default Version each update. Conflicts with default_version.
    userData : str, default is Undefined, optional
        The base64-encoded user data to provide when launching the instance.
    vpcSecurityGroupIdRefs : [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDRefs], default is Undefined, optional
        References to SecurityGroup in ec2 to populate vpcSecurityGroupIds.
    vpcSecurityGroupIdSelector : Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDSelector, default is Undefined, optional
        vpc security group Id selector
    vpcSecurityGroupIds : [str], default is Undefined, optional
        A list of security group IDs to associate with. Conflicts with network_interfaces.security_groups
    """


    blockDeviceMappings?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderBlockDeviceMappings]

    capacityReservationSpecification?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCapacityReservationSpecification

    cpuOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCPUOptions

    creditSpecification?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderCreditSpecification

    defaultVersion?: float

    description?: str

    disableApiStop?: bool

    disableApiTermination?: bool

    ebsOptimized?: str

    enclaveOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderEnclaveOptions

    hibernationOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderHibernationOptions

    iamInstanceProfile?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderIamInstanceProfile

    imageId?: str

    instanceInitiatedShutdownBehavior?: str

    instanceMarketOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceMarketOptions

    instanceRequirements?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderInstanceRequirements

    instanceType?: str

    kernelId?: str

    keyName?: str

    licenseSpecification?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderLicenseSpecification]

    maintenanceOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderMaintenanceOptions

    metadataOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderMetadataOptions

    monitoring?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderMonitoring

    name?: str

    networkInterfaces?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkInterfaces]

    networkPerformanceOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderNetworkPerformanceOptions

    placement?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderPlacement

    privateDnsNameOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderPrivateDNSNameOptions

    ramDiskId?: str

    region: str

    secondaryInterfaces?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecondaryInterfaces]

    securityGroupNameRefs?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameRefs]

    securityGroupNameSelector?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSecurityGroupNameSelector

    securityGroupNames?: [str]

    tagSpecifications?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderTagSpecifications]

    tags?: {str:str}

    updateDefaultVersion?: bool

    userData?: str

    vpcSecurityGroupIdRefs?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDRefs]

    vpcSecurityGroupIdSelector?: Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDSelector

    vpcSecurityGroupIds?: [str]




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateStatusAtProvider:
    r"""
    launch template v1beta1 status at provider

    Attributes
    ----------
    arn : str, default is Undefined, optional
        ARN of the launch template.
    blockDeviceMappings : [Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderBlockDeviceMappings], default is Undefined, optional
        Specify volumes to attach to the instance besides the volumes specified by the AMI.
        See Block Devices below for details.
    capacityReservationSpecification : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCapacityReservationSpecification, default is Undefined, optional
        capacity reservation specification
    cpuOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCPUOptions, default is Undefined, optional
        cpu options
    creditSpecification : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCreditSpecification, default is Undefined, optional
        credit specification
    defaultVersion : float, default is Undefined, optional
        Default Version of the launch template.
    description : str, default is Undefined, optional
        Description of the launch template version (VersionDescription in the EC2 API). Launch templates in AWS do not have a template-level description; whenever a change to this resource creates a new version, the new version is created with this description. To give each version a distinct description, update this argument in the same apply as the other changes.
    disableApiStop : bool, default is Undefined, optional
        If true, enables EC2 Instance Stop Protection.
    disableApiTermination : bool, default is Undefined, optional
        If true, enables EC2 Instance
        Termination Protection
    ebsOptimized : str, default is Undefined, optional
        If true, the launched EC2 instance will be EBS-optimized.
    enclaveOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderEnclaveOptions, default is Undefined, optional
        enclave options
    hibernationOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderHibernationOptions, default is Undefined, optional
        hibernation options
    iamInstanceProfile : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderIamInstanceProfile, default is Undefined, optional
        iam instance profile
    id : str, default is Undefined, optional
        The ID of the launch template.
    imageId : str, default is Undefined, optional
        The AMI from which to launch the instance or use a Systems Manager parameter convention e.g. resolve:ssm:parameter-name. See docs for more details.
    instanceInitiatedShutdownBehavior : str, default is Undefined, optional
        Shutdown behavior for the instance. Can be stop or terminate.
        (Default: stop).
    instanceMarketOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceMarketOptions, default is Undefined, optional
        instance market options
    instanceRequirements : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirements, default is Undefined, optional
        instance requirements
    instanceType : str, default is Undefined, optional
        The type of the instance. If present then instance_requirements cannot be present.
    kernelId : str, default is Undefined, optional
        The kernel ID.
    keyName : str, default is Undefined, optional
        The key name to use for the instance.
    latestVersion : float, default is Undefined, optional
        The latest version of the launch template.
    licenseSpecification : [Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderLicenseSpecification], default is Undefined, optional
        A list of license specifications to associate with. See License Specification below for more details.
    maintenanceOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderMaintenanceOptions, default is Undefined, optional
        maintenance options
    metadataOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderMetadataOptions, default is Undefined, optional
        metadata options
    monitoring : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderMonitoring, default is Undefined, optional
        monitoring
    name : str, default is Undefined, optional
        The name of the launch template.
    networkInterfaces : [Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfaces], default is Undefined, optional
        Customize network interfaces to be attached at instance boot time. See Network
        Interfaces below for more details.
    networkPerformanceOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkPerformanceOptions, default is Undefined, optional
        network performance options
    placement : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderPlacement, default is Undefined, optional
        placement
    privateDnsNameOptions : Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderPrivateDNSNameOptions, default is Undefined, optional
        private Dns name options
    ramDiskId : str, default is Undefined, optional
        The ID of the RAM disk.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    secondaryInterfaces : [Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderSecondaryInterfaces], default is Undefined, optional
        Secondary interfaces to associate with instances launched from the template. See Secondary
        Interfaces below for more details.
    securityGroupNames : [str], default is Undefined, optional
        A list of security group names to associate with. If you are creating Instances in a VPC, use
        vpc_security_group_ids instead.
    tagSpecifications : [Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderTagSpecifications], default is Undefined, optional
        The tags to apply to the resources during launch. See Tag Specifications below for more details. Default tags are currently not propagated to ASG created resources so you may wish to inject your default tags into this variable against the relevant child resource types created.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    tagsAll : {str:str}, default is Undefined, optional
        A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block.
    updateDefaultVersion : bool, default is Undefined, optional
        Whether to update Default Version each update. Conflicts with default_version.
    userData : str, default is Undefined, optional
        The base64-encoded user data to provide when launching the instance.
    vpcSecurityGroupIds : [str], default is Undefined, optional
        A list of security group IDs to associate with. Conflicts with network_interfaces.security_groups
    """


    arn?: str

    blockDeviceMappings?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderBlockDeviceMappings]

    capacityReservationSpecification?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCapacityReservationSpecification

    cpuOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCPUOptions

    creditSpecification?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderCreditSpecification

    defaultVersion?: float

    description?: str

    disableApiStop?: bool

    disableApiTermination?: bool

    ebsOptimized?: str

    enclaveOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderEnclaveOptions

    hibernationOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderHibernationOptions

    iamInstanceProfile?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderIamInstanceProfile

    id?: str

    imageId?: str

    instanceInitiatedShutdownBehavior?: str

    instanceMarketOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceMarketOptions

    instanceRequirements?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderInstanceRequirements

    instanceType?: str

    kernelId?: str

    keyName?: str

    latestVersion?: float

    licenseSpecification?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderLicenseSpecification]

    maintenanceOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderMaintenanceOptions

    metadataOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderMetadataOptions

    monitoring?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderMonitoring

    name?: str

    networkInterfaces?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkInterfaces]

    networkPerformanceOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderNetworkPerformanceOptions

    placement?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderPlacement

    privateDnsNameOptions?: Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderPrivateDNSNameOptions

    ramDiskId?: str

    region?: str

    secondaryInterfaces?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderSecondaryInterfaces]

    securityGroupNames?: [str]

    tagSpecifications?: [Ec2AwsmUpboundIoV1beta1LaunchTemplateAtProviderTagSpecifications]

    tags?: {str:str}

    tagsAll?: {str:str}

    updateDefaultVersion?: bool

    userData?: str

    vpcSecurityGroupIds?: [str]




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSubnetIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderSubnetIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDRefsPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1LaunchTemplateSpecForProviderVpcSecurityGroupIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"

schema Ec2AwsmUpboundIoV1beta1SecurityGroupAtProviderEgress:
    r"""
    security group v1beta1 at provider egress

    Attributes
    ----------
    cidrBlocks : [str], default is Undefined, optional
        List of CIDR blocks.
    description : str, default is Undefined, optional
        Security group description. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags.
    fromPort : float, default is Undefined, optional
        Start port (or ICMP type number if protocol is icmp or icmpv6).
    ipv6CidrBlocks : [str], default is Undefined, optional
        List of IPv6 CIDR blocks.
    prefixListIds : [str], default is Undefined, optional
        List of Prefix List IDs.
    $protocol : str, default is Undefined, optional
        Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from_port and to_port equal to 0. The supported values are defined in the IpProtocol argument on the IpPermission API reference.12.
    securityGroups : [str], default is Undefined, optional
        List of security groups. A group name can be used relative to the default VPC. Otherwise, group ID.
    self : bool, default is Undefined, optional
        Whether the security group itself will be added as a source to this ingress rule.
    toPort : float, default is Undefined, optional
        End range port (or ICMP code if protocol is icmp).
    """


    cidrBlocks?: [str]

    description?: str

    fromPort?: float

    ipv6CidrBlocks?: [str]

    prefixListIds?: [str]

    $protocol?: str

    securityGroups?: [str]

    self?: bool

    toPort?: float




schema Ec2AwsmUpboundIoV1beta1SecurityGroupAtProviderIngress:
    r"""
    security group v1beta1 at provider ingress

    Attributes
    ----------
    cidrBlocks : [str], default is Undefined, optional
        List of CIDR blocks.
    description : str, default is Undefined, optional
        Security group description. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags.
    fromPort : float, default is Undefined, optional
        Start port (or ICMP type number if protocol is icmp or icmpv6).
    ipv6CidrBlocks : [str], default is Undefined, optional
        List of IPv6 CIDR blocks.
    prefixListIds : [str], default is Undefined, optional
        List of Prefix List IDs.
    $protocol : str, default is Undefined, optional
        Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from_port and to_port equal to 0. The supported values are defined in the IpProtocol argument on the IpPermission API reference.12.
    securityGroups : [str], default is Undefined, optional
        List of security groups. A group name can be used relative to the default VPC. Otherwise, group ID.
    self : bool, default is Undefined, optional
        Whether the security group itself will be added as a source to this ingress rule.
    toPort : float, default is Undefined, optional
        End range port (or ICMP code if protocol is icmp).
    """


    cidrBlocks?: [str]

    description?: str

    fromPort?: float

    ipv6CidrBlocks?: [str]

    prefixListIds?: [str]

    $protocol?: str

    securityGroups?: [str]

    self?: bool

    toPort?: float




schema Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDRef:
    r"""
    Reference to a VPC in ec2 to populate vpcId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDRefPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDSelector:
    r"""
    Selector for a VPC in ec2 to populate vpcId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProvider:
    r"""
    security group v1beta1 spec for provider

    Attributes
    ----------
    description : str, default is Undefined, optional
        Security group description. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags.
    name : str, default is Undefined, optional
        Name of the security group.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    revokeRulesOnDelete : bool, default is Undefined, optional
        This is normally not needed, however certain AWS services such as Elastic Map Reduce may automatically add required rules to security groups used with the service, and those rules may contain a cyclic dependency that prevent the security groups from being destroyed without removing the dependency first. Default false.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    vpcId : str, default is Undefined, optional
        VPC ID. Defaults to the region's default VPC.
    vpcIdRef : Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDRef, default is Undefined, optional
        vpc Id ref
    vpcIdSelector : Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDSelector, default is Undefined, optional
        vpc Id selector
    """


    description?: str

    name?: str

    region: str

    revokeRulesOnDelete?: bool

    tags?: {str:str}

    vpcId?: str

    vpcIdRef?: Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDRef

    vpcIdSelector?: Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDSelector




schema Ec2AwsmUpboundIoV1beta1SecurityGroupStatusAtProvider:
    r"""
    security group v1beta1 status at provider

    Attributes
    ----------
    arn : str, default is Undefined, optional
        ARN of the security group.
    description : str, default is Undefined, optional
        Security group description. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags.
    egress : [Ec2AwsmUpboundIoV1beta1SecurityGroupAtProviderEgress], default is Undefined, optional
        Configuration block for egress rules. Can be specified multiple times for each egress rule. Each egress block supports fields documented below. This argument is processed in attribute-as-blocks mode.
    id : str, default is Undefined, optional
        ID of the security group.
    ingress : [Ec2AwsmUpboundIoV1beta1SecurityGroupAtProviderIngress], default is Undefined, optional
        Configuration block for ingress rules. Can be specified multiple times for each ingress rule. Each ingress block supports fields documented below. This argument is processed in attribute-as-blocks mode.
    name : str, default is Undefined, optional
        Name of the security group.
    ownerId : str, default is Undefined, optional
        Owner ID.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    revokeRulesOnDelete : bool, default is Undefined, optional
        This is normally not needed, however certain AWS services such as Elastic Map Reduce may automatically add required rules to security groups used with the service, and those rules may contain a cyclic dependency that prevent the security groups from being destroyed without removing the dependency first. Default false.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    tagsAll : {str:str}, default is Undefined, optional
        A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block.
    vpcId : str, default is Undefined, optional
        VPC ID. Defaults to the region's default VPC.
    """


    arn?: str

    description?: str

    egress?: [Ec2AwsmUpboundIoV1beta1SecurityGroupAtProviderEgress]

    id?: str

    ingress?: [Ec2AwsmUpboundIoV1beta1SecurityGroupAtProviderIngress]

    name?: str

    ownerId?: str

    region?: str

    revokeRulesOnDelete?: bool

    tags?: {str:str}

    tagsAll?: {str:str}

    vpcId?: str




schema Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupSpecForProviderVpcIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"

schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksRefsPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksRefs:
    r"""
    A NamespacedReference to a named object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksRefsPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksRefsPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksSelector:
    r"""
    Selector for a list of VPC in ec2 to populate cidrBlocks.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksRefs:
    r"""
    A NamespacedReference to a named object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksRefsPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksRefsPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksSelector:
    r"""
    Selector for a list of VPC in ec2 to populate ipv6CidrBlocks.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDRefs:
    r"""
    A NamespacedReference to a named object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDRefsPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDRefsPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDSelector:
    r"""
    Selector for a list of ManagedPrefixList in ec2 to populate prefixListIds.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDRef:
    r"""
    Reference to a SecurityGroup in ec2 to populate securityGroupId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDRefPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDSelector:
    r"""
    Selector for a SecurityGroup in ec2 to populate securityGroupId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDRef:
    r"""
    Reference to a SecurityGroup in ec2 to populate sourceSecurityGroupId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDRefPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDSelector:
    r"""
    Selector for a SecurityGroup in ec2 to populate sourceSecurityGroupId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDSelectorPolicy




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksRefsPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDRefsPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProvider:
    r"""
    security group rule v1beta1 spec for provider

    Attributes
    ----------
    cidrBlocks : [str], default is Undefined, optional
        List of CIDR blocks. Cannot be specified with source_security_group_id or self.
    cidrBlocksRefs : [Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksRefs], default is Undefined, optional
        References to VPC in ec2 to populate cidrBlocks.
    cidrBlocksSelector : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksSelector, default is Undefined, optional
        cidr blocks selector
    description : str, default is Undefined, optional
        Description of the rule.
    fromPort : float, default is Undefined, optional
        Start port (or ICMP type number if protocol is "icmp" or "icmpv6").
    ipv6CidrBlocks : [str], default is Undefined, optional
        List of IPv6 CIDR blocks. Cannot be specified with source_security_group_id or self.
    ipv6CidrBlocksRefs : [Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksRefs], default is Undefined, optional
        References to VPC in ec2 to populate ipv6CidrBlocks.
    ipv6CidrBlocksSelector : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksSelector, default is Undefined, optional
        ipv6 cidr blocks selector
    prefixListIdRefs : [Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDRefs], default is Undefined, optional
        References to ManagedPrefixList in ec2 to populate prefixListIds.
    prefixListIdSelector : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDSelector, default is Undefined, optional
        prefix list Id selector
    prefixListIds : [str], default is Undefined, optional
        List of Prefix List IDs.
    $protocol : str, default is Undefined, optional
        Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    securityGroupId : str, default is Undefined, optional
        Security group to apply this rule to.
    securityGroupIdRef : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDRef, default is Undefined, optional
        security group Id ref
    securityGroupIdSelector : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDSelector, default is Undefined, optional
        security group Id selector
    self : bool, default is Undefined, optional
        Whether the security group itself will be added as a source to this ingress rule. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or source_security_group_id.
    sourceSecurityGroupId : str, default is Undefined, optional
        Security group id to allow access to/from, depending on the type. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or self.
    sourceSecurityGroupIdRef : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDRef, default is Undefined, optional
        source security group Id ref
    sourceSecurityGroupIdSelector : Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDSelector, default is Undefined, optional
        source security group Id selector
    toPort : float, default is Undefined, optional
        End port (or ICMP code if protocol is "icmp").
    $type : str, default is Undefined, optional
        Type of rule being created. Valid options are ingress (inbound)
        or egress (outbound).
    """


    cidrBlocks?: [str]

    cidrBlocksRefs?: [Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksRefs]

    cidrBlocksSelector?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderCidrBlocksSelector

    description?: str

    fromPort?: float

    ipv6CidrBlocks?: [str]

    ipv6CidrBlocksRefs?: [Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksRefs]

    ipv6CidrBlocksSelector?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderIPV6CidrBlocksSelector

    prefixListIdRefs?: [Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDRefs]

    prefixListIdSelector?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderPrefixListIDSelector

    prefixListIds?: [str]

    $protocol?: str

    region: str

    securityGroupId?: str

    securityGroupIdRef?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDRef

    securityGroupIdSelector?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSecurityGroupIDSelector

    self?: bool

    sourceSecurityGroupId?: str

    sourceSecurityGroupIdRef?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDRef

    sourceSecurityGroupIdSelector?: Ec2AwsmUpboundIoV1beta1SecurityGroupRuleSpecForProviderSourceSecurityGroupIDSelector

    toPort?: float

    $type?: str




schema Ec2AwsmUpboundIoV1beta1SecurityGroupRuleStatusAtProvider:
    r"""
    security group rule v1beta1 status at provider

    Attributes
    ----------
    cidrBlocks : [str], default is Undefined, optional
        List of CIDR blocks. Cannot be specified with source_security_group_id or self.
    description : str, default is Undefined, optional
        Description of the rule.
    fromPort : float, default is Undefined, optional
        Start port (or ICMP type number if protocol is "icmp" or "icmpv6").
    id : str, default is Undefined, optional
        ID of the security group rule.
    ipv6CidrBlocks : [str], default is Undefined, optional
        List of IPv6 CIDR blocks. Cannot be specified with source_security_group_id or self.
    prefixListIds : [str], default is Undefined, optional
        List of Prefix List IDs.
    $protocol : str, default is Undefined, optional
        Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    securityGroupId : str, default is Undefined, optional
        Security group to apply this rule to.
    securityGroupRuleId : str, default is Undefined, optional
        If the aws_security_group_rule resource has a single source or destination then this is the AWS Security Group Rule resource ID. Otherwise it is empty.
    self : bool, default is Undefined, optional
        Whether the security group itself will be added as a source to this ingress rule. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or source_security_group_id.
    sourceSecurityGroupId : str, default is Undefined, optional
        Security group id to allow access to/from, depending on the type. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or self.
    toPort : float, default is Undefined, optional
        End port (or ICMP code if protocol is "icmp").
    $type : str, default is Undefined, optional
        Type of rule being created. Valid options are ingress (inbound)
        or egress (outbound).
    """


    cidrBlocks?: [str]

    description?: str

    fromPort?: float

    id?: str

    ipv6CidrBlocks?: [str]

    prefixListIds?: [str]

    $protocol?: str

    region?: str

    securityGroupId?: str

    securityGroupRuleId?: str

    self?: bool

    sourceSecurityGroupId?: str

    toPort?: float

    $type?: str

schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderAvailabilityZoneDistribution:
    r"""
    The instance capacity distribution across Availability Zones. See availability_zone_distribution Block below for more details.

    Attributes
    ----------
    capacityDistributionStrategy : str, default is Undefined, optional
        The strategy to use for distributing capacity across the Availability Zones. Valid values are balanced-only, balanced-best-effort, and reservations-then-balanced. Default is balanced-best-effort. When reservations-then-balanced is set, you must also specify Capacity Reservations to prioritize through capacity_reservation_specification (or via a launch template) using a Capacity Reservation ID or Capacity Reservation resource group ARN.
    """


    capacityDistributionStrategy?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderCapacityReservationSpecification:
    r"""
    Demand Capacity Reservations. See capacity_reservation_specification Block below for more details.

    Attributes
    ----------
    capacityReservationPreference : str, default is Undefined, optional
        Capacity Reservation preference helps you use Capacity Reservations efficiently by prioritizing reserved capacity in a Capacity Reservation before using On-Demand capacity. Valid values are default, capacity-reservations-only, capacity-reservations-first and none. Default is default.
    capacityReservationTarget : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderCapacityReservationSpecificationCapacityReservationTarget, default is Undefined, optional
        capacity reservation target
    """


    capacityReservationPreference?: str

    capacityReservationTarget?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderCapacityReservationSpecificationCapacityReservationTarget




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderCapacityReservationSpecificationCapacityReservationTarget:
    r"""
    Describes a target Capacity Reservation or Capacity Reservation resource group.

    Attributes
    ----------
    capacityReservationIds : [str], default is Undefined, optional
        List of On-Demand Capacity Reservation Ids. Conflicts with capacity_reservation_resource_group_arns.
    capacityReservationResourceGroupArns : [str], default is Undefined, optional
        List of On-Demand Capacity Reservation Resource Group Arns. Conflicts with capacity_reservation_ids.
    """


    capacityReservationIds?: [str]

    capacityReservationResourceGroupArns?: [str]




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInitialLifecycleHook:
    r"""
    autoscaling group v1beta1 at provider initial lifecycle hook

    Attributes
    ----------
    defaultResult : str, default is Undefined, optional
        default result
    heartbeatTimeout : float, default is Undefined, optional
        heartbeat timeout
    lifecycleTransition : str, default is Undefined, optional
        lifecycle transition
    name : str, default is Undefined, optional
        Name of the Auto Scaling Group. Conflicts with name_prefix.
    notificationMetadata : str, default is Undefined, optional
        notification metadata
    notificationTargetArn : str, default is Undefined, optional
        ARN for this Auto Scaling Group
    roleArn : str, default is Undefined, optional
        ARN for this Auto Scaling Group
    """


    defaultResult?: str

    heartbeatTimeout?: float

    lifecycleTransition?: str

    name?: str

    notificationMetadata?: str

    notificationTargetArn?: str

    roleArn?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceLifecyclePolicy:
    r"""
    If this block is configured, adds an instance lifecycle policy to the specified Auto Scaling Group. Defined below.

    Attributes
    ----------
    retentionTriggers : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceLifecyclePolicyRetentionTriggers, default is Undefined, optional
        retention triggers
    """


    retentionTriggers?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceLifecyclePolicyRetentionTriggers




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceLifecyclePolicyRetentionTriggers:
    r"""
    Conditions that trigger instance retention behavior. Defined below.

    Attributes
    ----------
    terminateHookAbandon : str, default is Undefined, optional
        Action to take when a termination lifecycle hook is abandoned due to failure, timeout, or explicit abandonment. Valid values are retain and terminate. Set to retain to move instances to a retained state instead of terminating them. Retained instances don't count toward desired capacity and remain until you terminate them.
    """


    terminateHookAbandon?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceMaintenancePolicy:
    r"""
    If this block is configured, add a instance maintenance policy to the specified Auto Scaling group. Defined below.

    Attributes
    ----------
    maxHealthyPercentage : float, default is Undefined, optional
        Amount of capacity in the Auto Scaling group that can be in service and healthy, or pending, to support your workload when an instance refresh is in place, as a percentage of the desired capacity of the Auto Scaling group. Values must be between 100 and 200, defaults to 100.
    minHealthyPercentage : float, default is Undefined, optional
        Amount of capacity in the Auto Scaling group that must remain healthy during an instance refresh to allow the operation to continue, as a percentage of the desired capacity of the Auto Scaling group. Defaults to 90.
    """


    maxHealthyPercentage?: float

    minHealthyPercentage?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceRefresh:
    r"""
    If this block is configured, start an
    Instance Refresh
    when this Auto Scaling Group is updated. Defined below.

    Attributes
    ----------
    preferences : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceRefreshPreferences, default is Undefined, optional
        preferences
    strategy : str, default is Undefined, optional
        Strategy to use for instance refresh. The only allowed value is Rolling. See StartInstanceRefresh Action for more information.
    triggers : [str], default is Undefined, optional
        Set of additional property names that will trigger an Instance Refresh. A refresh will always be triggered by a change in any of launch_configuration, launch_template, or mixed_instances_policy.
    """


    preferences?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceRefreshPreferences

    strategy?: str

    triggers?: [str]




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceRefreshPreferences:
    r"""
    Override default parameters for Instance Refresh.

    Attributes
    ----------
    alarmSpecification : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceRefreshPreferencesAlarmSpecification, default is Undefined, optional
        alarm specification
    autoRollback : bool, default is Undefined, optional
        Automatically rollback if instance refresh fails. Defaults to false. This option may only be set to true when specifying a launch_template or mixed_instances_policy.
    checkpointDelay : str, default is Undefined, optional
        Number of seconds to wait after a checkpoint. Defaults to 3600.
    checkpointPercentages : [float], default is Undefined, optional
        List of percentages for each checkpoint. Values must be unique and in ascending order. To replace all instances, the final number must be 100.
    instanceWarmup : str, default is Undefined, optional
        Number of seconds until a newly launched instance is configured and ready to use. Default behavior is to use the Auto Scaling Group's health check grace period.
    maxHealthyPercentage : float, default is Undefined, optional
        Amount of capacity in the Auto Scaling group that can be in service and healthy, or pending, to support your workload when an instance refresh is in place, as a percentage of the desired capacity of the Auto Scaling group. Values must be between 100 and 200, defaults to 100.
    minHealthyPercentage : float, default is Undefined, optional
        Amount of capacity in the Auto Scaling group that must remain healthy during an instance refresh to allow the operation to continue, as a percentage of the desired capacity of the Auto Scaling group. Defaults to 90.
    scaleInProtectedInstances : str, default is Undefined, optional
        Behavior when encountering instances protected from scale in are found. Available behaviors are Refresh, Ignore, and Wait. Default is Ignore.
    skipMatching : bool, default is Undefined, optional
        Skip replacing instances that already have your desired configuration. Defaults to false.
    standbyInstances : str, default is Undefined, optional
        Behavior when encountering instances in the Standby state in are found. Available behaviors are Terminate, Ignore, and Wait. Default is Ignore.
    """


    alarmSpecification?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceRefreshPreferencesAlarmSpecification

    autoRollback?: bool

    checkpointDelay?: str

    checkpointPercentages?: [float]

    instanceWarmup?: str

    maxHealthyPercentage?: float

    minHealthyPercentage?: float

    scaleInProtectedInstances?: str

    skipMatching?: bool

    standbyInstances?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceRefreshPreferencesAlarmSpecification:
    r"""
    Alarm Specification for Instance Refresh.

    Attributes
    ----------
    alarms : [str], default is Undefined, optional
        List of Cloudwatch alarms. If any of these alarms goes into ALARM state, Instance Refresh is failed.
    """


    alarms?: [str]




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderLaunchTemplate:
    r"""
    Nested argument with Launch template specification to use to launch instances. See launch_template Block below for more details.

    Attributes
    ----------
    id : str, default is Undefined, optional
        ID of the launch template. Conflicts with name.
    name : str, default is Undefined, optional
        Name of the launch template. Conflicts with id.
    version : str, default is Undefined, optional
        Template version. Can be version number, $Latest, or $Default. (Default: $Default).
    """


    id?: str

    name?: str

    version?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicy:
    r"""
    Configuration block containing settings to define launch targets for Auto Scaling groups. See mixed_instances_policy Block below for more details.

    Attributes
    ----------
    instancesDistribution : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyInstancesDistribution, default is Undefined, optional
        instances distribution
    launchTemplate : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyLaunchTemplate, default is Undefined, optional
        launch template
    """


    instancesDistribution?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyInstancesDistribution

    launchTemplate?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyLaunchTemplate




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyInstancesDistribution:
    r"""
    Nested argument containing settings on how to mix on-demand and Spot instances in the Auto Scaling group. Defined below.

    Attributes
    ----------
    onDemandAllocationStrategy : str, default is Undefined, optional
        Strategy to use when launching on-demand instances. Valid values: prioritized, lowest-price. Default: prioritized.
    onDemandBaseCapacity : float, default is Undefined, optional
        Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances. Default: 0.
    onDemandPercentageAboveBaseCapacity : float, default is Undefined, optional
        Percentage split between on-demand and Spot instances above the base on-demand capacity. Default: 100.
    spotAllocationStrategy : str, default is Undefined, optional
        How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized, capacity-optimized-prioritized, and price-capacity-optimized. Default: lowest-price.
    spotInstancePools : float, default is Undefined, optional
        Number of Spot pools per availability zone to allocate capacity. EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates Spot capacity across the number of Spot pools that you specify. Only available with spot_allocation_strategy set to lowest-price. Otherwise it must be set to 0, if it has been defined before. Default: 2.
    spotMaxPrice : str, default is Undefined, optional
        Maximum price per unit hour that the user is willing to pay for the Spot instances. Default: an empty string which means the on-demand price.
    """


    onDemandAllocationStrategy?: str

    onDemandBaseCapacity?: float

    onDemandPercentageAboveBaseCapacity?: float

    spotAllocationStrategy?: str

    spotInstancePools?: float

    spotMaxPrice?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyLaunchTemplate:
    r"""
    Nested argument containing launch template settings along with the overrides to specify multiple instance types and weights. Defined below.

    Attributes
    ----------
    launchTemplateSpecification : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyLaunchTemplateLaunchTemplateSpecification, default is Undefined, optional
        launch template specification
    override : [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyLaunchTemplateOverride], default is Undefined, optional
        List of nested arguments provides the ability to specify multiple instance types. This will override the same parameter in the launch template. For on-demand instances, Auto Scaling considers the order of preference of instance types to launch based on the order specified in the overrides list. Defined below.
    """


    launchTemplateSpecification?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyLaunchTemplateLaunchTemplateSpecification

    override?: [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyLaunchTemplateOverride]




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyLaunchTemplateLaunchTemplateSpecification:
    r"""
    Nested argument defines the Launch Template. Defined below.

    Attributes
    ----------
    launchTemplateId : str, default is Undefined, optional
        ID of the launch template. Conflicts with launch_template_name.
    launchTemplateName : str, default is Undefined, optional
        Name of the launch template. Conflicts with launch_template_id.
    version : str, default is Undefined, optional
        Template version. Can be version number, $Latest, or $Default. (Default: $Default).
    """


    launchTemplateId?: str

    launchTemplateName?: str

    version?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicyLaunchTemplateOverride:
    r"""
    autoscaling group v1beta1 at provider mixed instances policy launch template override

    Attributes
    ----------
    instanceRequirements : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyLaunchTemplateOverrideInstanceRequirements, default is Undefined, optional
        instance requirements
    instanceType : str, default is Undefined, optional
        Override the instance type in the Launch Template.
    launchTemplateSpecification : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyLaunchTemplateOverrideLaunchTemplateSpecification, default is Undefined, optional
        launch template specification
    weightedCapacity : str, default is Undefined, optional
        Number of capacity units, which gives the instance type a proportional weight to other instance types.
    """


    instanceRequirements?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyLaunchTemplateOverrideInstanceRequirements

    instanceType?: str

    launchTemplateSpecification?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyLaunchTemplateOverrideLaunchTemplateSpecification

    weightedCapacity?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderTag:
    r"""
    autoscaling group v1beta1 at provider tag

    Attributes
    ----------
    key : str, default is Undefined, optional
        Key
    propagateAtLaunch : bool, default is Undefined, optional
        Enables propagation of the tag to
        Amazon EC2 instances launched via this ASG
    value : str, default is Undefined, optional
        Value
    """


    key?: str

    propagateAtLaunch?: bool

    value?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderTrafficSource:
    r"""
    autoscaling group v1beta1 at provider traffic source

    Attributes
    ----------
    identifier : str, default is Undefined, optional
        Identifies the traffic source. For Application Load Balancers, Gateway Load Balancers, Network Load Balancers, and VPC Lattice, this will be the ARN for a target group in this account and Region. For Classic Load Balancers, this will be the name of the Classic Load Balancer in this account and Region.
    $type : str, default is Undefined, optional
        Provides additional context for the value of Identifier.
        The following lists the valid values:
        elb if identifier is the name of a Classic Load Balancer.
        elbv2 if identifier is the ARN of an Application Load Balancer, Gateway Load Balancer, or Network Load Balancer target group.
        vpc-lattice if identifier is the ARN of a VPC Lattice target group.
    """


    identifier?: str

    $type?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderWarmPool:
    r"""
    If this block is configured, add a Warm Pool
    to the specified Auto Scaling group. Defined below

    Attributes
    ----------
    instanceReusePolicy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderWarmPoolInstanceReusePolicy, default is Undefined, optional
        instance reuse policy
    maxGroupPreparedCapacity : float, default is Undefined, optional
        Total maximum number of instances that are allowed to be in the warm pool or in any state except Terminated for the Auto Scaling group.
    minSize : float, default is Undefined, optional
        Minimum size of the Auto Scaling Group.
        (See also Waiting for Capacity below.)
    poolState : str, default is Undefined, optional
        Sets the instance state to transition to after the lifecycle hooks finish. Valid values are: Stopped (default), Running or Hibernated.
    """


    instanceReusePolicy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderWarmPoolInstanceReusePolicy

    maxGroupPreparedCapacity?: float

    minSize?: float

    poolState?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderWarmPoolInstanceReusePolicy:
    r"""
    Whether instances in the Auto Scaling group can be returned to the warm pool on scale in. The default is to terminate instances in the Auto Scaling group when the group scales in.

    Attributes
    ----------
    reuseOnScaleIn : bool, default is Undefined, optional
        Whether instances in the Auto Scaling group can be returned to the warm pool on scale in.
    """


    reuseOnScaleIn?: bool




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderCapacityReservationSpecificationCapacityReservationTarget:
    r"""
    Describes a target Capacity Reservation or Capacity Reservation resource group.

    Attributes
    ----------
    capacityReservationIds : [str], default is Undefined, optional
        List of On-Demand Capacity Reservation Ids. Conflicts with capacity_reservation_resource_group_arns.
    capacityReservationResourceGroupArns : [str], default is Undefined, optional
        List of On-Demand Capacity Reservation Resource Group Arns. Conflicts with capacity_reservation_ids.
    """


    capacityReservationIds?: [str]

    capacityReservationResourceGroupArns?: [str]




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderAvailabilityZoneDistribution:
    r"""
    The instance capacity distribution across Availability Zones. See availability_zone_distribution Block below for more details.

    Attributes
    ----------
    capacityDistributionStrategy : str, default is Undefined, optional
        The strategy to use for distributing capacity across the Availability Zones. Valid values are balanced-only, balanced-best-effort, and reservations-then-balanced. Default is balanced-best-effort. When reservations-then-balanced is set, you must also specify Capacity Reservations to prioritize through capacity_reservation_specification (or via a launch template) using a Capacity Reservation ID or Capacity Reservation resource group ARN.
    """


    capacityDistributionStrategy?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderCapacityReservationSpecification:
    r"""
    Demand Capacity Reservations. See capacity_reservation_specification Block below for more details.

    Attributes
    ----------
    capacityReservationPreference : str, default is Undefined, optional
        Capacity Reservation preference helps you use Capacity Reservations efficiently by prioritizing reserved capacity in a Capacity Reservation before using On-Demand capacity. Valid values are default, capacity-reservations-only, capacity-reservations-first and none. Default is default.
    capacityReservationTarget : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderCapacityReservationSpecificationCapacityReservationTarget, default is Undefined, optional
        capacity reservation target
    """


    capacityReservationPreference?: str

    capacityReservationTarget?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderCapacityReservationSpecificationCapacityReservationTarget




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInitialLifecycleHook:
    r"""
    autoscaling group v1beta1 for provider initial lifecycle hook

    Attributes
    ----------
    defaultResult : str, default is Undefined, optional
        default result
    heartbeatTimeout : float, default is Undefined, optional
        heartbeat timeout
    lifecycleTransition : str, default is Undefined, optional
        lifecycle transition
    name : str, default is Undefined, optional
        Name of the Auto Scaling Group. Conflicts with name_prefix.
    notificationMetadata : str, default is Undefined, optional
        notification metadata
    notificationTargetArn : str, default is Undefined, optional
        ARN for this Auto Scaling Group
    roleArn : str, default is Undefined, optional
        ARN for this Auto Scaling Group
    """


    defaultResult?: str

    heartbeatTimeout?: float

    lifecycleTransition?: str

    name?: str

    notificationMetadata?: str

    notificationTargetArn?: str

    roleArn?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceLifecyclePolicy:
    r"""
    If this block is configured, adds an instance lifecycle policy to the specified Auto Scaling Group. Defined below.

    Attributes
    ----------
    retentionTriggers : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceLifecyclePolicyRetentionTriggers, default is Undefined, optional
        retention triggers
    """


    retentionTriggers?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceLifecyclePolicyRetentionTriggers




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceMaintenancePolicy:
    r"""
    If this block is configured, add a instance maintenance policy to the specified Auto Scaling group. Defined below.

    Attributes
    ----------
    maxHealthyPercentage : float, default is Undefined, optional
        Amount of capacity in the Auto Scaling group that can be in service and healthy, or pending, to support your workload when an instance refresh is in place, as a percentage of the desired capacity of the Auto Scaling group. Values must be between 100 and 200, defaults to 100.
    minHealthyPercentage : float, default is Undefined, optional
        Amount of capacity in the Auto Scaling group that must remain healthy during an instance refresh to allow the operation to continue, as a percentage of the desired capacity of the Auto Scaling group. Defaults to 90.
    """


    maxHealthyPercentage?: float

    minHealthyPercentage?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRefresh:
    r"""
    If this block is configured, start an
    Instance Refresh
    when this Auto Scaling Group is updated. Defined below.

    Attributes
    ----------
    preferences : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRefreshPreferences, default is Undefined, optional
        preferences
    strategy : str, default is Undefined, optional
        Strategy to use for instance refresh. The only allowed value is Rolling. See StartInstanceRefresh Action for more information.
    triggers : [str], default is Undefined, optional
        Set of additional property names that will trigger an Instance Refresh. A refresh will always be triggered by a change in any of launch_configuration, launch_template, or mixed_instances_policy.
    """


    preferences?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRefreshPreferences

    strategy?: str

    triggers?: [str]




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationRef:
    r"""
    Reference to a LaunchConfiguration in autoscaling to populate launchConfiguration.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationRefPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationSelector:
    r"""
    Selector for a LaunchConfiguration in autoscaling to populate launchConfiguration.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationSelectorPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplate:
    r"""
    Nested argument with Launch template specification to use to launch instances. See launch_template Block below for more details.

    Attributes
    ----------
    id : str, default is Undefined, optional
        ID of the launch template. Conflicts with name.
    idRef : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDRef, default is Undefined, optional
        id ref
    idSelector : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDSelector, default is Undefined, optional
        id selector
    name : str, default is Undefined, optional
        Name of the launch template. Conflicts with id.
    version : str, default is Undefined, optional
        Template version. Can be version number, $Latest, or $Default. (Default: $Default).
    """


    id?: str

    idRef?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDRef

    idSelector?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDSelector

    name?: str

    version?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicy:
    r"""
    Configuration block containing settings to define launch targets for Auto Scaling groups. See mixed_instances_policy Block below for more details.

    Attributes
    ----------
    instancesDistribution : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyInstancesDistribution, default is Undefined, optional
        instances distribution
    launchTemplate : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyLaunchTemplate, default is Undefined, optional
        launch template
    """


    instancesDistribution?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyInstancesDistribution

    launchTemplate?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyLaunchTemplate




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupRef:
    r"""
    Reference to a PlacementGroup in ec2 to populate placementGroup.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupRefPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupSelector:
    r"""
    Selector for a PlacementGroup in ec2 to populate placementGroup.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupSelectorPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnRef:
    r"""
    Reference to a Role in iam to populate serviceLinkedRoleArn.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnRefPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnSelector:
    r"""
    Selector for a Role in iam to populate serviceLinkedRoleArn.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnSelectorPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderTag:
    r"""
    autoscaling group v1beta1 for provider tag

    Attributes
    ----------
    key : str, default is Undefined, optional
        Key
    propagateAtLaunch : bool, default is Undefined, optional
        Enables propagation of the tag to
        Amazon EC2 instances launched via this ASG
    value : str, default is Undefined, optional
        Value
    """


    key?: str

    propagateAtLaunch?: bool

    value?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderTrafficSource:
    r"""
    autoscaling group v1beta1 for provider traffic source

    Attributes
    ----------
    identifier : str, default is Undefined, optional
        Identifies the traffic source. For Application Load Balancers, Gateway Load Balancers, Network Load Balancers, and VPC Lattice, this will be the ARN for a target group in this account and Region. For Classic Load Balancers, this will be the name of the Classic Load Balancer in this account and Region.
    $type : str, default is Undefined, optional
        Provides additional context for the value of Identifier.
        The following lists the valid values:
        elb if identifier is the name of a Classic Load Balancer.
        elbv2 if identifier is the ARN of an Application Load Balancer, Gateway Load Balancer, or Network Load Balancer target group.
        vpc-lattice if identifier is the ARN of a VPC Lattice target group.
    """


    identifier?: str

    $type?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierRefs:
    r"""
    A NamespacedReference to a named object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierRefsPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierRefsPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierSelector:
    r"""
    Selector for a list of Subnet in ec2 to populate vpcZoneIdentifier.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierSelectorPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderWarmPool:
    r"""
    If this block is configured, add a Warm Pool
    to the specified Auto Scaling group. Defined below

    Attributes
    ----------
    instanceReusePolicy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderWarmPoolInstanceReusePolicy, default is Undefined, optional
        instance reuse policy
    maxGroupPreparedCapacity : float, default is Undefined, optional
        Total maximum number of instances that are allowed to be in the warm pool or in any state except Terminated for the Auto Scaling group.
    minSize : float, default is Undefined, optional
        Minimum size of the Auto Scaling Group.
        (See also Waiting for Capacity below.)
    poolState : str, default is Undefined, optional
        Sets the instance state to transition to after the lifecycle hooks finish. Valid values are: Stopped (default), Running or Hibernated.
    """


    instanceReusePolicy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderWarmPoolInstanceReusePolicy

    maxGroupPreparedCapacity?: float

    minSize?: float

    poolState?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceLifecyclePolicyRetentionTriggers:
    r"""
    Conditions that trigger instance retention behavior. Defined below.

    Attributes
    ----------
    terminateHookAbandon : str, default is Undefined, optional
        Action to take when a termination lifecycle hook is abandoned due to failure, timeout, or explicit abandonment. Valid values are retain and terminate. Set to retain to move instances to a retained state instead of terminating them. Retained instances don't count toward desired capacity and remain until you terminate them.
    """


    terminateHookAbandon?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRefreshPreferences:
    r"""
    Override default parameters for Instance Refresh.

    Attributes
    ----------
    alarmSpecification : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPreferencesAlarmSpecification, default is Undefined, optional
        alarm specification
    autoRollback : bool, default is Undefined, optional
        Automatically rollback if instance refresh fails. Defaults to false. This option may only be set to true when specifying a launch_template or mixed_instances_policy.
    checkpointDelay : str, default is Undefined, optional
        Number of seconds to wait after a checkpoint. Defaults to 3600.
    checkpointPercentages : [float], default is Undefined, optional
        List of percentages for each checkpoint. Values must be unique and in ascending order. To replace all instances, the final number must be 100.
    instanceWarmup : str, default is Undefined, optional
        Number of seconds until a newly launched instance is configured and ready to use. Default behavior is to use the Auto Scaling Group's health check grace period.
    maxHealthyPercentage : float, default is Undefined, optional
        Amount of capacity in the Auto Scaling group that can be in service and healthy, or pending, to support your workload when an instance refresh is in place, as a percentage of the desired capacity of the Auto Scaling group. Values must be between 100 and 200, defaults to 100.
    minHealthyPercentage : float, default is Undefined, optional
        Amount of capacity in the Auto Scaling group that must remain healthy during an instance refresh to allow the operation to continue, as a percentage of the desired capacity of the Auto Scaling group. Defaults to 90.
    scaleInProtectedInstances : str, default is Undefined, optional
        Behavior when encountering instances protected from scale in are found. Available behaviors are Refresh, Ignore, and Wait. Default is Ignore.
    skipMatching : bool, default is Undefined, optional
        Skip replacing instances that already have your desired configuration. Defaults to false.
    standbyInstances : str, default is Undefined, optional
        Behavior when encountering instances in the Standby state in are found. Available behaviors are Terminate, Ignore, and Wait. Default is Ignore.
    """


    alarmSpecification?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPreferencesAlarmSpecification

    autoRollback?: bool

    checkpointDelay?: str

    checkpointPercentages?: [float]

    instanceWarmup?: str

    maxHealthyPercentage?: float

    minHealthyPercentage?: float

    scaleInProtectedInstances?: str

    skipMatching?: bool

    standbyInstances?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsAcceleratorCount:
    r"""
    Block describing the minimum and maximum number of accelerators (GPUs, FPGAs, or AWS Inferentia chips). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsAcceleratorTotalMemoryMib:
    r"""
    Block describing the minimum and maximum total memory of the accelerators. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsBaselineEbsBandwidthMbps:
    r"""
    Block describing the minimum and maximum baseline EBS bandwidth, in Mbps. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsMemoryGibPerVcpu:
    r"""
    Block describing the minimum and maximum amount of memory (GiB) per vCPU. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsMemoryMib:
    r"""
    Block describing the minimum and maximum amount of memory (MiB). Default is no maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsNetworkBandwidthGbps:
    r"""
    Block describing the minimum and maximum amount of network bandwidth, in gigabits per second (Gbps). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsNetworkInterfaceCount:
    r"""
    Block describing the minimum and maximum number of network interfaces. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsTotalLocalStorageGb:
    r"""
    Block describing the minimum and maximum total local storage (GB). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsVcpuCount:
    r"""
    Block describing the minimum and maximum number of vCPUs. Default is no maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDRef:
    r"""
    Reference to a LaunchTemplate in ec2 to populate id.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderIDRefPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDSelector:
    r"""
    Selector for a LaunchTemplate in ec2 to populate id.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderIDSelectorPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateLaunchTemplateSpecification:
    r"""
    Nested argument defines the Launch Template. Defined below.

    Attributes
    ----------
    launchTemplateId : str, default is Undefined, optional
        ID of the launch template. Conflicts with launch_template_name.
    launchTemplateIdRef : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDRef, default is Undefined, optional
        launch template Id ref
    launchTemplateIdSelector : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDSelector, default is Undefined, optional
        launch template Id selector
    launchTemplateName : str, default is Undefined, optional
        Name of the launch template. Conflicts with launch_template_id.
    version : str, default is Undefined, optional
        Template version. Can be version number, $Latest, or $Default. (Default: $Default).
    """


    launchTemplateId?: str

    launchTemplateIdRef?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDRef

    launchTemplateIdSelector?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDSelector

    launchTemplateName?: str

    version?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverride:
    r"""
    autoscaling group v1beta1 launch template override

    Attributes
    ----------
    instanceRequirements : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideInstanceRequirements, default is Undefined, optional
        instance requirements
    instanceType : str, default is Undefined, optional
        Override the instance type in the Launch Template.
    launchTemplateSpecification : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideLaunchTemplateSpecification, default is Undefined, optional
        launch template specification
    weightedCapacity : str, default is Undefined, optional
        Number of capacity units, which gives the instance type a proportional weight to other instance types.
    """


    instanceRequirements?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideInstanceRequirements

    instanceType?: str

    launchTemplateSpecification?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideLaunchTemplateSpecification

    weightedCapacity?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsAcceleratorCount:
    r"""
    Block describing the minimum and maximum number of accelerators (GPUs, FPGAs, or AWS Inferentia chips). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsAcceleratorTotalMemoryMib:
    r"""
    Block describing the minimum and maximum total memory of the accelerators. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsBaselineEbsBandwidthMbps:
    r"""
    Block describing the minimum and maximum baseline EBS bandwidth, in Mbps. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsMemoryGibPerVcpu:
    r"""
    Block describing the minimum and maximum amount of memory (GiB) per vCPU. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsMemoryMib:
    r"""
    Block describing the minimum and maximum amount of memory (MiB). Default is no maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsNetworkBandwidthGbps:
    r"""
    Block describing the minimum and maximum amount of network bandwidth, in gigabits per second (Gbps). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsNetworkInterfaceCount:
    r"""
    Block describing the minimum and maximum number of network interfaces. Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsTotalLocalStorageGb:
    r"""
    Block describing the minimum and maximum total local storage (GB). Default is no minimum or maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsVcpuCount:
    r"""
    Block describing the minimum and maximum number of vCPUs. Default is no maximum.

    Attributes
    ----------
    max : float, default is Undefined, optional
        Maximum.
    min : float, default is Undefined, optional
        Minimum.
    """


    max?: float

    min?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDRef:
    r"""
    Reference to a LaunchTemplate in ec2 to populate launchTemplateId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDRefPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDSelector:
    r"""
    Selector for a LaunchTemplate in ec2 to populate launchTemplateId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateIDSelectorPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyInstancesDistribution:
    r"""
    Nested argument containing settings on how to mix on-demand and Spot instances in the Auto Scaling group. Defined below.

    Attributes
    ----------
    onDemandAllocationStrategy : str, default is Undefined, optional
        Strategy to use when launching on-demand instances. Valid values: prioritized, lowest-price. Default: prioritized.
    onDemandBaseCapacity : float, default is Undefined, optional
        Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances. Default: 0.
    onDemandPercentageAboveBaseCapacity : float, default is Undefined, optional
        Percentage split between on-demand and Spot instances above the base on-demand capacity. Default: 100.
    spotAllocationStrategy : str, default is Undefined, optional
        How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized, capacity-optimized-prioritized, and price-capacity-optimized. Default: lowest-price.
    spotInstancePools : float, default is Undefined, optional
        Number of Spot pools per availability zone to allocate capacity. EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates Spot capacity across the number of Spot pools that you specify. Only available with spot_allocation_strategy set to lowest-price. Otherwise it must be set to 0, if it has been defined before. Default: 2.
    spotMaxPrice : str, default is Undefined, optional
        Maximum price per unit hour that the user is willing to pay for the Spot instances. Default: an empty string which means the on-demand price.
    """


    onDemandAllocationStrategy?: str

    onDemandBaseCapacity?: float

    onDemandPercentageAboveBaseCapacity?: float

    spotAllocationStrategy?: str

    spotInstancePools?: float

    spotMaxPrice?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyLaunchTemplate:
    r"""
    Nested argument containing launch template settings along with the overrides to specify multiple instance types and weights. Defined below.

    Attributes
    ----------
    launchTemplateSpecification : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateLaunchTemplateSpecification, default is Undefined, optional
        launch template specification
    override : [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverride], default is Undefined, optional
        List of nested arguments provides the ability to specify multiple instance types. This will override the same parameter in the launch template. For on-demand instances, Auto Scaling considers the order of preference of instance types to launch based on the order specified in the overrides list. Defined below.
    """


    launchTemplateSpecification?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateLaunchTemplateSpecification

    override?: [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverride]




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyLaunchTemplateOverrideInstanceRequirements:
    r"""
    Override the instance type in the Launch Template with instance types that satisfy the requirements.

    Attributes
    ----------
    acceleratorCount : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsAcceleratorCount, default is Undefined, optional
        accelerator count
    acceleratorManufacturers : [str], default is Undefined, optional
        List of accelerator manufacturer names. Default is any manufacturer.
    acceleratorNames : [str], default is Undefined, optional
        List of accelerator names. Default is any acclerator.
    acceleratorTotalMemoryMib : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsAcceleratorTotalMemoryMib, default is Undefined, optional
        accelerator total memory mib
    acceleratorTypes : [str], default is Undefined, optional
        List of accelerator types. Default is any accelerator type.
    allowedInstanceTypes : [str], default is Undefined, optional
        List of instance types to apply your specified attributes against. All other instance types are ignored, even if they match your specified attributes. You can use strings with one or more wild cards, represented by an asterisk (*), to allow an instance type, size, or generation. The following are examples: m5.8xlarge, c5*.*, m5a.*, r*, *3*. For example, if you specify c5*, you are allowing the entire C5 instance family, which includes all C5a and C5n instance types. If you specify m5a.*, you are allowing all the M5a instance types, but not the M5n instance types. Maximum of 400 entries in the list; each entry is limited to 30 characters. Default is all instance types.
    bareMetal : str, default is Undefined, optional
        Indicate whether bare metal instace types should be included, excluded, or required. Default is excluded.
    baselineEbsBandwidthMbps : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsBaselineEbsBandwidthMbps, default is Undefined, optional
        baseline ebs bandwidth mbps
    burstablePerformance : str, default is Undefined, optional
        Indicate whether burstable performance instance types should be included, excluded, or required. Default is excluded.
    cpuManufacturers : [str], default is Undefined, optional
        List of CPU manufacturer names. Default is any manufacturer.
    excludedInstanceTypes : [str], default is Undefined, optional
        List of instance types to exclude. You can use strings with one or more wild cards, represented by an asterisk (*), to exclude an instance type, size, or generation. The following are examples: m5.8xlarge, c5*.*, m5a.*, r*, *3*. For example, if you specify c5*, you are excluding the entire C5 instance family, which includes all C5a and C5n instance types. If you specify m5a.*, you are excluding all the M5a instance types, but not the M5n instance types. Maximum of 400 entries in the list; each entry is limited to 30 characters. Default is no excluded instance types.
    instanceGenerations : [str], default is Undefined, optional
        List of instance generation names. Default is any generation.
    localStorage : str, default is Undefined, optional
        Indicate whether instance types with local storage volumes are included, excluded, or required. Default is included.
    localStorageTypes : [str], default is Undefined, optional
        List of local storage type names. Default any storage type.
    maxSpotPriceAsPercentageOfOptimalOnDemandPrice : float, default is Undefined, optional
        The price protection threshold for Spot Instances. This is the maximum you’ll pay for a Spot Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Conflicts with spot_max_price_percentage_over_lowest_price
    memoryGibPerVcpu : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsMemoryGibPerVcpu, default is Undefined, optional
        memory gib per vcpu
    memoryMib : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsMemoryMib, default is Undefined, optional
        memory mib
    networkBandwidthGbps : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsNetworkBandwidthGbps, default is Undefined, optional
        network bandwidth gbps
    networkInterfaceCount : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsNetworkInterfaceCount, default is Undefined, optional
        network interface count
    onDemandMaxPricePercentageOverLowestPrice : float, default is Undefined, optional
        Price protection threshold for On-Demand Instances. This is the maximum you’ll pay for an On-Demand Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Default is 20.
    requireHibernateSupport : bool, default is Undefined, optional
        Indicate whether instance types must support On-Demand Instance Hibernation, either true or false. Default is false.
    spotMaxPricePercentageOverLowestPrice : float, default is Undefined, optional
        Price protection threshold for Spot Instances. This is the maximum you’ll pay for a Spot Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Default is 100. Conflicts with max_spot_price_as_percentage_of_optimal_on_demand_price
    totalLocalStorageGb : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsTotalLocalStorageGb, default is Undefined, optional
        total local storage gb
    vcpuCount : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsVcpuCount, default is Undefined, optional
        vcpu count
    """


    acceleratorCount?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsAcceleratorCount

    acceleratorManufacturers?: [str]

    acceleratorNames?: [str]

    acceleratorTotalMemoryMib?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsAcceleratorTotalMemoryMib

    acceleratorTypes?: [str]

    allowedInstanceTypes?: [str]

    bareMetal?: str

    baselineEbsBandwidthMbps?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsBaselineEbsBandwidthMbps

    burstablePerformance?: str

    cpuManufacturers?: [str]

    excludedInstanceTypes?: [str]

    instanceGenerations?: [str]

    localStorage?: str

    localStorageTypes?: [str]

    maxSpotPriceAsPercentageOfOptimalOnDemandPrice?: float

    memoryGibPerVcpu?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsMemoryGibPerVcpu

    memoryMib?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsMemoryMib

    networkBandwidthGbps?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsNetworkBandwidthGbps

    networkInterfaceCount?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsNetworkInterfaceCount

    onDemandMaxPricePercentageOverLowestPrice?: float

    requireHibernateSupport?: bool

    spotMaxPricePercentageOverLowestPrice?: float

    totalLocalStorageGb?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsTotalLocalStorageGb

    vcpuCount?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateOverrideInstanceRequirementsVcpuCount




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicyLaunchTemplateOverrideLaunchTemplateSpecification:
    r"""
    Nested argument defines the Launch Template. Defined below.

    Attributes
    ----------
    launchTemplateId : str, default is Undefined, optional
        ID of the launch template. Conflicts with launch_template_name.
    launchTemplateName : str, default is Undefined, optional
        Name of the launch template. Conflicts with launch_template_id.
    version : str, default is Undefined, optional
        Template version. Can be version number, $Latest, or $Default. (Default: $Default).
    """


    launchTemplateId?: str

    launchTemplateName?: str

    version?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideInstanceRequirements:
    r"""
    Override the instance type in the Launch Template with instance types that satisfy the requirements.

    Attributes
    ----------
    acceleratorCount : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsAcceleratorCount, default is Undefined, optional
        accelerator count
    acceleratorManufacturers : [str], default is Undefined, optional
        List of accelerator manufacturer names. Default is any manufacturer.
    acceleratorNames : [str], default is Undefined, optional
        List of accelerator names. Default is any acclerator.
    acceleratorTotalMemoryMib : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsAcceleratorTotalMemoryMib, default is Undefined, optional
        accelerator total memory mib
    acceleratorTypes : [str], default is Undefined, optional
        List of accelerator types. Default is any accelerator type.
    allowedInstanceTypes : [str], default is Undefined, optional
        List of instance types to apply your specified attributes against. All other instance types are ignored, even if they match your specified attributes. You can use strings with one or more wild cards, represented by an asterisk (*), to allow an instance type, size, or generation. The following are examples: m5.8xlarge, c5*.*, m5a.*, r*, *3*. For example, if you specify c5*, you are allowing the entire C5 instance family, which includes all C5a and C5n instance types. If you specify m5a.*, you are allowing all the M5a instance types, but not the M5n instance types. Maximum of 400 entries in the list; each entry is limited to 30 characters. Default is all instance types.
    bareMetal : str, default is Undefined, optional
        Indicate whether bare metal instace types should be included, excluded, or required. Default is excluded.
    baselineEbsBandwidthMbps : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsBaselineEbsBandwidthMbps, default is Undefined, optional
        baseline ebs bandwidth mbps
    burstablePerformance : str, default is Undefined, optional
        Indicate whether burstable performance instance types should be included, excluded, or required. Default is excluded.
    cpuManufacturers : [str], default is Undefined, optional
        List of CPU manufacturer names. Default is any manufacturer.
    excludedInstanceTypes : [str], default is Undefined, optional
        List of instance types to exclude. You can use strings with one or more wild cards, represented by an asterisk (*), to exclude an instance type, size, or generation. The following are examples: m5.8xlarge, c5*.*, m5a.*, r*, *3*. For example, if you specify c5*, you are excluding the entire C5 instance family, which includes all C5a and C5n instance types. If you specify m5a.*, you are excluding all the M5a instance types, but not the M5n instance types. Maximum of 400 entries in the list; each entry is limited to 30 characters. Default is no excluded instance types.
    instanceGenerations : [str], default is Undefined, optional
        List of instance generation names. Default is any generation.
    localStorage : str, default is Undefined, optional
        Indicate whether instance types with local storage volumes are included, excluded, or required. Default is included.
    localStorageTypes : [str], default is Undefined, optional
        List of local storage type names. Default any storage type.
    maxSpotPriceAsPercentageOfOptimalOnDemandPrice : float, default is Undefined, optional
        The price protection threshold for Spot Instances. This is the maximum you’ll pay for a Spot Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Conflicts with spot_max_price_percentage_over_lowest_price
    memoryGibPerVcpu : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsMemoryGibPerVcpu, default is Undefined, optional
        memory gib per vcpu
    memoryMib : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsMemoryMib, default is Undefined, optional
        memory mib
    networkBandwidthGbps : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsNetworkBandwidthGbps, default is Undefined, optional
        network bandwidth gbps
    networkInterfaceCount : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsNetworkInterfaceCount, default is Undefined, optional
        network interface count
    onDemandMaxPricePercentageOverLowestPrice : float, default is Undefined, optional
        Price protection threshold for On-Demand Instances. This is the maximum you’ll pay for an On-Demand Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Default is 20.
    requireHibernateSupport : bool, default is Undefined, optional
        Indicate whether instance types must support On-Demand Instance Hibernation, either true or false. Default is false.
    spotMaxPricePercentageOverLowestPrice : float, default is Undefined, optional
        Price protection threshold for Spot Instances. This is the maximum you’ll pay for a Spot Instance, expressed as a percentage higher than the cheapest M, C, or R instance type with your specified attributes. When Amazon EC2 Auto Scaling selects instance types with your attributes, we will exclude instance types whose price is higher than your threshold. The parameter accepts an integer, which Amazon EC2 Auto Scaling interprets as a percentage. To turn off price protection, specify a high value, such as 999999. Default is 100. Conflicts with max_spot_price_as_percentage_of_optimal_on_demand_price
    totalLocalStorageGb : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsTotalLocalStorageGb, default is Undefined, optional
        total local storage gb
    vcpuCount : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsVcpuCount, default is Undefined, optional
        vcpu count
    """


    acceleratorCount?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsAcceleratorCount

    acceleratorManufacturers?: [str]

    acceleratorNames?: [str]

    acceleratorTotalMemoryMib?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsAcceleratorTotalMemoryMib

    acceleratorTypes?: [str]

    allowedInstanceTypes?: [str]

    bareMetal?: str

    baselineEbsBandwidthMbps?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsBaselineEbsBandwidthMbps

    burstablePerformance?: str

    cpuManufacturers?: [str]

    excludedInstanceTypes?: [str]

    instanceGenerations?: [str]

    localStorage?: str

    localStorageTypes?: [str]

    maxSpotPriceAsPercentageOfOptimalOnDemandPrice?: float

    memoryGibPerVcpu?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsMemoryGibPerVcpu

    memoryMib?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsMemoryMib

    networkBandwidthGbps?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsNetworkBandwidthGbps

    networkInterfaceCount?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsNetworkInterfaceCount

    onDemandMaxPricePercentageOverLowestPrice?: float

    requireHibernateSupport?: bool

    spotMaxPricePercentageOverLowestPrice?: float

    totalLocalStorageGb?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsTotalLocalStorageGb

    vcpuCount?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRequirementsVcpuCount




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideLaunchTemplateSpecification:
    r"""
    Nested argument defines the Launch Template. Defined below.

    Attributes
    ----------
    launchTemplateId : str, default is Undefined, optional
        ID of the launch template. Conflicts with launch_template_name.
    launchTemplateIdRef : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideLaunchTemplateSpecificationLaunchTemplateIDRef, default is Undefined, optional
        launch template Id ref
    launchTemplateIdSelector : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideLaunchTemplateSpecificationLaunchTemplateIDSelector, default is Undefined, optional
        launch template Id selector
    launchTemplateName : str, default is Undefined, optional
        Name of the launch template. Conflicts with launch_template_id.
    version : str, default is Undefined, optional
        Template version. Can be version number, $Latest, or $Default. (Default: $Default).
    """


    launchTemplateId?: str

    launchTemplateIdRef?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideLaunchTemplateSpecificationLaunchTemplateIDRef

    launchTemplateIdSelector?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideLaunchTemplateSpecificationLaunchTemplateIDSelector

    launchTemplateName?: str

    version?: str




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideLaunchTemplateSpecificationLaunchTemplateIDRef:
    r"""
    Reference to a LaunchTemplate in ec2 to populate launchTemplateId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDRefPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderOverrideLaunchTemplateSpecificationLaunchTemplateIDSelector:
    r"""
    Selector for a LaunchTemplate in ec2 to populate launchTemplateId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplateSpecificationLaunchTemplateIDSelectorPolicy




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPreferencesAlarmSpecification:
    r"""
    Alarm Specification for Instance Refresh.

    Attributes
    ----------
    alarms : [str], default is Undefined, optional
        List of Cloudwatch alarms. If any of these alarms goes into ALARM state, Instance Refresh is failed.
    """


    alarms?: [str]




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProvider:
    r"""
    autoscaling group v1beta1 spec for provider

    Attributes
    ----------
    availabilityZoneDistribution : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderAvailabilityZoneDistribution, default is Undefined, optional
        availability zone distribution
    availabilityZones : [str], default is Undefined, optional
        A list of Availability Zones where instances in the Auto Scaling group can be created. Used for launching into the default VPC subnet in each Availability Zone when not using the vpc_zone_identifier attribute, or for attaching a network interface when an existing network interface ID is specified in a launch template. Conflicts with vpc_zone_identifier.
    capacityRebalance : bool, default is Undefined, optional
        Whether capacity rebalance is enabled. Otherwise, capacity rebalance is disabled.
    capacityReservationSpecification : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderCapacityReservationSpecification, default is Undefined, optional
        capacity reservation specification
    context : str, default is Undefined, optional
        Reserved.
    defaultCooldown : float, default is Undefined, optional
        Amount of time, in seconds, after a scaling activity completes before another scaling activity can start.
    defaultInstanceWarmup : float, default is Undefined, optional
        Amount of time, in seconds, until a newly launched instance can contribute to the Amazon CloudWatch metrics. This delay lets an instance finish initializing before Amazon EC2 Auto Scaling aggregates instance metrics, resulting in more reliable usage data. Set this value equal to the amount of time that it takes for resource consumption to become stable after an instance reaches the InService state. (See Set the default instance warmup for an Auto Scaling group)
    desiredCapacity : float, default is Undefined, optional
        Number of Amazon EC2 instances that
        should be running in the group. (See also Waiting for
        Capacity below.)
    desiredCapacityType : str, default is Undefined, optional
        The unit of measurement for the value specified for desired_capacity. Supported for attribute-based instance type selection only. Valid values: "units", "vcpu", "memory-mib".
    enabledMetrics : [str], default is Undefined, optional
        List of metrics to collect. The allowed values are defined by the underlying AWS API.
    forceDelete : bool, default is Undefined, optional
        Allows deleting the Auto Scaling Group without waiting
        for all instances in the pool to terminate. You can force an Auto Scaling Group to delete
        even if it's in the process of scaling a resource. This bypasses that
        behavior and potentially leaves resources dangling.
    forceDeleteWarmPool : bool, default is Undefined, optional
        Allows deleting the Auto Scaling Group without waiting for all instances in the warm pool to terminate.
    healthCheckGracePeriod : float, default is Undefined, optional
        Time (in seconds) after instance comes into service before checking health.
    healthCheckType : str, default is Undefined, optional
        "EC2" or "ELB". Controls how health checking is done.
    ignoreFailedScalingActivities : bool, default is Undefined, optional
        Whether to ignore failed Auto Scaling scaling activities while waiting for capacity. The default is false -- failed scaling activities cause errors to be returned.
    initialLifecycleHook : [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInitialLifecycleHook], default is Undefined, optional
        One or more
        Lifecycle Hooks
        to attach to the Auto Scaling Group before instances are launched. The
        syntax is exactly the same as the separate
        aws_autoscaling_lifecycle_hook
        resource, without the autoscaling_group_name attribute. Please note that this will only work when creating
        a new Auto Scaling Group. For all other use-cases, please use aws_autoscaling_lifecycle_hook resource.
    instanceLifecyclePolicy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceLifecyclePolicy, default is Undefined, optional
        instance lifecycle policy
    instanceMaintenancePolicy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceMaintenancePolicy, default is Undefined, optional
        instance maintenance policy
    instanceRefresh : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRefresh, default is Undefined, optional
        instance refresh
    launchConfiguration : str, default is Undefined, optional
        Name of the launch configuration to use.
    launchConfigurationRef : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationRef, default is Undefined, optional
        launch configuration ref
    launchConfigurationSelector : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationSelector, default is Undefined, optional
        launch configuration selector
    launchTemplate : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplate, default is Undefined, optional
        launch template
    maxInstanceLifetime : float, default is Undefined, optional
        Maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 86400 and 31536000 seconds.
    maxSize : float, default is Undefined, optional
        Maximum size of the Auto Scaling Group.
    metricsGranularity : str, default is Undefined, optional
        Granularity to associate with the metrics to collect. The only valid value is 1Minute. Default is 1Minute.
    minElbCapacity : float, default is Undefined, optional
        Updates will not wait on ELB instance number changes.
        (See also Waiting for Capacity below.)
    minSize : float, default is Undefined, optional
        Minimum size of the Auto Scaling Group.
        (See also Waiting for Capacity below.)
    mixedInstancesPolicy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicy, default is Undefined, optional
        mixed instances policy
    placementGroup : str, default is Undefined, optional
        Name of the placement group into which you'll launch your instances, if any.
    placementGroupRef : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupRef, default is Undefined, optional
        placement group ref
    placementGroupSelector : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupSelector, default is Undefined, optional
        placement group selector
    protectFromScaleIn : bool, default is Undefined, optional
        Whether newly launched instances
        are automatically protected from termination by Amazon EC2 Auto Scaling when
        scaling in. For more information about preventing instances from terminating
        on scale in, see Using instance scale-in protection
        in the Amazon EC2 Auto Scaling User Guide.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    serviceLinkedRoleArn : str, default is Undefined, optional
        ARN of the service-linked role that the ASG will use to call other AWS services
    serviceLinkedRoleArnRef : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnRef, default is Undefined, optional
        service linked role arn ref
    serviceLinkedRoleArnSelector : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnSelector, default is Undefined, optional
        service linked role arn selector
    suspendedProcesses : [str], default is Undefined, optional
        List of processes to suspend for the Auto Scaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer, InstanceRefresh.
        Note that if you suspend either the Launch or Terminate process types, it can prevent your Auto Scaling Group from functioning properly.
    tag : [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderTag], default is Undefined, optional
        Configuration block(s) containing resource tags. See tag Block below for more details.
    terminationPolicies : [str], default is Undefined, optional
        List of policies to decide how the instances in the Auto Scaling Group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, OldestLaunchTemplate, AllocationStrategy, Default. Additionally, the ARN of a Lambda function can be specified for custom termination policies.
    trafficSource : [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderTrafficSource], default is Undefined, optional
        Attaches one or more traffic sources to the specified Auto Scaling group.
    vpcZoneIdentifier : [str], default is Undefined, optional
        List of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with availability_zones.
    vpcZoneIdentifierRefs : [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierRefs], default is Undefined, optional
        References to Subnet in ec2 to populate vpcZoneIdentifier.
    vpcZoneIdentifierSelector : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierSelector, default is Undefined, optional
        vpc zone identifier selector
    waitForCapacityTimeout : str, default is Undefined, optional
        (See also Waiting
        for Capacity below.
    waitForElbCapacity : float, default is Undefined, optional
        (Takes
        precedence over min_elb_capacity behavior.)
        (See also Waiting for Capacity below.)
    warmPool : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderWarmPool, default is Undefined, optional
        warm pool
    """


    availabilityZoneDistribution?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderAvailabilityZoneDistribution

    availabilityZones?: [str]

    capacityRebalance?: bool

    capacityReservationSpecification?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderCapacityReservationSpecification

    context?: str

    defaultCooldown?: float

    defaultInstanceWarmup?: float

    desiredCapacity?: float

    desiredCapacityType?: str

    enabledMetrics?: [str]

    forceDelete?: bool

    forceDeleteWarmPool?: bool

    healthCheckGracePeriod?: float

    healthCheckType?: str

    ignoreFailedScalingActivities?: bool

    initialLifecycleHook?: [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInitialLifecycleHook]

    instanceLifecyclePolicy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceLifecyclePolicy

    instanceMaintenancePolicy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceMaintenancePolicy

    instanceRefresh?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderInstanceRefresh

    launchConfiguration?: str

    launchConfigurationRef?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationRef

    launchConfigurationSelector?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchConfigurationSelector

    launchTemplate?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderLaunchTemplate

    maxInstanceLifetime?: float

    maxSize?: float

    metricsGranularity?: str

    minElbCapacity?: float

    minSize?: float

    mixedInstancesPolicy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderMixedInstancesPolicy

    placementGroup?: str

    placementGroupRef?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupRef

    placementGroupSelector?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderPlacementGroupSelector

    protectFromScaleIn?: bool

    region: str

    serviceLinkedRoleArn?: str

    serviceLinkedRoleArnRef?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnRef

    serviceLinkedRoleArnSelector?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderServiceLinkedRoleArnSelector

    suspendedProcesses?: [str]

    tag?: [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderTag]

    terminationPolicies?: [str]

    trafficSource?: [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderTrafficSource]

    vpcZoneIdentifier?: [str]

    vpcZoneIdentifierRefs?: [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierRefs]

    vpcZoneIdentifierSelector?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierSelector

    waitForCapacityTimeout?: str

    waitForElbCapacity?: float

    warmPool?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderWarmPool




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupStatusAtProvider:
    r"""
    autoscaling group v1beta1 status at provider

    Attributes
    ----------
    arn : str, default is Undefined, optional
        ARN for this Auto Scaling Group
    availabilityZoneDistribution : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderAvailabilityZoneDistribution, default is Undefined, optional
        availability zone distribution
    availabilityZones : [str], default is Undefined, optional
        A list of Availability Zones where instances in the Auto Scaling group can be created. Used for launching into the default VPC subnet in each Availability Zone when not using the vpc_zone_identifier attribute, or for attaching a network interface when an existing network interface ID is specified in a launch template. Conflicts with vpc_zone_identifier.
    capacityRebalance : bool, default is Undefined, optional
        Whether capacity rebalance is enabled. Otherwise, capacity rebalance is disabled.
    capacityReservationSpecification : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderCapacityReservationSpecification, default is Undefined, optional
        capacity reservation specification
    context : str, default is Undefined, optional
        Reserved.
    defaultCooldown : float, default is Undefined, optional
        Amount of time, in seconds, after a scaling activity completes before another scaling activity can start.
    defaultInstanceWarmup : float, default is Undefined, optional
        Amount of time, in seconds, until a newly launched instance can contribute to the Amazon CloudWatch metrics. This delay lets an instance finish initializing before Amazon EC2 Auto Scaling aggregates instance metrics, resulting in more reliable usage data. Set this value equal to the amount of time that it takes for resource consumption to become stable after an instance reaches the InService state. (See Set the default instance warmup for an Auto Scaling group)
    desiredCapacity : float, default is Undefined, optional
        Number of Amazon EC2 instances that
        should be running in the group. (See also Waiting for
        Capacity below.)
    desiredCapacityType : str, default is Undefined, optional
        The unit of measurement for the value specified for desired_capacity. Supported for attribute-based instance type selection only. Valid values: "units", "vcpu", "memory-mib".
    enabledMetrics : [str], default is Undefined, optional
        List of metrics to collect. The allowed values are defined by the underlying AWS API.
    forceDelete : bool, default is Undefined, optional
        Allows deleting the Auto Scaling Group without waiting
        for all instances in the pool to terminate. You can force an Auto Scaling Group to delete
        even if it's in the process of scaling a resource. This bypasses that
        behavior and potentially leaves resources dangling.
    forceDeleteWarmPool : bool, default is Undefined, optional
        Allows deleting the Auto Scaling Group without waiting for all instances in the warm pool to terminate.
    healthCheckGracePeriod : float, default is Undefined, optional
        Time (in seconds) after instance comes into service before checking health.
    healthCheckType : str, default is Undefined, optional
        "EC2" or "ELB". Controls how health checking is done.
    id : str, default is Undefined, optional
        Auto Scaling Group id.
    ignoreFailedScalingActivities : bool, default is Undefined, optional
        Whether to ignore failed Auto Scaling scaling activities while waiting for capacity. The default is false -- failed scaling activities cause errors to be returned.
    initialLifecycleHook : [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInitialLifecycleHook], default is Undefined, optional
        One or more
        Lifecycle Hooks
        to attach to the Auto Scaling Group before instances are launched. The
        syntax is exactly the same as the separate
        aws_autoscaling_lifecycle_hook
        resource, without the autoscaling_group_name attribute. Please note that this will only work when creating
        a new Auto Scaling Group. For all other use-cases, please use aws_autoscaling_lifecycle_hook resource.
    instanceLifecyclePolicy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceLifecyclePolicy, default is Undefined, optional
        instance lifecycle policy
    instanceMaintenancePolicy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceMaintenancePolicy, default is Undefined, optional
        instance maintenance policy
    instanceRefresh : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceRefresh, default is Undefined, optional
        instance refresh
    launchConfiguration : str, default is Undefined, optional
        Name of the launch configuration to use.
    launchTemplate : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderLaunchTemplate, default is Undefined, optional
        launch template
    loadBalancers : [str], default is Undefined, optional
        List of elastic load balancer names to add to the autoscaling
        group names. Only valid for classic load balancers. For ALBs, use target_group_arns instead. To remove all load balancer attachments an empty list should be specified.
    maxInstanceLifetime : float, default is Undefined, optional
        Maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 86400 and 31536000 seconds.
    maxSize : float, default is Undefined, optional
        Maximum size of the Auto Scaling Group.
    metricsGranularity : str, default is Undefined, optional
        Granularity to associate with the metrics to collect. The only valid value is 1Minute. Default is 1Minute.
    minElbCapacity : float, default is Undefined, optional
        Updates will not wait on ELB instance number changes.
        (See also Waiting for Capacity below.)
    minSize : float, default is Undefined, optional
        Minimum size of the Auto Scaling Group.
        (See also Waiting for Capacity below.)
    mixedInstancesPolicy : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicy, default is Undefined, optional
        mixed instances policy
    placementGroup : str, default is Undefined, optional
        Name of the placement group into which you'll launch your instances, if any.
    predictedCapacity : float, default is Undefined, optional
        Predicted capacity of the group.
    protectFromScaleIn : bool, default is Undefined, optional
        Whether newly launched instances
        are automatically protected from termination by Amazon EC2 Auto Scaling when
        scaling in. For more information about preventing instances from terminating
        on scale in, see Using instance scale-in protection
        in the Amazon EC2 Auto Scaling User Guide.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    serviceLinkedRoleArn : str, default is Undefined, optional
        ARN of the service-linked role that the ASG will use to call other AWS services
    suspendedProcesses : [str], default is Undefined, optional
        List of processes to suspend for the Auto Scaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer, InstanceRefresh.
        Note that if you suspend either the Launch or Terminate process types, it can prevent your Auto Scaling Group from functioning properly.
    tag : [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderTag], default is Undefined, optional
        Configuration block(s) containing resource tags. See tag Block below for more details.
    targetGroupArns : [str], default is Undefined, optional
        Set of aws_lb_target_group ARNs, for use with Application or Network Load Balancing. To remove all target group attachments an empty list should be specified.
    terminationPolicies : [str], default is Undefined, optional
        List of policies to decide how the instances in the Auto Scaling Group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, OldestLaunchTemplate, AllocationStrategy, Default. Additionally, the ARN of a Lambda function can be specified for custom termination policies.
    trafficSource : [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderTrafficSource], default is Undefined, optional
        Attaches one or more traffic sources to the specified Auto Scaling group.
    vpcZoneIdentifier : [str], default is Undefined, optional
        List of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with availability_zones.
    waitForCapacityTimeout : str, default is Undefined, optional
        (See also Waiting
        for Capacity below.
    waitForElbCapacity : float, default is Undefined, optional
        (Takes
        precedence over min_elb_capacity behavior.)
        (See also Waiting for Capacity below.)
    warmPool : AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderWarmPool, default is Undefined, optional
        warm pool
    warmPoolSize : float, default is Undefined, optional
        Current size of the warm pool.
    """


    arn?: str

    availabilityZoneDistribution?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderAvailabilityZoneDistribution

    availabilityZones?: [str]

    capacityRebalance?: bool

    capacityReservationSpecification?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderCapacityReservationSpecification

    context?: str

    defaultCooldown?: float

    defaultInstanceWarmup?: float

    desiredCapacity?: float

    desiredCapacityType?: str

    enabledMetrics?: [str]

    forceDelete?: bool

    forceDeleteWarmPool?: bool

    healthCheckGracePeriod?: float

    healthCheckType?: str

    id?: str

    ignoreFailedScalingActivities?: bool

    initialLifecycleHook?: [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInitialLifecycleHook]

    instanceLifecyclePolicy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceLifecyclePolicy

    instanceMaintenancePolicy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceMaintenancePolicy

    instanceRefresh?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderInstanceRefresh

    launchConfiguration?: str

    launchTemplate?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderLaunchTemplate

    loadBalancers?: [str]

    maxInstanceLifetime?: float

    maxSize?: float

    metricsGranularity?: str

    minElbCapacity?: float

    minSize?: float

    mixedInstancesPolicy?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderMixedInstancesPolicy

    placementGroup?: str

    predictedCapacity?: float

    protectFromScaleIn?: bool

    region?: str

    serviceLinkedRoleArn?: str

    suspendedProcesses?: [str]

    tag?: [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderTag]

    targetGroupArns?: [str]

    terminationPolicies?: [str]

    trafficSource?: [AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderTrafficSource]

    vpcZoneIdentifier?: [str]

    waitForCapacityTimeout?: str

    waitForElbCapacity?: float

    warmPool?: AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupAtProviderWarmPool

    warmPoolSize?: float




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierRefsPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderVpcZoneIdentifierSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1AutoscalingGroupSpecForProviderWarmPoolInstanceReusePolicy:
    r"""
    Whether instances in the Auto Scaling group can be returned to the warm pool on scale in. The default is to terminate instances in the Auto Scaling group when the group scales in.

    Attributes
    ----------
    reuseOnScaleIn : bool, default is Undefined, optional
        Whether instances in the Auto Scaling group can be returned to the warm pool on scale in.
    """


    reuseOnScaleIn?: bool

schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderAccessLogsBucketRef:
    r"""
    Reference to a Bucket in s3 to populate bucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderBucketRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderBucketRefPolicy




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderAccessLogsBucketSelector:
    r"""
    Selector for a Bucket in s3 to populate bucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderBucketSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderBucketSelectorPolicy




schema Elbv2AwsmUpboundIoV1beta1LBAtProviderAccessLogs:
    r"""
    Access Logs block. See below.

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        S3 bucket name to store the logs in.
    enabled : bool, default is Undefined, optional
        Boolean to enable / disable access_logs. Defaults to false, even when bucket is specified.
    prefix : str, default is Undefined, optional
        S3 bucket prefix. Logs are stored in the root if not configured.
    """


    bucket?: str

    enabled?: bool

    prefix?: str




schema Elbv2AwsmUpboundIoV1beta1LBAtProviderConnectionLogs:
    r"""
    Connection Logs block. See below. Only valid for Load Balancers of type application.

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        S3 bucket name to store the logs in.
    enabled : bool, default is Undefined, optional
        Boolean to enable / disable connection_logs. Defaults to false, even when bucket is specified.
    prefix : str, default is Undefined, optional
        S3 bucket prefix. Logs are stored in the root if not configured.
    """


    bucket?: str

    enabled?: bool

    prefix?: str




schema Elbv2AwsmUpboundIoV1beta1LBAtProviderHealthCheckLogs:
    r"""
    Health Check Logs block. See below. Only valid for Load Balancers of type application.

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        S3 bucket name to store the logs in.
    enabled : bool, default is Undefined, optional
        Boolean to enable / disable health_check_logs. Defaults to false, even when bucket is specified.
    prefix : str, default is Undefined, optional
        S3 bucket prefix. Logs are stored in the root if not configured.
    """


    bucket?: str

    enabled?: bool

    prefix?: str




schema Elbv2AwsmUpboundIoV1beta1LBAtProviderIpamPools:
    r"""
    . The IPAM pools to use with the load balancer.  Only valid for Load Balancers of type application. See ipam_pools for more information.

    Attributes
    ----------
    ipv4IpamPoolId : str, default is Undefined, optional
        The ID of the IPv4 IPAM pool.
    """


    ipv4IpamPoolId?: str




schema Elbv2AwsmUpboundIoV1beta1LBAtProviderMinimumLoadBalancerCapacity:
    r"""
    Minimum capacity for a load balancer. Only valid for Load Balancers of type application or network.

    Attributes
    ----------
    capacityUnits : float, default is Undefined, optional
        The number of capacity units.
    """


    capacityUnits?: float




schema Elbv2AwsmUpboundIoV1beta1LBAtProviderSubnetMapping:
    r"""
    l b v1beta1 at provider subnet mapping

    Attributes
    ----------
    allocationId : str, default is Undefined, optional
        Allocation ID of the Elastic IP address for an internet-facing load balancer.
    ipv6Address : str, default is Undefined, optional
        IPv6 address. You associate IPv6 CIDR blocks with your VPC and choose the subnets where you launch both internet-facing and internal Application Load Balancers or Network Load Balancers.
    outpostId : str, default is Undefined, optional
        ID of the Outpost containing the load balancer.
    privateIpv4Address : str, default is Undefined, optional
        Private IPv4 address for an internal load balancer.
    subnetId : str, default is Undefined, optional
        ID of the subnet of which to attach to the load balancer. You can specify only one subnet per Availability Zone.
    """


    allocationId?: str

    ipv6Address?: str

    outpostId?: str

    privateIpv4Address?: str

    subnetId?: str




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderBucketRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderBucketSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderAccessLogs:
    r"""
    Access Logs block. See below.

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        S3 bucket name to store the logs in.
    bucketRef : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderAccessLogsBucketRef, default is Undefined, optional
        bucket ref
    bucketSelector : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderAccessLogsBucketSelector, default is Undefined, optional
        bucket selector
    enabled : bool, default is Undefined, optional
        Boolean to enable / disable access_logs. Defaults to false, even when bucket is specified.
    prefix : str, default is Undefined, optional
        S3 bucket prefix. Logs are stored in the root if not configured.
    """


    bucket?: str

    bucketRef?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderAccessLogsBucketRef

    bucketSelector?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderAccessLogsBucketSelector

    enabled?: bool

    prefix?: str




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderConnectionLogs:
    r"""
    Connection Logs block. See below. Only valid for Load Balancers of type application.

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        S3 bucket name to store the logs in.
    enabled : bool, default is Undefined, optional
        Boolean to enable / disable connection_logs. Defaults to false, even when bucket is specified.
    prefix : str, default is Undefined, optional
        S3 bucket prefix. Logs are stored in the root if not configured.
    """


    bucket?: str

    enabled?: bool

    prefix?: str




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderHealthCheckLogs:
    r"""
    Health Check Logs block. See below. Only valid for Load Balancers of type application.

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        S3 bucket name to store the logs in.
    enabled : bool, default is Undefined, optional
        Boolean to enable / disable health_check_logs. Defaults to false, even when bucket is specified.
    prefix : str, default is Undefined, optional
        S3 bucket prefix. Logs are stored in the root if not configured.
    """


    bucket?: str

    enabled?: bool

    prefix?: str




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderIpamPools:
    r"""
    . The IPAM pools to use with the load balancer.  Only valid for Load Balancers of type application. See ipam_pools for more information.

    Attributes
    ----------
    ipv4IpamPoolId : str, default is Undefined, optional
        The ID of the IPv4 IPAM pool.
    """


    ipv4IpamPoolId?: str




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderMinimumLoadBalancerCapacity:
    r"""
    Minimum capacity for a load balancer. Only valid for Load Balancers of type application or network.

    Attributes
    ----------
    capacityUnits : float, default is Undefined, optional
        The number of capacity units.
    """


    capacityUnits?: float




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupRefs:
    r"""
    A NamespacedReference to a named object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupRefsPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupRefsPolicy




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupSelector:
    r"""
    Selector for a list of SecurityGroup in ec2 to populate securityGroups.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupSelectorPolicy




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetMapping:
    r"""
    l b v1beta1 for provider subnet mapping

    Attributes
    ----------
    allocationId : str, default is Undefined, optional
        Allocation ID of the Elastic IP address for an internet-facing load balancer.
    ipv6Address : str, default is Undefined, optional
        IPv6 address. You associate IPv6 CIDR blocks with your VPC and choose the subnets where you launch both internet-facing and internal Application Load Balancers or Network Load Balancers.
    privateIpv4Address : str, default is Undefined, optional
        Private IPv4 address for an internal load balancer.
    subnetId : str, default is Undefined, optional
        ID of the subnet of which to attach to the load balancer. You can specify only one subnet per Availability Zone.
    subnetIdRef : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetMappingSubnetIDRef, default is Undefined, optional
        subnet Id ref
    subnetIdSelector : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetMappingSubnetIDSelector, default is Undefined, optional
        subnet Id selector
    """


    allocationId?: str

    ipv6Address?: str

    privateIpv4Address?: str

    subnetId?: str

    subnetIdRef?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetMappingSubnetIDRef

    subnetIdSelector?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetMappingSubnetIDSelector




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetRefs:
    r"""
    A NamespacedReference to a named object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetRefsPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetRefsPolicy




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetSelector:
    r"""
    Selector for a list of Subnet in ec2 to populate subnets.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetSelectorPolicy




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupRefsPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProvider:
    r"""
    l b v1beta1 spec for provider

    Attributes
    ----------
    accessLogs : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderAccessLogs, default is Undefined, optional
        access logs
    clientKeepAlive : float, default is Undefined, optional
        Client keep alive value in seconds. The valid range is 60-604800 seconds. The default is 3600 seconds.
    connectionLogs : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderConnectionLogs, default is Undefined, optional
        connection logs
    customerOwnedIpv4Pool : str, default is Undefined, optional
        ID of the customer owned ipv4 pool to use for this load balancer.
    desyncMitigationMode : str, default is Undefined, optional
        How the load balancer handles requests that might pose a security risk to an application due to HTTP desync. Valid values are monitor, defensive (default), strictest.
    dnsRecordClientRoutingPolicy : str, default is Undefined, optional
        How traffic is distributed among the load balancer Availability Zones. Possible values are any_availability_zone (default), availability_zone_affinity, or partial_availability_zone_affinity. See   Availability Zone DNS affinity for additional details. Only valid for network type load balancers.
    dropInvalidHeaderFields : bool, default is Undefined, optional
        Whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false. Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens. Only valid for Load Balancers of type application.
    enableCrossZoneLoadBalancing : bool, default is Undefined, optional
        If true, cross-zone load balancing of the load balancer will be enabled. For network and gateway type load balancers, this feature is disabled by default (false). For application load balancer this feature is always enabled (true) and cannot be disabled. Defaults to false.
    enableDeletionProtection : bool, default is Undefined, optional
        If true, deletion of the load balancer will be disabled via the AWS API. Defaults to false.
    enableHttp2 : bool, default is Undefined, optional
        Whether HTTP/2 is enabled in application load balancers. Defaults to true.
    enablePrefixForIpv6SourceNat : str, default is Undefined, optional
        Whether to use an IPv6 prefix from each subnet for source NAT. ip_address_type must be dualstack. Valid values: on, off.
    enableTlsVersionAndCipherSuiteHeaders : bool, default is Undefined, optional
        Whether the two headers (x-amzn-tls-version and x-amzn-tls-cipher-suite), which contain information about the negotiated TLS version and cipher suite, are added to the client request before sending it to the target. Only valid for Load Balancers of type application. Defaults to false
    enableWafFailOpen : bool, default is Undefined, optional
        Whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF. Defaults to false.
    enableXffClientPort : bool, default is Undefined, optional
        Whether the X-Forwarded-For header should preserve the source port that the client used to connect to the load balancer in application load balancers. Defaults to false.
    enableZonalShift : bool, default is Undefined, optional
        Whether zonal shift is enabled. Defaults to false.
    enforceSecurityGroupInboundRulesOnPrivateLinkTraffic : str, default is Undefined, optional
        Whether inbound security group rules are enforced for traffic originating from a PrivateLink. Only valid for Load Balancers of type network. The possible values are on and off.
    healthCheckLogs : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderHealthCheckLogs, default is Undefined, optional
        health check logs
    idleTimeout : float, default is Undefined, optional
        Time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. Default: 60.
    internal : bool, default is Undefined, optional
        If true, the LB will be internal. Defaults to false.
    ipAddressType : str, default is Undefined, optional
        Type of IP addresses used by the subnets for your load balancer. The possible values depend upon the load balancer type: ipv4 (all load balancer types), dualstack (all load balancer types), and dualstack-without-public-ipv4 (type application only).
    ipamPools : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderIpamPools, default is Undefined, optional
        ipam pools
    loadBalancerType : str, default is Undefined, optional
        Type of load balancer to create. Possible values are application, gateway, or network. The default value is application.
    minimumLoadBalancerCapacity : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderMinimumLoadBalancerCapacity, default is Undefined, optional
        minimum load balancer capacity
    name : str, default is Undefined, optional
        Name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen.
    preserveHostHeader : bool, default is Undefined, optional
        Whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change. Defaults to false.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    secondaryIpsAutoAssignedPerSubnet : float, default is Undefined, optional
        The number of secondary IP addresses to configure for your load balancer nodes. Only valid for Load Balancers of type network. The valid range is 0-7. When decreased, this will force a recreation of the resource. Default: 0.
    securityGroupRefs : [Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupRefs], default is Undefined, optional
        References to SecurityGroup in ec2 to populate securityGroups.
    securityGroupSelector : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupSelector, default is Undefined, optional
        security group selector
    securityGroups : [str], default is Undefined, optional
        List of security group IDs to assign to the LB. Only valid for Load Balancers of type application or network. For load balancers of type network security groups cannot be added if none are currently present, and cannot all be removed once added. If either of these conditions are met, this will force a recreation of the resource.
    subnetMapping : [Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetMapping], default is Undefined, optional
        Subnet mapping block. See below. For Load Balancers of type network subnet mappings can only be added.
    subnetRefs : [Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetRefs], default is Undefined, optional
        References to Subnet in ec2 to populate subnets.
    subnetSelector : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetSelector, default is Undefined, optional
        subnet selector
    subnets : [str], default is Undefined, optional
        List of subnet IDs to attach to the LB. For Load Balancers of type network subnets can only be added (see Availability Zones), deleting a subnet for load balancers of type network will force a recreation of the resource.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    xffHeaderProcessingMode : str, default is Undefined, optional
        Determines how the load balancer modifies the X-Forwarded-For header in the HTTP request before sending the request to the target. The possible values are append, preserve, and remove. Only valid for Load Balancers of type application. The default is append.
    """


    accessLogs?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderAccessLogs

    clientKeepAlive?: float

    connectionLogs?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderConnectionLogs

    customerOwnedIpv4Pool?: str

    desyncMitigationMode?: str

    dnsRecordClientRoutingPolicy?: str

    dropInvalidHeaderFields?: bool

    enableCrossZoneLoadBalancing?: bool

    enableDeletionProtection?: bool

    enableHttp2?: bool

    enablePrefixForIpv6SourceNat?: str

    enableTlsVersionAndCipherSuiteHeaders?: bool

    enableWafFailOpen?: bool

    enableXffClientPort?: bool

    enableZonalShift?: bool

    enforceSecurityGroupInboundRulesOnPrivateLinkTraffic?: str

    healthCheckLogs?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderHealthCheckLogs

    idleTimeout?: float

    internal?: bool

    ipAddressType?: str

    ipamPools?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderIpamPools

    loadBalancerType?: str

    minimumLoadBalancerCapacity?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderMinimumLoadBalancerCapacity

    name?: str

    preserveHostHeader?: bool

    region: str

    secondaryIpsAutoAssignedPerSubnet?: float

    securityGroupRefs?: [Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupRefs]

    securityGroupSelector?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSecurityGroupSelector

    securityGroups?: [str]

    subnetMapping?: [Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetMapping]

    subnetRefs?: [Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetRefs]

    subnetSelector?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetSelector

    subnets?: [str]

    tags?: {str:str}

    xffHeaderProcessingMode?: str




schema Elbv2AwsmUpboundIoV1beta1LBStatusAtProvider:
    r"""
    l b v1beta1 status at provider

    Attributes
    ----------
    accessLogs : Elbv2AwsmUpboundIoV1beta1LBAtProviderAccessLogs, default is Undefined, optional
        access logs
    arn : str, default is Undefined, optional
        ARN of the load balancer.
    arnSuffix : str, default is Undefined, optional
        ARN suffix for use with CloudWatch Metrics.
    clientKeepAlive : float, default is Undefined, optional
        Client keep alive value in seconds. The valid range is 60-604800 seconds. The default is 3600 seconds.
    connectionLogs : Elbv2AwsmUpboundIoV1beta1LBAtProviderConnectionLogs, default is Undefined, optional
        connection logs
    customerOwnedIpv4Pool : str, default is Undefined, optional
        ID of the customer owned ipv4 pool to use for this load balancer.
    desyncMitigationMode : str, default is Undefined, optional
        How the load balancer handles requests that might pose a security risk to an application due to HTTP desync. Valid values are monitor, defensive (default), strictest.
    dnsName : str, default is Undefined, optional
        DNS name of the load balancer.
    dnsRecordClientRoutingPolicy : str, default is Undefined, optional
        How traffic is distributed among the load balancer Availability Zones. Possible values are any_availability_zone (default), availability_zone_affinity, or partial_availability_zone_affinity. See   Availability Zone DNS affinity for additional details. Only valid for network type load balancers.
    dropInvalidHeaderFields : bool, default is Undefined, optional
        Whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false. Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens. Only valid for Load Balancers of type application.
    enableCrossZoneLoadBalancing : bool, default is Undefined, optional
        If true, cross-zone load balancing of the load balancer will be enabled. For network and gateway type load balancers, this feature is disabled by default (false). For application load balancer this feature is always enabled (true) and cannot be disabled. Defaults to false.
    enableDeletionProtection : bool, default is Undefined, optional
        If true, deletion of the load balancer will be disabled via the AWS API. Defaults to false.
    enableHttp2 : bool, default is Undefined, optional
        Whether HTTP/2 is enabled in application load balancers. Defaults to true.
    enablePrefixForIpv6SourceNat : str, default is Undefined, optional
        Whether to use an IPv6 prefix from each subnet for source NAT. ip_address_type must be dualstack. Valid values: on, off.
    enableTlsVersionAndCipherSuiteHeaders : bool, default is Undefined, optional
        Whether the two headers (x-amzn-tls-version and x-amzn-tls-cipher-suite), which contain information about the negotiated TLS version and cipher suite, are added to the client request before sending it to the target. Only valid for Load Balancers of type application. Defaults to false
    enableWafFailOpen : bool, default is Undefined, optional
        Whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF. Defaults to false.
    enableXffClientPort : bool, default is Undefined, optional
        Whether the X-Forwarded-For header should preserve the source port that the client used to connect to the load balancer in application load balancers. Defaults to false.
    enableZonalShift : bool, default is Undefined, optional
        Whether zonal shift is enabled. Defaults to false.
    enforceSecurityGroupInboundRulesOnPrivateLinkTraffic : str, default is Undefined, optional
        Whether inbound security group rules are enforced for traffic originating from a PrivateLink. Only valid for Load Balancers of type network. The possible values are on and off.
    healthCheckLogs : Elbv2AwsmUpboundIoV1beta1LBAtProviderHealthCheckLogs, default is Undefined, optional
        health check logs
    id : str, default is Undefined, optional
        id
    idleTimeout : float, default is Undefined, optional
        Time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. Default: 60.
    internal : bool, default is Undefined, optional
        If true, the LB will be internal. Defaults to false.
    ipAddressType : str, default is Undefined, optional
        Type of IP addresses used by the subnets for your load balancer. The possible values depend upon the load balancer type: ipv4 (all load balancer types), dualstack (all load balancer types), and dualstack-without-public-ipv4 (type application only).
    ipamPools : Elbv2AwsmUpboundIoV1beta1LBAtProviderIpamPools, default is Undefined, optional
        ipam pools
    loadBalancerType : str, default is Undefined, optional
        Type of load balancer to create. Possible values are application, gateway, or network. The default value is application.
    minimumLoadBalancerCapacity : Elbv2AwsmUpboundIoV1beta1LBAtProviderMinimumLoadBalancerCapacity, default is Undefined, optional
        minimum load balancer capacity
    name : str, default is Undefined, optional
        Name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen.
    preserveHostHeader : bool, default is Undefined, optional
        Whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change. Defaults to false.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    secondaryIpsAutoAssignedPerSubnet : float, default is Undefined, optional
        The number of secondary IP addresses to configure for your load balancer nodes. Only valid for Load Balancers of type network. The valid range is 0-7. When decreased, this will force a recreation of the resource. Default: 0.
    securityGroups : [str], default is Undefined, optional
        List of security group IDs to assign to the LB. Only valid for Load Balancers of type application or network. For load balancers of type network security groups cannot be added if none are currently present, and cannot all be removed once added. If either of these conditions are met, this will force a recreation of the resource.
    subnetMapping : [Elbv2AwsmUpboundIoV1beta1LBAtProviderSubnetMapping], default is Undefined, optional
        Subnet mapping block. See below. For Load Balancers of type network subnet mappings can only be added.
    subnets : [str], default is Undefined, optional
        List of subnet IDs to attach to the LB. For Load Balancers of type network subnets can only be added (see Availability Zones), deleting a subnet for load balancers of type network will force a recreation of the resource.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    tagsAll : {str:str}, default is Undefined, optional
        Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block.
    vpcId : str, default is Undefined, optional
        vpc Id
    xffHeaderProcessingMode : str, default is Undefined, optional
        Determines how the load balancer modifies the X-Forwarded-For header in the HTTP request before sending the request to the target. The possible values are append, preserve, and remove. Only valid for Load Balancers of type application. The default is append.
    zoneId : str, default is Undefined, optional
        Canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record).
    """


    accessLogs?: Elbv2AwsmUpboundIoV1beta1LBAtProviderAccessLogs

    arn?: str

    arnSuffix?: str

    clientKeepAlive?: float

    connectionLogs?: Elbv2AwsmUpboundIoV1beta1LBAtProviderConnectionLogs

    customerOwnedIpv4Pool?: str

    desyncMitigationMode?: str

    dnsName?: str

    dnsRecordClientRoutingPolicy?: str

    dropInvalidHeaderFields?: bool

    enableCrossZoneLoadBalancing?: bool

    enableDeletionProtection?: bool

    enableHttp2?: bool

    enablePrefixForIpv6SourceNat?: str

    enableTlsVersionAndCipherSuiteHeaders?: bool

    enableWafFailOpen?: bool

    enableXffClientPort?: bool

    enableZonalShift?: bool

    enforceSecurityGroupInboundRulesOnPrivateLinkTraffic?: str

    healthCheckLogs?: Elbv2AwsmUpboundIoV1beta1LBAtProviderHealthCheckLogs

    id?: str

    idleTimeout?: float

    internal?: bool

    ipAddressType?: str

    ipamPools?: Elbv2AwsmUpboundIoV1beta1LBAtProviderIpamPools

    loadBalancerType?: str

    minimumLoadBalancerCapacity?: Elbv2AwsmUpboundIoV1beta1LBAtProviderMinimumLoadBalancerCapacity

    name?: str

    preserveHostHeader?: bool

    region?: str

    secondaryIpsAutoAssignedPerSubnet?: float

    securityGroups?: [str]

    subnetMapping?: [Elbv2AwsmUpboundIoV1beta1LBAtProviderSubnetMapping]

    subnets?: [str]

    tags?: {str:str}

    tagsAll?: {str:str}

    vpcId?: str

    xffHeaderProcessingMode?: str

    zoneId?: str




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetMappingSubnetIDRef:
    r"""
    Reference to a Subnet in ec2 to populate subnetId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetIDRefPolicy




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetMappingSubnetIDSelector:
    r"""
    Selector for a Subnet in ec2 to populate subnetId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetIDSelectorPolicy




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetRefsPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBSpecForProviderSubnetSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"

schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderHealthCheck:
    r"""
    Health Check configuration block. Detailed below.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Whether health checks are enabled. Defaults to true.
    healthyThreshold : float, default is Undefined, optional
        Number of consecutive health check successes required before considering a target healthy. The range is 2-10. Defaults to 3.
    interval : float, default is Undefined, optional
        Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300. For lambda target groups, it needs to be greater than the timeout of the underlying lambda. Defaults to 30.
    matcher : str, default is Undefined, optional
        separated individual values (e.g., "200,202") or a range of values (e.g., "200-299").
        Once the value has been set, removing it has no effect. To unset it, set it to an empty string "".
    path : str, default is Undefined, optional
        (May be required) Destination for the health check request. Required for HTTP/HTTPS ALB and HTTP NLB. Only applies to HTTP/HTTPS.
        Once the value has been set, removing it has no effect. To unset it, set it to an empty string "".
    port : str, default is Undefined, optional
        The port the load balancer uses when performing health checks on targets.
        Valid values are either traffic-port, to use the same port as the target group, or a valid port number between 1 and 65536.
        Default is traffic-port.
    $protocol : str, default is Undefined, optional
        Protocol the load balancer uses when performing health checks on targets.
        Must be one of TCP, HTTP, or HTTPS.
        The TCP protocol is not supported for health checks if the protocol of the target group is HTTP or HTTPS.
        Default is HTTP.
        Cannot be specified when the target_type is lambda.
    timeout : float, default is Undefined, optional
        Amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–120 seconds. For target groups with a protocol of HTTP, the default is 6 seconds. For target groups with a protocol of TCP, TLS or HTTPS, the default is 10 seconds. For target groups with a protocol of GENEVE, the default is 5 seconds. If the target type is lambda, the default is 30 seconds.
    unhealthyThreshold : float, default is Undefined, optional
        Number of consecutive health check failures required before considering a target unhealthy. The range is 2-10. Defaults to 3.
    """


    enabled?: bool

    healthyThreshold?: float

    interval?: float

    matcher?: str

    path?: str

    port?: str

    $protocol?: str

    timeout?: float

    unhealthyThreshold?: float




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderStickiness:
    r"""
    Stickiness configuration block. Detailed below.

    Attributes
    ----------
    cookieDuration : float, default is Undefined, optional
        Only used when the type is lb_cookie. The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds).
    cookieName : str, default is Undefined, optional
        Name of the application based cookie. AWSALB, AWSALBAPP, and AWSALBTG prefixes are reserved and cannot be used. Only needed when type is app_cookie.
    enabled : bool, default is Undefined, optional
        Whether health checks are enabled. Defaults to true.
    $type : str, default is Undefined, optional
        The type of sticky sessions. The only current possible values are lb_cookie, app_cookie for ALBs, source_ip for NLBs, and source_ip_dest_ip, source_ip_dest_ip_proto for GWLBs.
    """


    cookieDuration?: float

    cookieName?: str

    enabled?: bool

    $type?: str




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetFailover:
    r"""
    l b target group v1beta1 at provider target failover

    Attributes
    ----------
    onDeregistration : str, default is Undefined, optional
        Indicates how the GWLB handles existing flows when a target is deregistered. Possible values are rebalance and no_rebalance. Must match the attribute value set for on_unhealthy. Default: no_rebalance.
    onUnhealthy : str, default is Undefined, optional
        Indicates how the GWLB handles existing flows when a target is unhealthy. Possible values are rebalance and no_rebalance. Must match the attribute value set for on_deregistration. Default: no_rebalance.
    """


    onDeregistration?: str

    onUnhealthy?: str




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetGroupHealth:
    r"""
    Target health requirements block. See target_group_health for more information.

    Attributes
    ----------
    dnsFailover : Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetGroupHealthDNSFailover, default is Undefined, optional
        dns failover
    unhealthyStateRouting : Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetGroupHealthUnhealthyStateRouting, default is Undefined, optional
        unhealthy state routing
    """


    dnsFailover?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetGroupHealthDNSFailover

    unhealthyStateRouting?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetGroupHealthUnhealthyStateRouting




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetGroupHealthDNSFailover:
    r"""
    Block to configure DNS Failover requirements. See DNS Failover below for details on attributes.

    Attributes
    ----------
    minimumHealthyTargetsCount : str, default is Undefined, optional
        The minimum number of targets that must be healthy. If the number of healthy targets is below this value, mark the zone as unhealthy in DNS, so that traffic is routed only to healthy zones. The possible values are off or an integer from 1 to the maximum number of targets. The default is off.
    minimumHealthyTargetsPercentage : str, default is Undefined, optional
        The minimum percentage of targets that must be healthy. If the percentage of healthy targets is below this value, mark the zone as unhealthy in DNS, so that traffic is routed only to healthy zones. The possible values are off or an integer from 1 to 100. The default is off.
    """


    minimumHealthyTargetsCount?: str

    minimumHealthyTargetsPercentage?: str




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetGroupHealthUnhealthyStateRouting:
    r"""
    Block to configure Unhealthy State Routing requirements. See Unhealthy State Routing below for details on attributes.

    Attributes
    ----------
    minimumHealthyTargetsCount : float, default is Undefined, optional
        The minimum number of targets that must be healthy. If the number of healthy targets is below this value, send traffic to all targets, including unhealthy targets. The possible values are 1 to the maximum number of targets. The default is 1.
    minimumHealthyTargetsPercentage : str, default is Undefined, optional
        The minimum percentage of targets that must be healthy. If the percentage of healthy targets is below this value, send traffic to all targets, including unhealthy targets. The possible values are off or an integer from 1 to 100. The default is off.
    """


    minimumHealthyTargetsCount?: float

    minimumHealthyTargetsPercentage?: str




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetHealthState:
    r"""
    l b target group v1beta1 at provider target health state

    Attributes
    ----------
    enableUnhealthyConnectionTermination : bool, default is Undefined, optional
        Indicates whether the load balancer terminates connections to unhealthy targets. Possible values are true or false. Default: true.
    unhealthyDrainingInterval : float, default is Undefined, optional
        Indicates the time to wait for in-flight requests to complete when a target becomes unhealthy. The range is 0-360000. This value has to be set only if enable_unhealthy_connection_termination is set to false. Default: 0.
    """


    enableUnhealthyConnectionTermination?: bool

    unhealthyDrainingInterval?: float




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderHealthCheck:
    r"""
    Health Check configuration block. Detailed below.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Whether health checks are enabled. Defaults to true.
    healthyThreshold : float, default is Undefined, optional
        Number of consecutive health check successes required before considering a target healthy. The range is 2-10. Defaults to 3.
    interval : float, default is Undefined, optional
        Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300. For lambda target groups, it needs to be greater than the timeout of the underlying lambda. Defaults to 30.
    matcher : str, default is Undefined, optional
        separated individual values (e.g., "200,202") or a range of values (e.g., "200-299").
        Once the value has been set, removing it has no effect. To unset it, set it to an empty string "".
    path : str, default is Undefined, optional
        (May be required) Destination for the health check request. Required for HTTP/HTTPS ALB and HTTP NLB. Only applies to HTTP/HTTPS.
        Once the value has been set, removing it has no effect. To unset it, set it to an empty string "".
    port : str, default is Undefined, optional
        The port the load balancer uses when performing health checks on targets.
        Valid values are either traffic-port, to use the same port as the target group, or a valid port number between 1 and 65536.
        Default is traffic-port.
    $protocol : str, default is Undefined, optional
        Protocol the load balancer uses when performing health checks on targets.
        Must be one of TCP, HTTP, or HTTPS.
        The TCP protocol is not supported for health checks if the protocol of the target group is HTTP or HTTPS.
        Default is HTTP.
        Cannot be specified when the target_type is lambda.
    timeout : float, default is Undefined, optional
        Amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–120 seconds. For target groups with a protocol of HTTP, the default is 6 seconds. For target groups with a protocol of TCP, TLS or HTTPS, the default is 10 seconds. For target groups with a protocol of GENEVE, the default is 5 seconds. If the target type is lambda, the default is 30 seconds.
    unhealthyThreshold : float, default is Undefined, optional
        Number of consecutive health check failures required before considering a target unhealthy. The range is 2-10. Defaults to 3.
    """


    enabled?: bool

    healthyThreshold?: float

    interval?: float

    matcher?: str

    path?: str

    port?: str

    $protocol?: str

    timeout?: float

    unhealthyThreshold?: float




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderStickiness:
    r"""
    Stickiness configuration block. Detailed below.

    Attributes
    ----------
    cookieDuration : float, default is Undefined, optional
        Only used when the type is lb_cookie. The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds).
    cookieName : str, default is Undefined, optional
        Name of the application based cookie. AWSALB, AWSALBAPP, and AWSALBTG prefixes are reserved and cannot be used. Only needed when type is app_cookie.
    enabled : bool, default is Undefined, optional
        Whether health checks are enabled. Defaults to true.
    $type : str, default is Undefined, optional
        The type of sticky sessions. The only current possible values are lb_cookie, app_cookie for ALBs, source_ip for NLBs, and source_ip_dest_ip, source_ip_dest_ip_proto for GWLBs.
    """


    cookieDuration?: float

    cookieName?: str

    enabled?: bool

    $type?: str




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetFailover:
    r"""
    l b target group v1beta1 for provider target failover

    Attributes
    ----------
    onDeregistration : str, default is Undefined, optional
        Indicates how the GWLB handles existing flows when a target is deregistered. Possible values are rebalance and no_rebalance. Must match the attribute value set for on_unhealthy. Default: no_rebalance.
    onUnhealthy : str, default is Undefined, optional
        Indicates how the GWLB handles existing flows when a target is unhealthy. Possible values are rebalance and no_rebalance. Must match the attribute value set for on_deregistration. Default: no_rebalance.
    """


    onDeregistration?: str

    onUnhealthy?: str




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetGroupHealth:
    r"""
    Target health requirements block. See target_group_health for more information.

    Attributes
    ----------
    dnsFailover : Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetGroupHealthDNSFailover, default is Undefined, optional
        dns failover
    unhealthyStateRouting : Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetGroupHealthUnhealthyStateRouting, default is Undefined, optional
        unhealthy state routing
    """


    dnsFailover?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetGroupHealthDNSFailover

    unhealthyStateRouting?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetGroupHealthUnhealthyStateRouting




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetHealthState:
    r"""
    l b target group v1beta1 for provider target health state

    Attributes
    ----------
    enableUnhealthyConnectionTermination : bool, default is Undefined, optional
        Indicates whether the load balancer terminates connections to unhealthy targets. Possible values are true or false. Default: true.
    unhealthyDrainingInterval : float, default is Undefined, optional
        Indicates the time to wait for in-flight requests to complete when a target becomes unhealthy. The range is 0-360000. This value has to be set only if enable_unhealthy_connection_termination is set to false. Default: 0.
    """


    enableUnhealthyConnectionTermination?: bool

    unhealthyDrainingInterval?: float




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDRef:
    r"""
    Reference to a VPC in ec2 to populate vpcId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDRefPolicy




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDSelector:
    r"""
    Selector for a VPC in ec2 to populate vpcId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDSelectorPolicy




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProvider:
    r"""
    l b target group v1beta1 spec for provider

    Attributes
    ----------
    connectionTermination : bool, default is Undefined, optional
        Whether to terminate connections at the end of the deregistration timeout on Network Load Balancers. See doc for more information. Default is false.
    deregistrationDelay : str, default is Undefined, optional
        Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds.
    healthCheck : Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderHealthCheck, default is Undefined, optional
        health check
    ipAddressType : str, default is Undefined, optional
        The type of IP addresses used by the target group, only supported when target type is set to ip. Possible values are ipv4 or ipv6.
    lambdaMultiValueHeadersEnabled : bool, default is Undefined, optional
        Whether the request and response headers exchanged between the load balancer and the Lambda function include arrays of values or strings. Only applies when target_type is lambda. Default is false.
    loadBalancingAlgorithmType : str, default is Undefined, optional
        Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups. The value is round_robin, least_outstanding_requests, or weighted_random. The default is round_robin.
    loadBalancingAnomalyMitigation : str, default is Undefined, optional
        Determines whether to enable target anomaly mitigation.  Target anomaly mitigation is only supported by the weighted_random load balancing algorithm type.  See doc for more information.  The value is "on" or "off". The default is "off".
    loadBalancingCrossZoneEnabled : str, default is Undefined, optional
        Indicates whether cross zone load balancing is enabled. The value is "true", "false" or "use_load_balancer_configuration". The default is "use_load_balancer_configuration".
    name : str, default is Undefined, optional
        Name of the target group. This name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen.
    port : float, default is Undefined, optional
        (May be required, Forces new resource) Port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda.
    preserveClientIp : str, default is Undefined, optional
        Whether client IP preservation is enabled. See doc for more information.
    $protocol : str, default is Undefined, optional
        (May be required, Forces new resource) Protocol to use for routing traffic to the targets.
        Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, UDP, QUIC, or TCP_QUIC.
        Required when target_type is instance, ip, or alb.
        Does not apply when target_type is lambda.
    protocolVersion : str, default is Undefined, optional
        Only applicable when protocol is HTTP or HTTPS. The protocol version. Specify GRPC to send requests to targets using gRPC. Specify HTTP2 to send requests to targets using HTTP/2. The default is HTTP1, which sends requests to targets using HTTP/1.1
    proxyProtocolV2 : bool, default is Undefined, optional
        Whether to enable support for proxy protocol v2 on Network Load Balancers. See doc for more information. Default is false.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    slowStart : float, default is Undefined, optional
        Amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is 0 seconds.
    stickiness : Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderStickiness, default is Undefined, optional
        stickiness
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    targetControlPort : float, default is Undefined, optional
        Port on which the target control agent and application load balancer exchange management traffic for the target optimizer feature. Only applicable for Application Load Balancer target groups when target_type is instance or ip.
    targetFailover : [Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetFailover], default is Undefined, optional
        Target failover block. Only applicable for Gateway Load Balancer target groups. See target_failover for more information.
    targetGroupHealth : Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetGroupHealth, default is Undefined, optional
        target group health
    targetHealthState : [Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetHealthState], default is Undefined, optional
        Target health state block. Only applicable for Network Load Balancer target groups when protocol is TCP or TLS. See target_health_state for more information.
    targetType : str, default is Undefined, optional
        Type of target that you must specify when registering targets with this target group.
        See doc for supported values.
        The default is instance.
    vpcId : str, default is Undefined, optional
        Identifier of the VPC in which to create the target group. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda.
    vpcIdRef : Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDRef, default is Undefined, optional
        vpc Id ref
    vpcIdSelector : Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDSelector, default is Undefined, optional
        vpc Id selector
    """


    connectionTermination?: bool

    deregistrationDelay?: str

    healthCheck?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderHealthCheck

    ipAddressType?: str

    lambdaMultiValueHeadersEnabled?: bool

    loadBalancingAlgorithmType?: str

    loadBalancingAnomalyMitigation?: str

    loadBalancingCrossZoneEnabled?: str

    name?: str

    port?: float

    preserveClientIp?: str

    $protocol?: str

    protocolVersion?: str

    proxyProtocolV2?: bool

    region: str

    slowStart?: float

    stickiness?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderStickiness

    tags?: {str:str}

    targetControlPort?: float

    targetFailover?: [Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetFailover]

    targetGroupHealth?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetGroupHealth

    targetHealthState?: [Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetHealthState]

    targetType?: str

    vpcId?: str

    vpcIdRef?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDRef

    vpcIdSelector?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDSelector




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupStatusAtProvider:
    r"""
    l b target group v1beta1 status at provider

    Attributes
    ----------
    arn : str, default is Undefined, optional
        ARN of the Target Group (matches id).
    arnSuffix : str, default is Undefined, optional
        ARN suffix for use with CloudWatch Metrics.
    connectionTermination : bool, default is Undefined, optional
        Whether to terminate connections at the end of the deregistration timeout on Network Load Balancers. See doc for more information. Default is false.
    deregistrationDelay : str, default is Undefined, optional
        Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds.
    healthCheck : Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderHealthCheck, default is Undefined, optional
        health check
    id : str, default is Undefined, optional
        ARN of the Target Group (matches arn).
    ipAddressType : str, default is Undefined, optional
        The type of IP addresses used by the target group, only supported when target type is set to ip. Possible values are ipv4 or ipv6.
    lambdaMultiValueHeadersEnabled : bool, default is Undefined, optional
        Whether the request and response headers exchanged between the load balancer and the Lambda function include arrays of values or strings. Only applies when target_type is lambda. Default is false.
    loadBalancerArns : [str], default is Undefined, optional
        ARNs of the Load Balancers associated with the Target Group.
    loadBalancingAlgorithmType : str, default is Undefined, optional
        Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups. The value is round_robin, least_outstanding_requests, or weighted_random. The default is round_robin.
    loadBalancingAnomalyMitigation : str, default is Undefined, optional
        Determines whether to enable target anomaly mitigation.  Target anomaly mitigation is only supported by the weighted_random load balancing algorithm type.  See doc for more information.  The value is "on" or "off". The default is "off".
    loadBalancingCrossZoneEnabled : str, default is Undefined, optional
        Indicates whether cross zone load balancing is enabled. The value is "true", "false" or "use_load_balancer_configuration". The default is "use_load_balancer_configuration".
    name : str, default is Undefined, optional
        Name of the target group. This name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen.
    port : float, default is Undefined, optional
        (May be required, Forces new resource) Port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda.
    preserveClientIp : str, default is Undefined, optional
        Whether client IP preservation is enabled. See doc for more information.
    $protocol : str, default is Undefined, optional
        (May be required, Forces new resource) Protocol to use for routing traffic to the targets.
        Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, UDP, QUIC, or TCP_QUIC.
        Required when target_type is instance, ip, or alb.
        Does not apply when target_type is lambda.
    protocolVersion : str, default is Undefined, optional
        Only applicable when protocol is HTTP or HTTPS. The protocol version. Specify GRPC to send requests to targets using gRPC. Specify HTTP2 to send requests to targets using HTTP/2. The default is HTTP1, which sends requests to targets using HTTP/1.1
    proxyProtocolV2 : bool, default is Undefined, optional
        Whether to enable support for proxy protocol v2 on Network Load Balancers. See doc for more information. Default is false.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    slowStart : float, default is Undefined, optional
        Amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is 0 seconds.
    stickiness : Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderStickiness, default is Undefined, optional
        stickiness
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    tagsAll : {str:str}, default is Undefined, optional
        A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block.
    targetControlPort : float, default is Undefined, optional
        Port on which the target control agent and application load balancer exchange management traffic for the target optimizer feature. Only applicable for Application Load Balancer target groups when target_type is instance or ip.
    targetFailover : [Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetFailover], default is Undefined, optional
        Target failover block. Only applicable for Gateway Load Balancer target groups. See target_failover for more information.
    targetGroupHealth : Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetGroupHealth, default is Undefined, optional
        target group health
    targetHealthState : [Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetHealthState], default is Undefined, optional
        Target health state block. Only applicable for Network Load Balancer target groups when protocol is TCP or TLS. See target_health_state for more information.
    targetType : str, default is Undefined, optional
        Type of target that you must specify when registering targets with this target group.
        See doc for supported values.
        The default is instance.
    vpcId : str, default is Undefined, optional
        Identifier of the VPC in which to create the target group. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda.
    """


    arn?: str

    arnSuffix?: str

    connectionTermination?: bool

    deregistrationDelay?: str

    healthCheck?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderHealthCheck

    id?: str

    ipAddressType?: str

    lambdaMultiValueHeadersEnabled?: bool

    loadBalancerArns?: [str]

    loadBalancingAlgorithmType?: str

    loadBalancingAnomalyMitigation?: str

    loadBalancingCrossZoneEnabled?: str

    name?: str

    port?: float

    preserveClientIp?: str

    $protocol?: str

    protocolVersion?: str

    proxyProtocolV2?: bool

    region?: str

    slowStart?: float

    stickiness?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderStickiness

    tags?: {str:str}

    tagsAll?: {str:str}

    targetControlPort?: float

    targetFailover?: [Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetFailover]

    targetGroupHealth?: Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetGroupHealth

    targetHealthState?: [Elbv2AwsmUpboundIoV1beta1LBTargetGroupAtProviderTargetHealthState]

    targetType?: str

    vpcId?: str




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetGroupHealthDNSFailover:
    r"""
    Block to configure DNS Failover requirements. See DNS Failover below for details on attributes.

    Attributes
    ----------
    minimumHealthyTargetsCount : str, default is Undefined, optional
        The minimum number of targets that must be healthy. If the number of healthy targets is below this value, mark the zone as unhealthy in DNS, so that traffic is routed only to healthy zones. The possible values are off or an integer from 1 to the maximum number of targets. The default is off.
    minimumHealthyTargetsPercentage : str, default is Undefined, optional
        The minimum percentage of targets that must be healthy. If the percentage of healthy targets is below this value, mark the zone as unhealthy in DNS, so that traffic is routed only to healthy zones. The possible values are off or an integer from 1 to 100. The default is off.
    """


    minimumHealthyTargetsCount?: str

    minimumHealthyTargetsPercentage?: str




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderTargetGroupHealthUnhealthyStateRouting:
    r"""
    Block to configure Unhealthy State Routing requirements. See Unhealthy State Routing below for details on attributes.

    Attributes
    ----------
    minimumHealthyTargetsCount : float, default is Undefined, optional
        The minimum number of targets that must be healthy. If the number of healthy targets is below this value, send traffic to all targets, including unhealthy targets. The possible values are 1 to the maximum number of targets. The default is 1.
    minimumHealthyTargetsPercentage : str, default is Undefined, optional
        The minimum percentage of targets that must be healthy. If the percentage of healthy targets is below this value, send traffic to all targets, including unhealthy targets. The possible values are off or an integer from 1 to 100. The default is off.
    """


    minimumHealthyTargetsCount?: float

    minimumHealthyTargetsPercentage?: str




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBTargetGroupSpecForProviderVpcIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"

schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderArnRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderArnSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultAction:
    r"""
    l b listener v1beta1 at provider default action

    Attributes
    ----------
    authenticateCognito : Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionAuthenticateCognito, default is Undefined, optional
        authenticate cognito
    authenticateOidc : Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionAuthenticateOidc, default is Undefined, optional
        authenticate oidc
    fixedResponse : Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionFixedResponse, default is Undefined, optional
        fixed response
    forward : Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionForward, default is Undefined, optional
        forward
    index : str, default is Undefined, optional
        This is an injected field with a default value for being able to merge items of the parent object list.
    jwtValidation : Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionJwtValidation, default is Undefined, optional
        jwt validation
    order : float, default is Undefined, optional
        Order for the action. The action with the lowest value for order is performed first. Valid values are between 1 and 50000. Defaults to the position in the list of actions.
    redirect : Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionRedirect, default is Undefined, optional
        redirect
    targetGroupArn : str, default is Undefined, optional
        ARN of the Target Group to which to route traffic. Specify only if type is forward and you want to route to a single target group. To route to one or more target groups, use a forward block instead. Can be specified with forward but ARNs must match.
    $type : str, default is Undefined, optional
        Type of routing action. Valid values are forward, redirect, fixed-response, authenticate-cognito, authenticate-oidc and jwt-validation.
    """


    authenticateCognito?: Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionAuthenticateCognito

    authenticateOidc?: Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionAuthenticateOidc

    fixedResponse?: Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionFixedResponse

    forward?: Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionForward

    index?: str

    jwtValidation?: Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionJwtValidation

    order?: float

    redirect?: Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionRedirect

    targetGroupArn?: str

    $type?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionAuthenticateCognito:
    r"""
    Configuration block for using Amazon Cognito to authenticate users. Specify only when type is authenticate-cognito. See below.

    Attributes
    ----------
    authenticationRequestExtraParams : {str:str}, default is Undefined, optional
        Query parameters to include in the redirect request to the authorization endpoint. Max: 10. See below.
    onUnauthenticatedRequest : str, default is Undefined, optional
        Behavior if the user is not authenticated. Valid values are deny, allow and authenticate.
    scope : str, default is Undefined, optional
        Set of user claims to be requested from the IdP.
    sessionCookieName : str, default is Undefined, optional
        Name of the cookie used to maintain session information.
    sessionTimeout : float, default is Undefined, optional
        Maximum duration of the authentication session, in seconds.
    userPoolArn : str, default is Undefined, optional
        ARN of the Cognito user pool.
    userPoolClientId : str, default is Undefined, optional
        ID of the Cognito user pool client.
    userPoolDomain : str, default is Undefined, optional
        Domain prefix or fully-qualified domain name of the Cognito user pool.
    """


    authenticationRequestExtraParams?: {str:str}

    onUnauthenticatedRequest?: str

    scope?: str

    sessionCookieName?: str

    sessionTimeout?: float

    userPoolArn?: str

    userPoolClientId?: str

    userPoolDomain?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionAuthenticateOidc:
    r"""
    Configuration block for an identity provider that is compliant with OpenID Connect (OIDC). Specify only when type is authenticate-oidc. See below.

    Attributes
    ----------
    authenticationRequestExtraParams : {str:str}, default is Undefined, optional
        Query parameters to include in the redirect request to the authorization endpoint. Max: 10.
    authorizationEndpoint : str, default is Undefined, optional
        Authorization endpoint of the IdP.
    clientId : str, default is Undefined, optional
        OAuth 2.0 client identifier.
    issuer : str, default is Undefined, optional
        OIDC issuer identifier of the IdP.
    onUnauthenticatedRequest : str, default is Undefined, optional
        Behavior if the user is not authenticated. Valid values: deny, allow and authenticate
    scope : str, default is Undefined, optional
        Set of user claims to be requested from the IdP.
    sessionCookieName : str, default is Undefined, optional
        Name of the cookie used to maintain session information.
    sessionTimeout : float, default is Undefined, optional
        Maximum duration of the authentication session, in seconds.
    tokenEndpoint : str, default is Undefined, optional
        Token endpoint of the IdP.
    userInfoEndpoint : str, default is Undefined, optional
        User info endpoint of the IdP.
    """


    authenticationRequestExtraParams?: {str:str}

    authorizationEndpoint?: str

    clientId?: str

    issuer?: str

    onUnauthenticatedRequest?: str

    scope?: str

    sessionCookieName?: str

    sessionTimeout?: float

    tokenEndpoint?: str

    userInfoEndpoint?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionFixedResponse:
    r"""
    Information for creating an action that returns a custom HTTP response. Required if type is fixed-response.

    Attributes
    ----------
    contentType : str, default is Undefined, optional
        Content type. Valid values are text/plain, text/css, text/html, application/javascript and application/json.
    messageBody : str, default is Undefined, optional
        Message body.
    statusCode : str, default is Undefined, optional
        HTTP response code. Valid values are 2XX, 4XX, or 5XX.
    """


    contentType?: str

    messageBody?: str

    statusCode?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionForward:
    r"""
    Configuration block for creating an action that distributes requests among one or more target groups. Specify only if type is forward. See below.

    Attributes
    ----------
    stickiness : Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionForwardStickiness, default is Undefined, optional
        stickiness
    targetGroup : [Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionForwardTargetGroup], default is Undefined, optional
        Set of 1-5 target group blocks. See below.
    """


    stickiness?: Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionForwardStickiness

    targetGroup?: [Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionForwardTargetGroup]




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionForwardStickiness:
    r"""
    Configuration block for target group stickiness for the rule. See below.

    Attributes
    ----------
    duration : float, default is Undefined, optional
        Time period, in seconds, during which requests from a client should be routed to the same target group. The range is 1-604800 seconds (7 days).
    enabled : bool, default is Undefined, optional
        Whether target group stickiness is enabled. Default is false.
    """


    duration?: float

    enabled?: bool




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionForwardTargetGroup:
    r"""
    l b listener v1beta1 at provider default action forward target group

    Attributes
    ----------
    arn : str, default is Undefined, optional
        ARN of the target group.
    weight : float, default is Undefined, optional
        Weight. The range is 0 to 999.
    """


    arn?: str

    weight?: float




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionJwtValidation:
    r"""
    Configuration block for creating a JWT validation action. Required if type is jwt-validation.

    Attributes
    ----------
    additionalClaim : [Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionJwtValidationAdditionalClaim], default is Undefined, optional
        Repeatable configuration block for additional claims to validate.
    issuer : str, default is Undefined, optional
        Issuer of the JWT.
    jwksEndpoint : str, default is Undefined, optional
        JSON Web Key Set (JWKS) endpoint. This endpoint contains JSON Web Keys (JWK) that are used to validate signatures from the provider. This must be a full URL, including the HTTPS protocol, the domain, and the path.
    """


    additionalClaim?: [Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionJwtValidationAdditionalClaim]

    issuer?: str

    jwksEndpoint?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionJwtValidationAdditionalClaim:
    r"""
    l b listener v1beta1 at provider default action jwt validation additional claim

    Attributes
    ----------
    format : str, default is Undefined, optional
        Format of the claim value. Valid values are single-string, string-array and space-separated-values.
    name : str, default is Undefined, optional
        Name of the claim to validate. exp, iss, nbf, or iat cannot be specified because they are validated by default.
    values : [str], default is Undefined, optional
        List of expected values of the claim.
    """


    format?: str

    name?: str

    values?: [str]




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultActionRedirect:
    r"""
    Configuration block for creating a redirect action. Required if type is redirect. See below.

    Attributes
    ----------
    host : str, default is Undefined, optional
        Hostname. This component is not percent-encoded. The hostname can contain #{host}. Defaults to #{host}.
    path : str, default is Undefined, optional
        Absolute path, starting with the leading "/". This component is not percent-encoded. The path can contain #{host}, #{path}, and #{port}. Defaults to /#{path}.
    port : str, default is Undefined, optional
        Port. Specify a value from 1 to 65535 or #{port}. Defaults to #{port}.
    $protocol : str, default is Undefined, optional
        Protocol. Valid values are HTTP, HTTPS, or #{protocol}. Defaults to #{protocol}.
    query : str, default is Undefined, optional
        Query parameters, URL-encoded when necessary, but not percent-encoded. Do not include the leading "?". Defaults to #{query}.
    statusCode : str, default is Undefined, optional
        HTTP redirect code. The redirect is either permanent (HTTP_301) or temporary (HTTP_302).
    """


    host?: str

    path?: str

    port?: str

    $protocol?: str

    query?: str

    statusCode?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderMutualAuthentication:
    r"""
    The mutual authentication configuration information. See below.

    Attributes
    ----------
    advertiseTrustStoreCaNames : str, default is Undefined, optional
        Valid values are off and on.
    ignoreClientCertificateExpiry : bool, default is Undefined, optional
        Whether client certificate expiry is ignored.
        Default is false.
    mode : str, default is Undefined, optional
        Valid values are off, passthrough, and verify.
    trustStoreArn : str, default is Undefined, optional
        ARN of the elbv2 Trust Store.
    """


    advertiseTrustStoreCaNames?: str

    ignoreClientCertificateExpiry?: bool

    mode?: str

    trustStoreArn?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderAuthenticateOidcClientSecretSecretRef:
    r"""
    OAuth 2.0 client secret.

    Attributes
    ----------
    key : str, default is Undefined, required
        key
    name : str, default is Undefined, required
        Name of the secret.
    """


    key: str

    name: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionAuthenticateCognito:
    r"""
    Configuration block for using Amazon Cognito to authenticate users. Specify only when type is authenticate-cognito. See below.

    Attributes
    ----------
    authenticationRequestExtraParams : {str:str}, default is Undefined, optional
        Query parameters to include in the redirect request to the authorization endpoint. Max: 10. See below.
    onUnauthenticatedRequest : str, default is Undefined, optional
        Behavior if the user is not authenticated. Valid values are deny, allow and authenticate.
    scope : str, default is Undefined, optional
        Set of user claims to be requested from the IdP.
    sessionCookieName : str, default is Undefined, optional
        Name of the cookie used to maintain session information.
    sessionTimeout : float, default is Undefined, optional
        Maximum duration of the authentication session, in seconds.
    userPoolArn : str, default is Undefined, optional
        ARN of the Cognito user pool.
    userPoolClientId : str, default is Undefined, optional
        ID of the Cognito user pool client.
    userPoolDomain : str, default is Undefined, optional
        Domain prefix or fully-qualified domain name of the Cognito user pool.
    """


    authenticationRequestExtraParams?: {str:str}

    onUnauthenticatedRequest?: str

    scope?: str

    sessionCookieName?: str

    sessionTimeout?: float

    userPoolArn?: str

    userPoolClientId?: str

    userPoolDomain?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionAuthenticateOidc:
    r"""
    Configuration block for an identity provider that is compliant with OpenID Connect (OIDC). Specify only when type is authenticate-oidc. See below.

    Attributes
    ----------
    authenticationRequestExtraParams : {str:str}, default is Undefined, optional
        Query parameters to include in the redirect request to the authorization endpoint. Max: 10.
    authorizationEndpoint : str, default is Undefined, optional
        Authorization endpoint of the IdP.
    clientId : str, default is Undefined, optional
        OAuth 2.0 client identifier.
    clientSecretSecretRef : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderAuthenticateOidcClientSecretSecretRef, default is Undefined, optional
        client secret secret ref
    issuer : str, default is Undefined, optional
        OIDC issuer identifier of the IdP.
    onUnauthenticatedRequest : str, default is Undefined, optional
        Behavior if the user is not authenticated. Valid values: deny, allow and authenticate
    scope : str, default is Undefined, optional
        Set of user claims to be requested from the IdP.
    sessionCookieName : str, default is Undefined, optional
        Name of the cookie used to maintain session information.
    sessionTimeout : float, default is Undefined, optional
        Maximum duration of the authentication session, in seconds.
    tokenEndpoint : str, default is Undefined, optional
        Token endpoint of the IdP.
    userInfoEndpoint : str, default is Undefined, optional
        User info endpoint of the IdP.
    """


    authenticationRequestExtraParams?: {str:str}

    authorizationEndpoint?: str

    clientId?: str

    clientSecretSecretRef?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderAuthenticateOidcClientSecretSecretRef

    issuer?: str

    onUnauthenticatedRequest?: str

    scope?: str

    sessionCookieName?: str

    sessionTimeout?: float

    tokenEndpoint?: str

    userInfoEndpoint?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionFixedResponse:
    r"""
    Information for creating an action that returns a custom HTTP response. Required if type is fixed-response.

    Attributes
    ----------
    contentType : str, default is Undefined, optional
        Content type. Valid values are text/plain, text/css, text/html, application/javascript and application/json.
    messageBody : str, default is Undefined, optional
        Message body.
    statusCode : str, default is Undefined, optional
        HTTP response code. Valid values are 2XX, 4XX, or 5XX.
    """


    contentType?: str

    messageBody?: str

    statusCode?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionForward:
    r"""
    Configuration block for creating an action that distributes requests among one or more target groups. Specify only if type is forward. See below.

    Attributes
    ----------
    stickiness : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderForwardStickiness, default is Undefined, optional
        stickiness
    targetGroup : [Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderForwardTargetGroup], default is Undefined, optional
        Set of 1-5 target group blocks. See below.
    """


    stickiness?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderForwardStickiness

    targetGroup?: [Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderForwardTargetGroup]




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionJwtValidation:
    r"""
    Configuration block for creating a JWT validation action. Required if type is jwt-validation.

    Attributes
    ----------
    additionalClaim : [Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderJwtValidationAdditionalClaim], default is Undefined, optional
        Repeatable configuration block for additional claims to validate.
    issuer : str, default is Undefined, optional
        Issuer of the JWT.
    jwksEndpoint : str, default is Undefined, optional
        JSON Web Key Set (JWKS) endpoint. This endpoint contains JSON Web Keys (JWK) that are used to validate signatures from the provider. This must be a full URL, including the HTTPS protocol, the domain, and the path.
    """


    additionalClaim?: [Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderJwtValidationAdditionalClaim]

    issuer?: str

    jwksEndpoint?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionRedirect:
    r"""
    Configuration block for creating a redirect action. Required if type is redirect. See below.

    Attributes
    ----------
    host : str, default is Undefined, optional
        Hostname. This component is not percent-encoded. The hostname can contain #{host}. Defaults to #{host}.
    path : str, default is Undefined, optional
        Absolute path, starting with the leading "/". This component is not percent-encoded. The path can contain #{host}, #{path}, and #{port}. Defaults to /#{path}.
    port : str, default is Undefined, optional
        Port. Specify a value from 1 to 65535 or #{port}. Defaults to #{port}.
    $protocol : str, default is Undefined, optional
        Protocol. Valid values are HTTP, HTTPS, or #{protocol}. Defaults to #{protocol}.
    query : str, default is Undefined, optional
        Query parameters, URL-encoded when necessary, but not percent-encoded. Do not include the leading "?". Defaults to #{query}.
    statusCode : str, default is Undefined, optional
        HTTP redirect code. The redirect is either permanent (HTTP_301) or temporary (HTTP_302).
    """


    host?: str

    path?: str

    port?: str

    $protocol?: str

    query?: str

    statusCode?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionTargetGroupArnRef:
    r"""
    Reference to a LBTargetGroup in elbv2 to populate targetGroupArn.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnRefPolicy




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionTargetGroupArnSelector:
    r"""
    Selector for a LBTargetGroup in elbv2 to populate targetGroupArn.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnSelectorPolicy




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultAction:
    r"""
    l b listener v1beta1 for provider default action

    Attributes
    ----------
    authenticateCognito : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionAuthenticateCognito, default is Undefined, optional
        authenticate cognito
    authenticateOidc : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionAuthenticateOidc, default is Undefined, optional
        authenticate oidc
    fixedResponse : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionFixedResponse, default is Undefined, optional
        fixed response
    forward : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionForward, default is Undefined, optional
        forward
    index : str, default is "default", optional
        This is an injected field with a default value for being able to merge items of the parent object list.
    jwtValidation : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionJwtValidation, default is Undefined, optional
        jwt validation
    order : float, default is Undefined, optional
        Order for the action. The action with the lowest value for order is performed first. Valid values are between 1 and 50000. Defaults to the position in the list of actions.
    redirect : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionRedirect, default is Undefined, optional
        redirect
    targetGroupArn : str, default is Undefined, optional
        ARN of the Target Group to which to route traffic. Specify only if type is forward and you want to route to a single target group. To route to one or more target groups, use a forward block instead. Can be specified with forward but ARNs must match.
    targetGroupArnRef : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionTargetGroupArnRef, default is Undefined, optional
        target group arn ref
    targetGroupArnSelector : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionTargetGroupArnSelector, default is Undefined, optional
        target group arn selector
    $type : str, default is Undefined, optional
        Type of routing action. Valid values are forward, redirect, fixed-response, authenticate-cognito, authenticate-oidc and jwt-validation.
    """


    authenticateCognito?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionAuthenticateCognito

    authenticateOidc?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionAuthenticateOidc

    fixedResponse?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionFixedResponse

    forward?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionForward

    index?: str = "default"

    jwtValidation?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionJwtValidation

    order?: float

    redirect?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionRedirect

    targetGroupArn?: str

    targetGroupArnRef?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionTargetGroupArnRef

    targetGroupArnSelector?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultActionTargetGroupArnSelector

    $type?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnRef:
    r"""
    Reference to a LB in elbv2 to populate loadBalancerArn.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnRefPolicy




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnSelector:
    r"""
    Selector for a LB in elbv2 to populate loadBalancerArn.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnSelectorPolicy




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderMutualAuthentication:
    r"""
    The mutual authentication configuration information. See below.

    Attributes
    ----------
    advertiseTrustStoreCaNames : str, default is Undefined, optional
        Valid values are off and on.
    ignoreClientCertificateExpiry : bool, default is Undefined, optional
        Whether client certificate expiry is ignored.
        Default is false.
    mode : str, default is Undefined, optional
        Valid values are off, passthrough, and verify.
    trustStoreArn : str, default is Undefined, optional
        ARN of the elbv2 Trust Store.
    """


    advertiseTrustStoreCaNames?: str

    ignoreClientCertificateExpiry?: bool

    mode?: str

    trustStoreArn?: str




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderForwardStickiness:
    r"""
    Configuration block for target group stickiness for the rule. See below.

    Attributes
    ----------
    duration : float, default is Undefined, optional
        Time period, in seconds, during which requests from a client should be routed to the same target group. The range is 1-604800 seconds (7 days).
    enabled : bool, default is Undefined, optional
        Whether target group stickiness is enabled. Default is false.
    """


    duration?: float

    enabled?: bool




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderForwardTargetGroup:
    r"""
    l b listener v1beta1 forward target group

    Attributes
    ----------
    arn : str, default is Undefined, optional
        ARN of the target group.
    arnRef : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnRef, default is Undefined, optional
        arn ref
    arnSelector : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnSelector, default is Undefined, optional
        arn selector
    weight : float, default is Undefined, optional
        Weight. The range is 0 to 999.
    """


    arn?: str

    arnRef?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnRef

    arnSelector?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnSelector

    weight?: float




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderJwtValidationAdditionalClaim:
    r"""
    l b listener v1beta1 jwt validation additional claim

    Attributes
    ----------
    format : str, default is Undefined, optional
        Format of the claim value. Valid values are single-string, string-array and space-separated-values.
    name : str, default is Undefined, optional
        Name of the claim to validate. exp, iss, nbf, or iat cannot be specified because they are validated by default.
    values : [str], default is Undefined, optional
        List of expected values of the claim.
    """


    format?: str

    name?: str

    values?: [str]




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProvider:
    r"""
    l b listener v1beta1 spec for provider

    Attributes
    ----------
    alpnPolicy : str, default is Undefined, optional
        Name of the Application-Layer Protocol Negotiation (ALPN) policy. Can be set if protocol is TLS. Valid values are HTTP1Only, HTTP2Only, HTTP2Optional, HTTP2Preferred, and None.
    certificateArn : str, default is Undefined, optional
        ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS. For adding additional SSL certificates, see the aws_lb_listener_certificate resource.
    defaultAction : [Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultAction], default is Undefined, optional
        Configuration block for default actions. See below.
    loadBalancerArn : str, default is Undefined, optional
        ARN of the load balancer.
    loadBalancerArnRef : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnRef, default is Undefined, optional
        load balancer arn ref
    loadBalancerArnSelector : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnSelector, default is Undefined, optional
        load balancer arn selector
    mutualAuthentication : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderMutualAuthentication, default is Undefined, optional
        mutual authentication
    port : float, default is Undefined, optional
        Port on which the load balancer is listening. Not valid for Gateway Load Balancers.
    $protocol : str, default is Undefined, optional
        Protocol for connections from clients to the load balancer. For Application Load Balancers, valid values are HTTP and HTTPS, with a default of HTTP. For Network Load Balancers, valid values are TCP, TLS, UDP, TCP_UDP, QUIC, and TCP_QUIC. Not valid to use UDP or TCP_UDP if dual-stack mode is enabled. Not valid to use QUIC or TCP_QUIC if security groups are configured or dual-stack mode is enabled. Not valid for Gateway Load Balancers.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    routingHttpRequestXAmznMtlsClientcertHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznMtlsClientcertIssuerHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Issuer HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznMtlsClientcertLeafHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Leaf HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznMtlsClientcertSerialNumberHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Serial-Number HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznMtlsClientcertSubjectHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Subject HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznMtlsClientcertValidityHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Validity HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznTlsCipherSuiteHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Tls-Cipher-Suite HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznTlsVersionHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Tls-Version HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpResponseAccessControlAllowCredentialsHeaderValue : str, default is Undefined, optional
        Specifies which headers the browser can expose to the requesting client. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. The only valid value is true.
    routingHttpResponseAccessControlAllowHeadersHeaderValue : str, default is Undefined, optional
        Specifies which headers can be used during the request. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Valid values are *, Accept, Accept-Language, Cache-Control, Content-Language, Content-Length, Content-Type, Expires, Last-Modified, Pragma. Dependent on your use-case other headers can be exposed and then set as a value consult the Access-Control-Allow-Headers documentation.
    routingHttpResponseAccessControlAllowMethodsHeaderValue : str, default is Undefined, optional
        Set which HTTP methods are allowed when accessing the server from a different origin. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Valid values are GET, HEAD, POST, DELETE, CONNECT, OPTIONS, TRACE or PATCH.
    routingHttpResponseAccessControlAllowOriginHeaderValue : str, default is Undefined, optional
        Specifies which origins are allowed to access the server. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. A valid value is a URI, eg: https://example.com.
    routingHttpResponseAccessControlExposeHeadersHeaderValue : str, default is Undefined, optional
        Specifies whether the browser should include credentials such as cookies or authentication when making requests. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Valid values are *, Cache-Control, Content-Language, Content-Length, Content-Type, Expires, Last-Modified, or Pragma. Dependent on your use-case other headers can be exposed, consult the Access-Control-Expose-Headers documentation.
    routingHttpResponseAccessControlMaxAgeHeaderValue : str, default is Undefined, optional
        Specifies how long the results of a preflight request can be cached, in seconds. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Valid values are between 0 and 86400. This value is browser specific, consult the Access-Control-Max-Age documentation.
    routingHttpResponseContentSecurityPolicyHeaderValue : str, default is Undefined, optional
        Specifies restrictions enforced by the browser to help minimize the risk of certain types of security threats. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Values for this are extensive, and can be impactful when set, consult Content-Security-Policy documentation.
    routingHttpResponseServerEnabled : bool, default is Undefined, optional
        Enables you to allow or remove the HTTP response server header. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Valid values are true or false.
    routingHttpResponseStrictTransportSecurityHeaderValue : str, default is Undefined, optional
        Informs browsers that the site should only be accessed using HTTPS, and that any future attempts to access it using HTTP should automatically be converted to HTTPS. Default values are max-age=31536000; includeSubDomains; preload consult the Strict-Transport-Security documentation for further details.
    routingHttpResponseXContentTypeOptionsHeaderValue : str, default is Undefined, optional
        Indicates whether the MIME types advertised in the Content-Type headers should be followed and not be changed. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. The only valid value is nosniff.
    routingHttpResponseXFrameOptionsHeaderValue : str, default is Undefined, optional
        Indicates whether the browser is allowed to render a page in a frame, iframe, embed or object. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. The only valid values are DENY, SAMEORIGIN, or ALLOW-FROM https://example.com.
    sslPolicy : str, default is Undefined, optional
        Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS. Default is ELBSecurityPolicy-2016-08.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    tcpIdleTimeoutSeconds : float, default is Undefined, optional
        TCP idle timeout value in seconds. Can only be set if protocol is TCP on Network Load Balancer, or with a Gateway Load Balancer. Not supported for Application Load Balancers. Valid values are between 60 and 6000 inclusive. Default: 350.
    """


    alpnPolicy?: str

    certificateArn?: str

    defaultAction?: [Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderDefaultAction]

    loadBalancerArn?: str

    loadBalancerArnRef?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnRef

    loadBalancerArnSelector?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderLoadBalancerArnSelector

    mutualAuthentication?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderMutualAuthentication

    port?: float

    $protocol?: str

    region: str

    routingHttpRequestXAmznMtlsClientcertHeaderName?: str

    routingHttpRequestXAmznMtlsClientcertIssuerHeaderName?: str

    routingHttpRequestXAmznMtlsClientcertLeafHeaderName?: str

    routingHttpRequestXAmznMtlsClientcertSerialNumberHeaderName?: str

    routingHttpRequestXAmznMtlsClientcertSubjectHeaderName?: str

    routingHttpRequestXAmznMtlsClientcertValidityHeaderName?: str

    routingHttpRequestXAmznTlsCipherSuiteHeaderName?: str

    routingHttpRequestXAmznTlsVersionHeaderName?: str

    routingHttpResponseAccessControlAllowCredentialsHeaderValue?: str

    routingHttpResponseAccessControlAllowHeadersHeaderValue?: str

    routingHttpResponseAccessControlAllowMethodsHeaderValue?: str

    routingHttpResponseAccessControlAllowOriginHeaderValue?: str

    routingHttpResponseAccessControlExposeHeadersHeaderValue?: str

    routingHttpResponseAccessControlMaxAgeHeaderValue?: str

    routingHttpResponseContentSecurityPolicyHeaderValue?: str

    routingHttpResponseServerEnabled?: bool

    routingHttpResponseStrictTransportSecurityHeaderValue?: str

    routingHttpResponseXContentTypeOptionsHeaderValue?: str

    routingHttpResponseXFrameOptionsHeaderValue?: str

    sslPolicy?: str

    tags?: {str:str}

    tcpIdleTimeoutSeconds?: float




schema Elbv2AwsmUpboundIoV1beta1LBListenerStatusAtProvider:
    r"""
    l b listener v1beta1 status at provider

    Attributes
    ----------
    alpnPolicy : str, default is Undefined, optional
        Name of the Application-Layer Protocol Negotiation (ALPN) policy. Can be set if protocol is TLS. Valid values are HTTP1Only, HTTP2Only, HTTP2Optional, HTTP2Preferred, and None.
    arn : str, default is Undefined, optional
        ARN of the listener.
    certificateArn : str, default is Undefined, optional
        ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS. For adding additional SSL certificates, see the aws_lb_listener_certificate resource.
    defaultAction : [Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultAction], default is Undefined, optional
        Configuration block for default actions. See below.
    id : str, default is Undefined, optional
        id
    loadBalancerArn : str, default is Undefined, optional
        ARN of the load balancer.
    mutualAuthentication : Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderMutualAuthentication, default is Undefined, optional
        mutual authentication
    port : float, default is Undefined, optional
        Port on which the load balancer is listening. Not valid for Gateway Load Balancers.
    $protocol : str, default is Undefined, optional
        Protocol for connections from clients to the load balancer. For Application Load Balancers, valid values are HTTP and HTTPS, with a default of HTTP. For Network Load Balancers, valid values are TCP, TLS, UDP, TCP_UDP, QUIC, and TCP_QUIC. Not valid to use UDP or TCP_UDP if dual-stack mode is enabled. Not valid to use QUIC or TCP_QUIC if security groups are configured or dual-stack mode is enabled. Not valid for Gateway Load Balancers.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    routingHttpRequestXAmznMtlsClientcertHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznMtlsClientcertIssuerHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Issuer HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznMtlsClientcertLeafHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Leaf HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznMtlsClientcertSerialNumberHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Serial-Number HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznMtlsClientcertSubjectHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Subject HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznMtlsClientcertValidityHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Mtls-Clientcert-Validity HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznTlsCipherSuiteHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Tls-Cipher-Suite HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpRequestXAmznTlsVersionHeaderName : str, default is Undefined, optional
        Enables you to modify the header name of the X-Amzn-Tls-Version HTTP request header. Can only be set if protocol is HTTPS for Application Load Balancers.
    routingHttpResponseAccessControlAllowCredentialsHeaderValue : str, default is Undefined, optional
        Specifies which headers the browser can expose to the requesting client. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. The only valid value is true.
    routingHttpResponseAccessControlAllowHeadersHeaderValue : str, default is Undefined, optional
        Specifies which headers can be used during the request. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Valid values are *, Accept, Accept-Language, Cache-Control, Content-Language, Content-Length, Content-Type, Expires, Last-Modified, Pragma. Dependent on your use-case other headers can be exposed and then set as a value consult the Access-Control-Allow-Headers documentation.
    routingHttpResponseAccessControlAllowMethodsHeaderValue : str, default is Undefined, optional
        Set which HTTP methods are allowed when accessing the server from a different origin. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Valid values are GET, HEAD, POST, DELETE, CONNECT, OPTIONS, TRACE or PATCH.
    routingHttpResponseAccessControlAllowOriginHeaderValue : str, default is Undefined, optional
        Specifies which origins are allowed to access the server. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. A valid value is a URI, eg: https://example.com.
    routingHttpResponseAccessControlExposeHeadersHeaderValue : str, default is Undefined, optional
        Specifies whether the browser should include credentials such as cookies or authentication when making requests. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Valid values are *, Cache-Control, Content-Language, Content-Length, Content-Type, Expires, Last-Modified, or Pragma. Dependent on your use-case other headers can be exposed, consult the Access-Control-Expose-Headers documentation.
    routingHttpResponseAccessControlMaxAgeHeaderValue : str, default is Undefined, optional
        Specifies how long the results of a preflight request can be cached, in seconds. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Valid values are between 0 and 86400. This value is browser specific, consult the Access-Control-Max-Age documentation.
    routingHttpResponseContentSecurityPolicyHeaderValue : str, default is Undefined, optional
        Specifies restrictions enforced by the browser to help minimize the risk of certain types of security threats. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Values for this are extensive, and can be impactful when set, consult Content-Security-Policy documentation.
    routingHttpResponseServerEnabled : bool, default is Undefined, optional
        Enables you to allow or remove the HTTP response server header. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. Valid values are true or false.
    routingHttpResponseStrictTransportSecurityHeaderValue : str, default is Undefined, optional
        Informs browsers that the site should only be accessed using HTTPS, and that any future attempts to access it using HTTP should automatically be converted to HTTPS. Default values are max-age=31536000; includeSubDomains; preload consult the Strict-Transport-Security documentation for further details.
    routingHttpResponseXContentTypeOptionsHeaderValue : str, default is Undefined, optional
        Indicates whether the MIME types advertised in the Content-Type headers should be followed and not be changed. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. The only valid value is nosniff.
    routingHttpResponseXFrameOptionsHeaderValue : str, default is Undefined, optional
        Indicates whether the browser is allowed to render a page in a frame, iframe, embed or object. Can only be set if protocol is HTTP or HTTPS for Application Load Balancers. Not supported for Network Load Balancer, or with a Gateway Load Balancer. The only valid values are DENY, SAMEORIGIN, or ALLOW-FROM https://example.com.
    sslPolicy : str, default is Undefined, optional
        Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS. Default is ELBSecurityPolicy-2016-08.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    tagsAll : {str:str}, default is Undefined, optional
        A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block.
    tcpIdleTimeoutSeconds : float, default is Undefined, optional
        TCP idle timeout value in seconds. Can only be set if protocol is TCP on Network Load Balancer, or with a Gateway Load Balancer. Not supported for Application Load Balancers. Valid values are between 60 and 6000 inclusive. Default: 350.
    """


    alpnPolicy?: str

    arn?: str

    certificateArn?: str

    defaultAction?: [Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderDefaultAction]

    id?: str

    loadBalancerArn?: str

    mutualAuthentication?: Elbv2AwsmUpboundIoV1beta1LBListenerAtProviderMutualAuthentication

    port?: float

    $protocol?: str

    region?: str

    routingHttpRequestXAmznMtlsClientcertHeaderName?: str

    routingHttpRequestXAmznMtlsClientcertIssuerHeaderName?: str

    routingHttpRequestXAmznMtlsClientcertLeafHeaderName?: str

    routingHttpRequestXAmznMtlsClientcertSerialNumberHeaderName?: str

    routingHttpRequestXAmznMtlsClientcertSubjectHeaderName?: str

    routingHttpRequestXAmznMtlsClientcertValidityHeaderName?: str

    routingHttpRequestXAmznTlsCipherSuiteHeaderName?: str

    routingHttpRequestXAmznTlsVersionHeaderName?: str

    routingHttpResponseAccessControlAllowCredentialsHeaderValue?: str

    routingHttpResponseAccessControlAllowHeadersHeaderValue?: str

    routingHttpResponseAccessControlAllowMethodsHeaderValue?: str

    routingHttpResponseAccessControlAllowOriginHeaderValue?: str

    routingHttpResponseAccessControlExposeHeadersHeaderValue?: str

    routingHttpResponseAccessControlMaxAgeHeaderValue?: str

    routingHttpResponseContentSecurityPolicyHeaderValue?: str

    routingHttpResponseServerEnabled?: bool

    routingHttpResponseStrictTransportSecurityHeaderValue?: str

    routingHttpResponseXContentTypeOptionsHeaderValue?: str

    routingHttpResponseXFrameOptionsHeaderValue?: str

    sslPolicy?: str

    tags?: {str:str}

    tagsAll?: {str:str}

    tcpIdleTimeoutSeconds?: float




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnRef:
    r"""
    Reference to a LBTargetGroup in elbv2 to populate arn.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderArnRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderArnRefPolicy




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnSelector:
    r"""
    Selector for a LBTargetGroup in elbv2 to populate arn.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderArnSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderArnSelectorPolicy




schema Elbv2AwsmUpboundIoV1beta1LBListenerSpecForProviderTargetGroupArnSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"

schema AcmAwsmUpboundIoV1beta1CertificateAtProviderDomainValidationOptions:
    r"""
    certificate v1beta1 at provider domain validation options

    Attributes
    ----------
    domainName : str, default is Undefined, optional
        Fully qualified domain name (FQDN) in the certificate.
    resourceRecordName : str, default is Undefined, optional
        The name of the DNS record to create to validate the certificate
    resourceRecordType : str, default is Undefined, optional
        The type of DNS record to create
    resourceRecordValue : str, default is Undefined, optional
        The value the DNS record needs to have
    """


    domainName?: str

    resourceRecordName?: str

    resourceRecordType?: str

    resourceRecordValue?: str




schema AcmAwsmUpboundIoV1beta1CertificateAtProviderOptions:
    r"""
    Configuration block used to set certificate options. Detailed below.

    Attributes
    ----------
    certificateTransparencyLoggingPreference : str, default is Undefined, optional
        Whether certificate details should be added to a certificate transparency log. Valid values are ENABLED or DISABLED. See https://docs.aws.amazon.com/acm/latest/userguide/acm-concepts.html#concept-transparency for more details.
    export : str, default is Undefined, optional
        Whether the certificate can be exported. Valid values are ENABLED or DISABLED (default). Note Issuing an exportable certificate is subject to additional charges. See AWS Certificate Manager pricing for more details.
    """


    certificateTransparencyLoggingPreference?: str

    export?: str




schema AcmAwsmUpboundIoV1beta1CertificateAtProviderRenewalSummary:
    r"""
    certificate v1beta1 at provider renewal summary

    Attributes
    ----------
    renewalStatus : str, default is Undefined, optional
        The status of ACM's managed renewal of the certificate
    renewalStatusReason : str, default is Undefined, optional
        The reason that a renewal request was unsuccessful or is pending
    updatedAt : str, default is Undefined, optional
        updated at
    """


    renewalStatus?: str

    renewalStatusReason?: str

    updatedAt?: str




schema AcmAwsmUpboundIoV1beta1CertificateAtProviderValidationOption:
    r"""
    certificate v1beta1 at provider validation option

    Attributes
    ----------
    domainName : str, default is Undefined, optional
        Fully qualified domain name (FQDN) in the certificate.
    validationDomain : str, default is Undefined, optional
        Domain name that you want ACM to use to send you validation emails. This domain name is the suffix of the email addresses that you want ACM to use. This must be the same as the domain_name value or a superdomain of the domain_name value. For example, if you request a certificate for "testing.example.com", you can specify "example.com" for this value.
    """


    domainName?: str

    validationDomain?: str




schema AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnRef:
    r"""
    Reference to a CertificateAuthority in acmpca to populate certificateAuthorityArn.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnRefPolicy




schema AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnSelector:
    r"""
    Selector for a CertificateAuthority in acmpca to populate certificateAuthorityArn.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnSelectorPolicy




schema AcmAwsmUpboundIoV1beta1CertificateSpecForProviderOptions:
    r"""
    Configuration block used to set certificate options. Detailed below.

    Attributes
    ----------
    certificateTransparencyLoggingPreference : str, default is Undefined, optional
        Whether certificate details should be added to a certificate transparency log. Valid values are ENABLED or DISABLED. See https://docs.aws.amazon.com/acm/latest/userguide/acm-concepts.html#concept-transparency for more details.
    export : str, default is Undefined, optional
        Whether the certificate can be exported. Valid values are ENABLED or DISABLED (default). Note Issuing an exportable certificate is subject to additional charges. See AWS Certificate Manager pricing for more details.
    """


    certificateTransparencyLoggingPreference?: str

    export?: str




schema AcmAwsmUpboundIoV1beta1CertificateSpecForProviderPrivateKeySecretRef:
    r"""
    Certificate's PEM-formatted private key. Conflicts with private_key_wo.

    Attributes
    ----------
    key : str, default is Undefined, required
        key
    name : str, default is Undefined, required
        Name of the secret.
    """


    key: str

    name: str




schema AcmAwsmUpboundIoV1beta1CertificateSpecForProviderValidationOption:
    r"""
    certificate v1beta1 for provider validation option

    Attributes
    ----------
    domainName : str, default is Undefined, optional
        Fully qualified domain name (FQDN) in the certificate.
    validationDomain : str, default is Undefined, optional
        Domain name that you want ACM to use to send you validation emails. This domain name is the suffix of the email addresses that you want ACM to use. This must be the same as the domain_name value or a superdomain of the domain_name value. For example, if you request a certificate for "testing.example.com", you can specify "example.com" for this value.
    """


    domainName?: str

    validationDomain?: str




schema AcmAwsmUpboundIoV1beta1CertificateSpecForProvider:
    r"""
    certificate v1beta1 spec for provider

    Attributes
    ----------
    certificateAuthorityArn : str, default is Undefined, optional
        ARN of an ACM PCA
    certificateAuthorityArnRef : AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnRef, default is Undefined, optional
        certificate authority arn ref
    certificateAuthorityArnSelector : AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnSelector, default is Undefined, optional
        certificate authority arn selector
    certificateBody : str, default is Undefined, optional
        Certificate's PEM-formatted public key
    certificateChain : str, default is Undefined, optional
        Certificate's PEM-formatted chain
    domainName : str, default is Undefined, optional
        Domain name for which the certificate should be issued
    earlyRenewalDuration : str, default is Undefined, optional
        Amount of time to start automatic renewal process before expiration.
        Has no effect if less than 60 days.
        Represented by either
        a subset of RFC 3339 duration supporting years, months, and days (e.g., P90D),
        or a string such as 2160h.
    keyAlgorithm : str, default is Undefined, optional
        Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data. See ACM Certificate characteristics for more details.
    options : AcmAwsmUpboundIoV1beta1CertificateSpecForProviderOptions, default is Undefined, optional
        options
    privateKeySecretRef : AcmAwsmUpboundIoV1beta1CertificateSpecForProviderPrivateKeySecretRef, default is Undefined, optional
        private key secret ref
    privateKeyWo : str, default is Undefined, optional
        Certificate's PEM-formatted private key. Conflicts with private_key. If set, requires private_key_wo_version to be set.
    privateKeyWoVersion : float, default is Undefined, optional
        Required when private_key_wo is set. Changing this value triggers an update to private_key_wo.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    subjectAlternativeNames : [str], default is Undefined, optional
        Set of domains that should be SANs in the issued certificate.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    validationMethod : str, default is Undefined, optional
        Which method to use for validation. DNS or EMAIL are valid.
    validationOption : [AcmAwsmUpboundIoV1beta1CertificateSpecForProviderValidationOption], default is Undefined, optional
        Configuration block used to specify information about the initial validation of each domain name. Detailed below.
    """


    certificateAuthorityArn?: str

    certificateAuthorityArnRef?: AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnRef

    certificateAuthorityArnSelector?: AcmAwsmUpboundIoV1beta1CertificateSpecForProviderCertificateAuthorityArnSelector

    certificateBody?: str

    certificateChain?: str

    domainName?: str

    earlyRenewalDuration?: str

    keyAlgorithm?: str

    options?: AcmAwsmUpboundIoV1beta1CertificateSpecForProviderOptions

    privateKeySecretRef?: AcmAwsmUpboundIoV1beta1CertificateSpecForProviderPrivateKeySecretRef

    privateKeyWo?: str

    privateKeyWoVersion?: float

    region: str

    subjectAlternativeNames?: [str]

    tags?: {str:str}

    validationMethod?: str

    validationOption?: [AcmAwsmUpboundIoV1beta1CertificateSpecForProviderValidationOption]




schema AcmAwsmUpboundIoV1beta1CertificateStatusAtProvider:
    r"""
    certificate v1beta1 status at provider

    Attributes
    ----------
    arn : str, default is Undefined, optional
        ARN of the certificate
    certificateAuthorityArn : str, default is Undefined, optional
        ARN of an ACM PCA
    certificateBody : str, default is Undefined, optional
        Certificate's PEM-formatted public key
    certificateChain : str, default is Undefined, optional
        Certificate's PEM-formatted chain
    domainName : str, default is Undefined, optional
        Domain name for which the certificate should be issued
    domainValidationOptions : [AcmAwsmUpboundIoV1beta1CertificateAtProviderDomainValidationOptions], default is Undefined, optional
        Set of domain validation objects which can be used to complete certificate validation.
        Can have more than one element, e.g., if SANs are defined.
        Only set if DNS-validation was used.
    earlyRenewalDuration : str, default is Undefined, optional
        Amount of time to start automatic renewal process before expiration.
        Has no effect if less than 60 days.
        Represented by either
        a subset of RFC 3339 duration supporting years, months, and days (e.g., P90D),
        or a string such as 2160h.
    id : str, default is Undefined, optional
        ARN of the certificate
    keyAlgorithm : str, default is Undefined, optional
        Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data. See ACM Certificate characteristics for more details.
    notAfter : str, default is Undefined, optional
        Expiration date and time of the certificate.
    notBefore : str, default is Undefined, optional
        Start of the validity period of the certificate.
    options : AcmAwsmUpboundIoV1beta1CertificateAtProviderOptions, default is Undefined, optional
        options
    pendingRenewal : bool, default is Undefined, optional
        true if a Private certificate eligible for managed renewal is within the early_renewal_duration period.
    privateKeyWo : str, default is Undefined, optional
        Certificate's PEM-formatted private key. Conflicts with private_key. If set, requires private_key_wo_version to be set.
    privateKeyWoVersion : float, default is Undefined, optional
        Required when private_key_wo is set. Changing this value triggers an update to private_key_wo.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    renewalEligibility : str, default is Undefined, optional
        Whether the certificate is eligible for managed renewal.
    renewalSummary : [AcmAwsmUpboundIoV1beta1CertificateAtProviderRenewalSummary], default is Undefined, optional
        Contains information about the status of ACM's managed renewal for the certificate.
    status : str, default is Undefined, optional
        Status of the certificate.
    subjectAlternativeNames : [str], default is Undefined, optional
        Set of domains that should be SANs in the issued certificate.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    tagsAll : {str:str}, default is Undefined, optional
        Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block.
    $type : str, default is Undefined, optional
        Source of the certificate.
    validationEmails : [str], default is Undefined, optional
        List of addresses that received a validation email. Only set if EMAIL validation was used.
    validationMethod : str, default is Undefined, optional
        Which method to use for validation. DNS or EMAIL are valid.
    validationOption : [AcmAwsmUpboundIoV1beta1CertificateAtProviderValidationOption], default is Undefined, optional
        Configuration block used to specify information about the initial validation of each domain name. Detailed below.
    """


    arn?: str

    certificateAuthorityArn?: str

    certificateBody?: str

    certificateChain?: str

    domainName?: str

    domainValidationOptions?: [AcmAwsmUpboundIoV1beta1CertificateAtProviderDomainValidationOptions]

    earlyRenewalDuration?: str

    id?: str

    keyAlgorithm?: str

    notAfter?: str

    notBefore?: str

    options?: AcmAwsmUpboundIoV1beta1CertificateAtProviderOptions

    pendingRenewal?: bool

    privateKeyWo?: str

    privateKeyWoVersion?: float

    region?: str

    renewalEligibility?: str

    renewalSummary?: [AcmAwsmUpboundIoV1beta1CertificateAtProviderRenewalSummary]

    status?: str

    subjectAlternativeNames?: [str]

    tags?: {str:str}

    tagsAll?: {str:str}

    $type?: str

    validationEmails?: [str]

    validationMethod?: str

    validationOption?: [AcmAwsmUpboundIoV1beta1CertificateAtProviderValidationOption]

schema AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnRef:
    r"""
    Reference to a Certificate in acm to populate certificateArn.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnRefPolicy




schema AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnSelector:
    r"""
    Selector for a Certificate in acm to populate certificateArn.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnSelectorPolicy




schema AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProvider:
    r"""
    certificate validation v1beta1 spec for provider

    Attributes
    ----------
    certificateArn : str, default is Undefined, optional
        ARN of the certificate that is being validated.
    certificateArnRef : AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnRef, default is Undefined, optional
        certificate arn ref
    certificateArnSelector : AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnSelector, default is Undefined, optional
        certificate arn selector
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    validationRecordFqdns : [str], default is Undefined, optional
        List of FQDNs that implement the validation. Only valid for DNS validation method ACM certificates. If this is set, the resource can implement additional sanity checks and has an explicit dependency on the resource that is implementing the validation
    """


    certificateArn?: str

    certificateArnRef?: AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnRef

    certificateArnSelector?: AcmAwsmUpboundIoV1beta1CertificateValidationSpecForProviderCertificateArnSelector

    region: str

    validationRecordFqdns?: [str]




schema AcmAwsmUpboundIoV1beta1CertificateValidationStatusAtProvider:
    r"""
    certificate validation v1beta1 status at provider

    Attributes
    ----------
    certificateArn : str, default is Undefined, optional
        ARN of the certificate that is being validated.
    id : str, default is Undefined, optional
        Time at which the certificate was issued
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    validationRecordFqdns : [str], default is Undefined, optional
        List of FQDNs that implement the validation. Only valid for DNS validation method ACM certificates. If this is set, the resource can implement additional sanity checks and has an explicit dependency on the resource that is implementing the validation
    """


    certificateArn?: str

    id?: str

    region?: str

    validationRecordFqdns?: [str]

schema Route53AwsmUpboundIoV1beta1RecordAtProviderAlias:
    r"""
    An alias block. Conflicts with ttl & records.
    Documented below.

    Attributes
    ----------
    evaluateTargetHealth : bool, default is Undefined, optional
        Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. Some resources have special requirements, see related part of documentation.
    name : str, default is Undefined, optional
        The name of the record.
    zoneId : str, default is Undefined, optional
        The ID of the hosted zone to contain this record.
    """


    evaluateTargetHealth?: bool

    name?: str

    zoneId?: str




schema Route53AwsmUpboundIoV1beta1RecordAtProviderCidrRoutingPolicy:
    r"""
    A block indicating a routing policy based on the IP network ranges of requestors. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    collectionId : str, default is Undefined, optional
        The CIDR collection ID. See the aws_route53_cidr_collection resource for more details.
    locationName : str, default is Undefined, optional
        The CIDR collection location name. See the aws_route53_cidr_location resource for more details. A location_name with an asterisk "*" can be used to create a default CIDR record. collection_id is still required for default record.
    """


    collectionId?: str

    locationName?: str




schema Route53AwsmUpboundIoV1beta1RecordAtProviderFailoverRoutingPolicy:
    r"""
    A block indicating the routing behavior when associated health check fails. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    $type : str, default is Undefined, optional
        The record type. Valid values are A, AAAA, CAA, CNAME, DS, HTTPS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, SSHFP, SVCB, TLSA, and TXT.
    """


    $type?: str




schema Route53AwsmUpboundIoV1beta1RecordAtProviderGeolocationRoutingPolicy:
    r"""
    A block indicating a routing policy based on the geolocation of the requestor. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    continent : str, default is Undefined, optional
        A two-letter continent code. See http://docs.aws.amazon.com/Route53/latest/APIReference/API_GetGeoLocation.html for code details. Either continent or country must be specified.
    country : str, default is Undefined, optional
        A two-character country code or * to indicate a default resource record set.
    subdivision : str, default is Undefined, optional
        A subdivision code for a country.
    """


    continent?: str

    country?: str

    subdivision?: str




schema Route53AwsmUpboundIoV1beta1RecordAtProviderGeoproximityRoutingPolicy:
    r"""
    A block indicating a routing policy based on the geoproximity of the requestor. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    awsRegion : str, default is Undefined, optional
        A AWS region where the resource is present.
    bias : float, default is Undefined, optional
        Route more traffic or less traffic to the resource by specifying a value ranges between -90 to 90. See https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-geoproximity.html for bias details.
    coordinates : [Route53AwsmUpboundIoV1beta1RecordAtProviderGeoproximityRoutingPolicyCoordinates], default is Undefined, optional
        Specify latitude and longitude for routing traffic to non-AWS resources.
    localZoneGroup : str, default is Undefined, optional
        A AWS local zone group where the resource is present. See https://docs.aws.amazon.com/local-zones/latest/ug/available-local-zones.html for local zone group list.
    """


    awsRegion?: str

    bias?: float

    coordinates?: [Route53AwsmUpboundIoV1beta1RecordAtProviderGeoproximityRoutingPolicyCoordinates]

    localZoneGroup?: str




schema Route53AwsmUpboundIoV1beta1RecordAtProviderGeoproximityRoutingPolicyCoordinates:
    r"""
    record v1beta1 at provider geoproximity routing policy coordinates

    Attributes
    ----------
    latitude : str, default is Undefined, optional
        latitude
    longitude : str, default is Undefined, optional
        longitude
    """


    latitude?: str

    longitude?: str




schema Route53AwsmUpboundIoV1beta1RecordAtProviderLatencyRoutingPolicy:
    r"""
    A block indicating a routing policy based on the latency between the requestor and an AWS region. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    region : str, default is Undefined, optional
        An AWS region from which to measure latency. See http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-latency
    """


    region?: str




schema Route53AwsmUpboundIoV1beta1RecordAtProviderWeightedRoutingPolicy:
    r"""
    A block indicating a weighted routing policy. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    weight : float, default is Undefined, optional
        A numeric value indicating the relative weight of the record. See http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted.
    """


    weight?: float




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderAlias:
    r"""
    An alias block. Conflicts with ttl & records.
    Documented below.

    Attributes
    ----------
    evaluateTargetHealth : bool, default is Undefined, optional
        Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. Some resources have special requirements, see related part of documentation.
    name : str, default is Undefined, optional
        The name of the record.
    zoneId : str, default is Undefined, optional
        The ID of the hosted zone to contain this record.
    """


    evaluateTargetHealth?: bool

    name?: str

    zoneId?: str




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderCidrRoutingPolicy:
    r"""
    A block indicating a routing policy based on the IP network ranges of requestors. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    collectionId : str, default is Undefined, optional
        The CIDR collection ID. See the aws_route53_cidr_collection resource for more details.
    locationName : str, default is Undefined, optional
        The CIDR collection location name. See the aws_route53_cidr_location resource for more details. A location_name with an asterisk "*" can be used to create a default CIDR record. collection_id is still required for default record.
    """


    collectionId?: str

    locationName?: str




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderFailoverRoutingPolicy:
    r"""
    A block indicating the routing behavior when associated health check fails. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    $type : str, default is Undefined, optional
        The record type. Valid values are A, AAAA, CAA, CNAME, DS, HTTPS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, SSHFP, SVCB, TLSA, and TXT.
    """


    $type?: str




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderGeolocationRoutingPolicy:
    r"""
    A block indicating a routing policy based on the geolocation of the requestor. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    continent : str, default is Undefined, optional
        A two-letter continent code. See http://docs.aws.amazon.com/Route53/latest/APIReference/API_GetGeoLocation.html for code details. Either continent or country must be specified.
    country : str, default is Undefined, optional
        A two-character country code or * to indicate a default resource record set.
    subdivision : str, default is Undefined, optional
        A subdivision code for a country.
    """


    continent?: str

    country?: str

    subdivision?: str




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderGeoproximityRoutingPolicy:
    r"""
    A block indicating a routing policy based on the geoproximity of the requestor. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    awsRegion : str, default is Undefined, optional
        A AWS region where the resource is present.
    bias : float, default is Undefined, optional
        Route more traffic or less traffic to the resource by specifying a value ranges between -90 to 90. See https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-geoproximity.html for bias details.
    coordinates : [Route53AwsmUpboundIoV1beta1RecordSpecForProviderGeoproximityRoutingPolicyCoordinates], default is Undefined, optional
        Specify latitude and longitude for routing traffic to non-AWS resources.
    localZoneGroup : str, default is Undefined, optional
        A AWS local zone group where the resource is present. See https://docs.aws.amazon.com/local-zones/latest/ug/available-local-zones.html for local zone group list.
    """


    awsRegion?: str

    bias?: float

    coordinates?: [Route53AwsmUpboundIoV1beta1RecordSpecForProviderGeoproximityRoutingPolicyCoordinates]

    localZoneGroup?: str




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDRef:
    r"""
    Reference to a HealthCheck in route53 to populate healthCheckId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDRefPolicy




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDSelector:
    r"""
    Selector for a HealthCheck in route53 to populate healthCheckId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDSelectorPolicy




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderLatencyRoutingPolicy:
    r"""
    A block indicating a routing policy based on the latency between the requestor and an AWS region. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    region : str, default is Undefined, required
        An AWS region from which to measure latency. See http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-latency
    """


    region: str




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsRefs:
    r"""
    A NamespacedReference to a named object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsRefsPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsRefsPolicy




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsSelector:
    r"""
    Selector for a list of EIP in ec2 to populate records.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsSelectorPolicy




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderWeightedRoutingPolicy:
    r"""
    A block indicating a weighted routing policy. Conflicts with any other routing policy. Documented below.

    Attributes
    ----------
    weight : float, default is Undefined, optional
        A numeric value indicating the relative weight of the record. See http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted.
    """


    weight?: float




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDRef:
    r"""
    Reference to a Zone in route53 to populate zoneId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDRefPolicy




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDSelector:
    r"""
    Selector for a Zone in route53 to populate zoneId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDSelectorPolicy




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderGeoproximityRoutingPolicyCoordinates:
    r"""
    record v1beta1 geoproximity routing policy coordinates

    Attributes
    ----------
    latitude : str, default is Undefined, optional
        latitude
    longitude : str, default is Undefined, optional
        longitude
    """


    latitude?: str

    longitude?: str




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsRefsPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Route53AwsmUpboundIoV1beta1RecordSpecForProvider:
    r"""
    record v1beta1 spec for provider

    Attributes
    ----------
    alias : Route53AwsmUpboundIoV1beta1RecordSpecForProviderAlias, default is Undefined, optional
        alias
    allowOverwrite : bool, default is Undefined, optional
        false by default. This configuration is not recommended for most environments.
    cidrRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderCidrRoutingPolicy, default is Undefined, optional
        cidr routing policy
    failoverRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderFailoverRoutingPolicy, default is Undefined, optional
        failover routing policy
    geolocationRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderGeolocationRoutingPolicy, default is Undefined, optional
        geolocation routing policy
    geoproximityRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderGeoproximityRoutingPolicy, default is Undefined, optional
        geoproximity routing policy
    healthCheckId : str, default is Undefined, optional
        The health check the record should be associated with.
    healthCheckIdRef : Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDRef, default is Undefined, optional
        health check Id ref
    healthCheckIdSelector : Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDSelector, default is Undefined, optional
        health check Id selector
    latencyRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderLatencyRoutingPolicy, default is Undefined, optional
        latency routing policy
    multivalueAnswerRoutingPolicy : bool, default is Undefined, optional
        Set to true to indicate a multivalue answer routing policy. Conflicts with any other routing policy.
    name : str, default is Undefined, optional
        The name of the record.
    records : [str], default is Undefined, optional
        A string list of records.g., "first255characters\"\"morecharacters").
    recordsRefs : [Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsRefs], default is Undefined, optional
        References to EIP in ec2 to populate records.
    recordsSelector : Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsSelector, default is Undefined, optional
        records selector
    setIdentifier : str, default is Undefined, optional
        Unique identifier to differentiate records with routing policies from one another. Required if using cidr_routing_policy, failover_routing_policy, geolocation_routing_policy,geoproximity_routing_policy, latency_routing_policy, multivalue_answer_routing_policy, or weighted_routing_policy.
    ttl : float, default is Undefined, optional
        The TTL of the record.
    $type : str, default is Undefined, optional
        The record type. Valid values are A, AAAA, CAA, CNAME, DS, HTTPS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, SSHFP, SVCB, TLSA, and TXT.
    weightedRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordSpecForProviderWeightedRoutingPolicy, default is Undefined, optional
        weighted routing policy
    zoneId : str, default is Undefined, optional
        The ID of the hosted zone to contain this record.
    zoneIdRef : Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDRef, default is Undefined, optional
        zone Id ref
    zoneIdSelector : Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDSelector, default is Undefined, optional
        zone Id selector
    """


    alias?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderAlias

    allowOverwrite?: bool

    cidrRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderCidrRoutingPolicy

    failoverRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderFailoverRoutingPolicy

    geolocationRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderGeolocationRoutingPolicy

    geoproximityRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderGeoproximityRoutingPolicy

    healthCheckId?: str

    healthCheckIdRef?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDRef

    healthCheckIdSelector?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderHealthCheckIDSelector

    latencyRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderLatencyRoutingPolicy

    multivalueAnswerRoutingPolicy?: bool

    name?: str

    records?: [str]

    recordsRefs?: [Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsRefs]

    recordsSelector?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderRecordsSelector

    setIdentifier?: str

    ttl?: float

    $type?: str

    weightedRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderWeightedRoutingPolicy

    zoneId?: str

    zoneIdRef?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDRef

    zoneIdSelector?: Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDSelector




schema Route53AwsmUpboundIoV1beta1RecordStatusAtProvider:
    r"""
    record v1beta1 status at provider

    Attributes
    ----------
    alias : Route53AwsmUpboundIoV1beta1RecordAtProviderAlias, default is Undefined, optional
        alias
    allowOverwrite : bool, default is Undefined, optional
        false by default. This configuration is not recommended for most environments.
    cidrRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordAtProviderCidrRoutingPolicy, default is Undefined, optional
        cidr routing policy
    failoverRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordAtProviderFailoverRoutingPolicy, default is Undefined, optional
        failover routing policy
    fqdn : str, default is Undefined, optional
        FQDN built using the zone domain and name. Does not include trailing ..
    geolocationRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordAtProviderGeolocationRoutingPolicy, default is Undefined, optional
        geolocation routing policy
    geoproximityRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordAtProviderGeoproximityRoutingPolicy, default is Undefined, optional
        geoproximity routing policy
    healthCheckId : str, default is Undefined, optional
        The health check the record should be associated with.
    id : str, default is Undefined, optional
        id
    latencyRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordAtProviderLatencyRoutingPolicy, default is Undefined, optional
        latency routing policy
    multivalueAnswerRoutingPolicy : bool, default is Undefined, optional
        Set to true to indicate a multivalue answer routing policy. Conflicts with any other routing policy.
    name : str, default is Undefined, optional
        The name of the record.
    records : [str], default is Undefined, optional
        A string list of records.g., "first255characters\"\"morecharacters").
    setIdentifier : str, default is Undefined, optional
        Unique identifier to differentiate records with routing policies from one another. Required if using cidr_routing_policy, failover_routing_policy, geolocation_routing_policy,geoproximity_routing_policy, latency_routing_policy, multivalue_answer_routing_policy, or weighted_routing_policy.
    ttl : float, default is Undefined, optional
        The TTL of the record.
    $type : str, default is Undefined, optional
        The record type. Valid values are A, AAAA, CAA, CNAME, DS, HTTPS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, SSHFP, SVCB, TLSA, and TXT.
    weightedRoutingPolicy : Route53AwsmUpboundIoV1beta1RecordAtProviderWeightedRoutingPolicy, default is Undefined, optional
        weighted routing policy
    zoneId : str, default is Undefined, optional
        The ID of the hosted zone to contain this record.
    """


    alias?: Route53AwsmUpboundIoV1beta1RecordAtProviderAlias

    allowOverwrite?: bool

    cidrRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordAtProviderCidrRoutingPolicy

    failoverRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordAtProviderFailoverRoutingPolicy

    fqdn?: str

    geolocationRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordAtProviderGeolocationRoutingPolicy

    geoproximityRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordAtProviderGeoproximityRoutingPolicy

    healthCheckId?: str

    id?: str

    latencyRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordAtProviderLatencyRoutingPolicy

    multivalueAnswerRoutingPolicy?: bool

    name?: str

    records?: [str]

    setIdentifier?: str

    ttl?: float

    $type?: str

    weightedRoutingPolicy?: Route53AwsmUpboundIoV1beta1RecordAtProviderWeightedRoutingPolicy

    zoneId?: str




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema Route53AwsmUpboundIoV1beta1RecordSpecForProviderZoneIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"

schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderCacheTagConfig:
    r"""
    Cache tag configuration block for cache tag extraction from origin responses (maximum one). See the AWS documentation for more information about cache tags.

    Attributes
    ----------
    headerName : str, default is Undefined, optional
        Name of the HTTP header to extract cache tags. The header value must contain comma-separated tag values.
    """


    headerName?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderConnectionFunctionAssociation:
    r"""
    A connection function association configuration block (maximum one).

    Attributes
    ----------
    id : str, default is Undefined, optional
        Identifier of the connection function to associate with the distribution.
    """


    id?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderCustomErrorResponse:
    r"""
    distribution v1beta1 at provider custom error response

    Attributes
    ----------
    errorCachingMinTtl : float, default is Undefined, optional
        Minimum amount of time you want HTTP error codes to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated.
    errorCode : float, default is Undefined, optional
        4xx or 5xx HTTP status code that you want to customize.
    responseCode : float, default is Undefined, optional
        HTTP status code that you want CloudFront to return with the custom error page to the viewer.
    responsePagePath : str, default is Undefined, optional
        Path of the custom error page (for example, /custom_404.html).
    """


    errorCachingMinTtl?: float

    errorCode?: float

    responseCode?: float

    responsePagePath?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehavior:
    r"""
    Default cache behavior for this distribution (maximum one). Requires either cache_policy_id (preferred) or forwarded_values (deprecated) be set.

    Attributes
    ----------
    allowedMethods : [str], default is Undefined, optional
        Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin.
    cachePolicyId : str, default is Undefined, optional
        Unique identifier of the cache policy that is attached to the cache behavior. If configuring the default_cache_behavior either cache_policy_id or forwarded_values must be set.
    cachedMethods : [str], default is Undefined, optional
        Controls whether CloudFront caches the response to requests using the specified HTTP methods.
    compress : bool, default is Undefined, optional
        Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header (default: false).
    defaultTtl : float, default is Undefined, optional
        Default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header. The TTL defined in Cache Policy overrides this configuration.
    fieldLevelEncryptionId : str, default is Undefined, optional
        Field level encryption configuration ID.
    forwardedValues : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorForwardedValues, default is Undefined, optional
        forwarded values
    functionAssociation : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorFunctionAssociation], default is Undefined, optional
        A config block that triggers a cloudfront function with specific actions (maximum 2).
    grpcConfig : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorGrpcConfig, default is Undefined, optional
        grpc config
    lambdaFunctionAssociation : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorLambdaFunctionAssociation], default is Undefined, optional
        A config block that triggers a lambda function with specific actions (maximum 4).
    maxTtl : float, default is Undefined, optional
        Maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers. The TTL defined in Cache Policy overrides this configuration.
    minTtl : float, default is Undefined, optional
        Minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to 0 seconds. The TTL defined in Cache Policy overrides this configuration.
    originRequestPolicyId : str, default is Undefined, optional
        Unique identifier of the origin request policy that is attached to the behavior.
    realtimeLogConfigArn : str, default is Undefined, optional
        ARN of the real-time log configuration that is attached to this cache behavior.
    responseHeadersPolicyId : str, default is Undefined, optional
        Identifier for a response headers policy.
    smoothStreaming : bool, default is Undefined, optional
        Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior.
    targetOriginId : str, default is Undefined, optional
        Value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern either for a cache behavior or for the default cache behavior.
    trustedKeyGroups : [str], default is Undefined, optional
        List of key group IDs that CloudFront can use to validate signed URLs or signed cookies. See the CloudFront User Guide for more information about this feature.
    trustedSigners : [str], default is Undefined, optional
        List of AWS account IDs (or self) that you want to allow to create signed URLs for private content. See the CloudFront User Guide for more information about this feature.
    viewerProtocolPolicy : str, default is Undefined, optional
        Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https.
    """


    allowedMethods?: [str]

    cachePolicyId?: str

    cachedMethods?: [str]

    compress?: bool

    defaultTtl?: float

    fieldLevelEncryptionId?: str

    forwardedValues?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorForwardedValues

    functionAssociation?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorFunctionAssociation]

    grpcConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorGrpcConfig

    lambdaFunctionAssociation?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorLambdaFunctionAssociation]

    maxTtl?: float

    minTtl?: float

    originRequestPolicyId?: str

    realtimeLogConfigArn?: str

    responseHeadersPolicyId?: str

    smoothStreaming?: bool

    targetOriginId?: str

    trustedKeyGroups?: [str]

    trustedSigners?: [str]

    viewerProtocolPolicy?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorForwardedValues:
    r"""
    The forwarded values configuration that specifies how CloudFront handles query strings, cookies and headers (maximum one).

    Attributes
    ----------
    cookies : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorForwardedValuesCookies, default is Undefined, optional
        cookies
    headers : [str], default is Undefined, optional
        Headers, if any, that you want CloudFront to vary upon for this cache behavior. Specify * to include all headers.
    queryString : bool, default is Undefined, optional
        Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior.
    queryStringCacheKeys : [str], default is Undefined, optional
        When specified, along with a value of true for query_string, all query strings are forwarded, however only the query string keys listed in this argument are cached. When omitted with a value of true for query_string, all query string keys are cached.
    """


    cookies?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorForwardedValuesCookies

    headers?: [str]

    queryString?: bool

    queryStringCacheKeys?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorForwardedValuesCookies:
    r"""
    The forwarded values cookies that specifies how CloudFront handles cookies (maximum one).

    Attributes
    ----------
    forward : str, default is Undefined, optional
        Whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior. You can specify all, none or whitelist. If whitelist, you must include the subsequent whitelisted_names.
    whitelistedNames : [str], default is Undefined, optional
        If you have specified whitelist to forward, the whitelisted cookies that you want CloudFront to forward to your origin.
    """


    forward?: str

    whitelistedNames?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorFunctionAssociation:
    r"""
    distribution v1beta1 at provider default cache behavior function association

    Attributes
    ----------
    eventType : str, default is Undefined, optional
        Specific event to trigger this function. Valid values: viewer-request, origin-request, viewer-response, origin-response.
    functionArn : str, default is Undefined, optional
        ARN of the CloudFront function.
    """


    eventType?: str

    functionArn?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorGrpcConfig:
    r"""
    A config block that sets the grpc config.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Whether the distribution is enabled to accept end user requests for content.
    """


    enabled?: bool




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehaviorLambdaFunctionAssociation:
    r"""
    distribution v1beta1 at provider default cache behavior lambda function association

    Attributes
    ----------
    eventType : str, default is Undefined, optional
        Specific event to trigger this function. Valid values: viewer-request, origin-request, viewer-response, origin-response.
    includeBody : bool, default is Undefined, optional
        When set to true it exposes the request body to the lambda function. Defaults to false. Valid values: true, false.
    lambdaArn : str, default is Undefined, optional
        ARN of the Lambda function.
    """


    eventType?: str

    includeBody?: bool

    lambdaArn?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderLoggingConfig:
    r"""
    The logging configuration that controls how logs are written to your distribution (maximum one). AWS provides two versions of access logs for CloudFront: Legacy and v2. This argument configures legacy version standard logs.

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        Amazon S3 bucket for V1 logging where access logs are stored, for example, myawslogbucket.s3.amazonaws.com. V1 logging is enabled when this argument is specified. The bucket must have correct ACL attached with "FULL_CONTROL" permission for "awslogsdelivery" account (Canonical ID: "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0") for log transfer to work.
    includeCookies : bool, default is Undefined, optional
        Whether to include cookies in access logs (default: false). This argument applies to both V1 and V2 logging.
    prefix : str, default is Undefined, optional
        Prefix added to the access log file names for V1 logging, for example, myprefix/. This argument is effective only when V1 logging is enabled.
    """


    bucket?: str

    includeCookies?: bool

    prefix?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehavior:
    r"""
    distribution v1beta1 at provider ordered cache behavior

    Attributes
    ----------
    allowedMethods : [str], default is Undefined, optional
        Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin.
    cachePolicyId : str, default is Undefined, optional
        Unique identifier of the cache policy that is attached to the cache behavior. If configuring the default_cache_behavior either cache_policy_id or forwarded_values must be set.
    cachedMethods : [str], default is Undefined, optional
        Controls whether CloudFront caches the response to requests using the specified HTTP methods.
    compress : bool, default is Undefined, optional
        Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header (default: false).
    defaultTtl : float, default is Undefined, optional
        Default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header. The TTL defined in Cache Policy overrides this configuration.
    fieldLevelEncryptionId : str, default is Undefined, optional
        Field level encryption configuration ID.
    forwardedValues : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorForwardedValues, default is Undefined, optional
        forwarded values
    functionAssociation : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorFunctionAssociation], default is Undefined, optional
        A config block that triggers a cloudfront function with specific actions (maximum 2).
    grpcConfig : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorGrpcConfig, default is Undefined, optional
        grpc config
    lambdaFunctionAssociation : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorLambdaFunctionAssociation], default is Undefined, optional
        A config block that triggers a lambda function with specific actions (maximum 4).
    maxTtl : float, default is Undefined, optional
        Maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers. The TTL defined in Cache Policy overrides this configuration.
    minTtl : float, default is Undefined, optional
        Minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to 0 seconds. The TTL defined in Cache Policy overrides this configuration.
    originRequestPolicyId : str, default is Undefined, optional
        Unique identifier of the origin request policy that is attached to the behavior.
    pathPattern : str, default is Undefined, optional
        Pattern (for example, images/*.jpg) that specifies which requests you want this cache behavior to apply to.
    realtimeLogConfigArn : str, default is Undefined, optional
        ARN of the real-time log configuration that is attached to this cache behavior.
    responseHeadersPolicyId : str, default is Undefined, optional
        Identifier for a response headers policy.
    smoothStreaming : bool, default is Undefined, optional
        Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior.
    targetOriginId : str, default is Undefined, optional
        Value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern either for a cache behavior or for the default cache behavior.
    trustedKeyGroups : [str], default is Undefined, optional
        List of key group IDs that CloudFront can use to validate signed URLs or signed cookies. See the CloudFront User Guide for more information about this feature.
    trustedSigners : [str], default is Undefined, optional
        List of AWS account IDs (or self) that you want to allow to create signed URLs for private content. See the CloudFront User Guide for more information about this feature.
    viewerProtocolPolicy : str, default is Undefined, optional
        Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https.
    """


    allowedMethods?: [str]

    cachePolicyId?: str

    cachedMethods?: [str]

    compress?: bool

    defaultTtl?: float

    fieldLevelEncryptionId?: str

    forwardedValues?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorForwardedValues

    functionAssociation?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorFunctionAssociation]

    grpcConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorGrpcConfig

    lambdaFunctionAssociation?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorLambdaFunctionAssociation]

    maxTtl?: float

    minTtl?: float

    originRequestPolicyId?: str

    pathPattern?: str

    realtimeLogConfigArn?: str

    responseHeadersPolicyId?: str

    smoothStreaming?: bool

    targetOriginId?: str

    trustedKeyGroups?: [str]

    trustedSigners?: [str]

    viewerProtocolPolicy?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorForwardedValues:
    r"""
    The forwarded values configuration that specifies how CloudFront handles query strings, cookies and headers (maximum one).

    Attributes
    ----------
    cookies : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorForwardedValuesCookies, default is Undefined, optional
        cookies
    headers : [str], default is Undefined, optional
        Headers, if any, that you want CloudFront to vary upon for this cache behavior. Specify * to include all headers.
    queryString : bool, default is Undefined, optional
        Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior.
    queryStringCacheKeys : [str], default is Undefined, optional
        When specified, along with a value of true for query_string, all query strings are forwarded, however only the query string keys listed in this argument are cached. When omitted with a value of true for query_string, all query string keys are cached.
    """


    cookies?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorForwardedValuesCookies

    headers?: [str]

    queryString?: bool

    queryStringCacheKeys?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorForwardedValuesCookies:
    r"""
    The forwarded values cookies that specifies how CloudFront handles cookies (maximum one).

    Attributes
    ----------
    forward : str, default is Undefined, optional
        Whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior. You can specify all, none or whitelist. If whitelist, you must include the subsequent whitelisted_names.
    whitelistedNames : [str], default is Undefined, optional
        If you have specified whitelist to forward, the whitelisted cookies that you want CloudFront to forward to your origin.
    """


    forward?: str

    whitelistedNames?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorFunctionAssociation:
    r"""
    distribution v1beta1 at provider ordered cache behavior function association

    Attributes
    ----------
    eventType : str, default is Undefined, optional
        Specific event to trigger this function. Valid values: viewer-request, origin-request, viewer-response, origin-response.
    functionArn : str, default is Undefined, optional
        ARN of the CloudFront function.
    """


    eventType?: str

    functionArn?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorGrpcConfig:
    r"""
    A config block that sets the grpc config.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Whether the distribution is enabled to accept end user requests for content.
    """


    enabled?: bool




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehaviorLambdaFunctionAssociation:
    r"""
    distribution v1beta1 at provider ordered cache behavior lambda function association

    Attributes
    ----------
    eventType : str, default is Undefined, optional
        Specific event to trigger this function. Valid values: viewer-request, origin-request, viewer-response, origin-response.
    includeBody : bool, default is Undefined, optional
        When set to true it exposes the request body to the lambda function. Defaults to false. Valid values: true, false.
    lambdaArn : str, default is Undefined, optional
        ARN of the Lambda function.
    """


    eventType?: str

    includeBody?: bool

    lambdaArn?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrigin:
    r"""
    distribution v1beta1 at provider origin

    Attributes
    ----------
    connectionAttempts : float, default is Undefined, optional
        Number of times that CloudFront attempts to connect to the origin. Must be between 1-3. Defaults to 3.
    connectionTimeout : float, default is Undefined, optional
        Number of seconds that CloudFront waits when trying to establish a connection to the origin. Must be between 1-10. Defaults to 10.
    customHeader : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginCustomHeader], default is Undefined, optional
        One or more sub-resources with name and value parameters that specify header data that will be sent to the origin (multiples allowed).
    customOriginConfig : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginCustomOriginConfig, default is Undefined, optional
        custom origin config
    domainName : str, default is Undefined, optional
        DNS domain name of either the S3 bucket, or web site of your custom origin.
    originAccessControlId : str, default is Undefined, optional
        Unique identifier of a CloudFront origin access control for this origin.
    originId : str, default is Undefined, optional
        Unique identifier for the origin.
    originPath : str, default is Undefined, optional
        Optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin.
    originShield : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginOriginShield, default is Undefined, optional
        origin shield
    responseCompletionTimeout : float, default is Undefined, optional
        Time (in seconds) that a request from CloudFront to the origin can stay open and wait for a response. Must be integer greater than or equal to the value of origin_read_timeout. If omitted or explicitly set to 0, no maximum value is enforced.
    s3OriginConfig : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginS3OriginConfig, default is Undefined, optional
        s3 origin config
    vpcOriginConfig : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginVpcOriginConfig, default is Undefined, optional
        vpc origin config
    """


    connectionAttempts?: float

    connectionTimeout?: float

    customHeader?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginCustomHeader]

    customOriginConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginCustomOriginConfig

    domainName?: str

    originAccessControlId?: str

    originId?: str

    originPath?: str

    originShield?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginOriginShield

    responseCompletionTimeout?: float

    s3OriginConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginS3OriginConfig

    vpcOriginConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginVpcOriginConfig




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginCustomHeader:
    r"""
    distribution v1beta1 at provider origin custom header

    Attributes
    ----------
    name : str, default is Undefined, optional
        name
    value : str, default is Undefined, optional
        value
    """


    name?: str

    value?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginCustomOriginConfig:
    r"""
    The CloudFront custom origin configuration information. If an S3 origin is required, use origin_access_control_id or s3_origin_config instead.

    Attributes
    ----------
    httpPort : float, default is Undefined, optional
        HTTP port the custom origin listens on.
    httpsPort : float, default is Undefined, optional
        HTTPS port the custom origin listens on.
    ipAddressType : str, default is Undefined, optional
        IP protocol CloudFront uses when connecting to your origin. Valid values: ipv4, ipv6, dualstack.
    originKeepaliveTimeout : float, default is Undefined, optional
        The Custom KeepAlive timeout, in seconds. By default, AWS enforces an upper limit of 60. But you can request an increase. Defaults to 5.
    originMtlsConfig : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginCustomOriginConfigOriginMtlsConfig, default is Undefined, optional
        origin mtls config
    originProtocolPolicy : str, default is Undefined, optional
        Origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer.
    originReadTimeout : float, default is Undefined, optional
        The Custom Read timeout, in seconds. By default, AWS enforces an upper limit of 60. But you can request an increase. Defaults to 30.
    originSslProtocols : [str], default is Undefined, optional
        List of SSL/TLS protocols that CloudFront can use when connecting to your origin over HTTPS. Valid values: SSLv3, TLSv1, TLSv1.1, TLSv1.2. For more information, see Minimum Origin SSL Protocol in the Amazon CloudFront Developer Guide.
    """


    httpPort?: float

    httpsPort?: float

    ipAddressType?: str

    originKeepaliveTimeout?: float

    originMtlsConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginCustomOriginConfigOriginMtlsConfig

    originProtocolPolicy?: str

    originReadTimeout?: float

    originSslProtocols?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginCustomOriginConfigOriginMtlsConfig:
    r"""
    The origin mTLS configuration for mutual TLS authentication between CloudFront and your origin.

    Attributes
    ----------
    clientCertificateArn : str, default is Undefined, optional
        ARN of the ACM certificate to use for mutual TLS authentication with the origin. The certificate must have Extended Key Usage set to TLS Client Authentication.
    """


    clientCertificateArn?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginGroup:
    r"""
    distribution v1beta1 at provider origin group

    Attributes
    ----------
    failoverCriteria : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginGroupFailoverCriteria, default is Undefined, optional
        failover criteria
    member : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginGroupMember], default is Undefined, optional
        Ordered member configuration blocks assigned to the origin group, where the first member is the primary origin. You must specify two members.
    originId : str, default is Undefined, optional
        Unique identifier for the origin.
    """


    failoverCriteria?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginGroupFailoverCriteria

    member?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginGroupMember]

    originId?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginGroupFailoverCriteria:
    r"""
    The failover criteria for when to failover to the secondary origin.

    Attributes
    ----------
    statusCodes : [float], default is Undefined, optional
        List of HTTP status codes for the origin group.
    """


    statusCodes?: [float]




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginGroupMember:
    r"""
    distribution v1beta1 at provider origin group member

    Attributes
    ----------
    originId : str, default is Undefined, optional
        Unique identifier for the origin.
    """


    originId?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginOriginShield:
    r"""
    CloudFront Origin Shield configuration information. Using Origin Shield can help reduce the load on your origin. For more information, see Using Origin Shield in the Amazon CloudFront Developer Guide.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Whether the distribution is enabled to accept end user requests for content.
    originShieldRegion : str, default is Undefined, optional
        AWS Region for Origin Shield. To specify a region, use the region code, not the region name. For example, specify the US East (Ohio) region as us-east-2.
    """


    enabled?: bool

    originShieldRegion?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginS3OriginConfig:
    r"""
    CloudFront S3 origin configuration information. If a custom origin is required, use custom_origin_config instead.

    Attributes
    ----------
    originAccessIdentity : str, default is Undefined, optional
        The CloudFront origin access identity to associate with the origin.
    """


    originAccessIdentity?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginVpcOriginConfig:
    r"""
    The VPC origin configuration.

    Attributes
    ----------
    originKeepaliveTimeout : float, default is Undefined, optional
        The Custom KeepAlive timeout, in seconds. By default, AWS enforces an upper limit of 60. But you can request an increase. Defaults to 5.
    originReadTimeout : float, default is Undefined, optional
        The Custom Read timeout, in seconds. By default, AWS enforces an upper limit of 60. But you can request an increase. Defaults to 30.
    ownerAccountId : str, default is Undefined, optional
        The AWS account ID that owns the VPC origin. Required when referencing a VPC origin from a different AWS account for cross-account VPC origin access.
    vpcOriginId : str, default is Undefined, optional
        The VPC origin ID.
    """


    originKeepaliveTimeout?: float

    originReadTimeout?: float

    ownerAccountId?: str

    vpcOriginId?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderRestrictions:
    r"""
    The restriction configuration for this distribution (maximum one).

    Attributes
    ----------
    geoRestriction : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderRestrictionsGeoRestriction, default is Undefined, optional
        geo restriction
    """


    geoRestriction?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderRestrictionsGeoRestriction




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderRestrictionsGeoRestriction:
    r"""
    distribution v1beta1 at provider restrictions geo restriction

    Attributes
    ----------
    locations : [str], default is Undefined, optional
        ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist). If the type is specified as none an empty array can be used.
    restrictionType : str, default is Undefined, optional
        Method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist.
    """


    locations?: [str]

    restrictionType?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderTrustedKeyGroups:
    r"""
    distribution v1beta1 at provider trusted key groups

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Whether the distribution is enabled to accept end user requests for content.
    items : [CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProviderTrustedKeyGroups], default is Undefined, optional
        List of nested attributes for each key group.
    """


    enabled?: bool

    items?: [CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProviderTrustedKeyGroups]




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderTrustedSigners:
    r"""
    distribution v1beta1 at provider trusted signers

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Whether the distribution is enabled to accept end user requests for content.
    items : [CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProviderTrustedSigners], default is Undefined, optional
        List of nested attributes for each key group.
    """


    enabled?: bool

    items?: [CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProviderTrustedSigners]




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderViewerCertificate:
    r"""
    The SSL configuration for this distribution (maximum one).

    Attributes
    ----------
    acmCertificateArn : str, default is Undefined, optional
        ARN of the AWS Certificate Manager certificate that you wish to use with this distribution. Specify this, cloudfront_default_certificate, or iam_certificate_id.  The ACM certificate must be in  US-EAST-1.
    cloudfrontDefaultCertificate : bool, default is Undefined, optional
        true if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. Specify this, acm_certificate_arn, or iam_certificate_id.
    iamCertificateId : str, default is Undefined, optional
        IAM certificate identifier of the custom viewer certificate for this distribution if you are using a custom domain. Specify this, acm_certificate_arn, or cloudfront_default_certificate.
    minimumProtocolVersion : str, default is Undefined, optional
        Minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can only be set if cloudfront_default_certificate = false. See all possible values in this table under "Security policy." Some examples include: TLSv1.2_2019 and TLSv1.2_2021. Default: TLSv1. NOTE: If you are using a custom certificate (specified with acm_certificate_arn or iam_certificate_id), and have specified sni-only in ssl_support_method, TLSv1 or later must be specified. If you have specified vip in ssl_support_method, only SSLv3 or TLSv1 can be specified. If you have specified cloudfront_default_certificate, TLSv1 must be specified.
    sslSupportMethod : str, default is Undefined, optional
        How you want CloudFront to serve HTTPS requests. One of vip, sni-only, or static-ip. Required if you specify acm_certificate_arn or iam_certificate_id. NOTE: vip causes CloudFront to use a dedicated IP address and may incur extra charges.
    """


    acmCertificateArn?: str

    cloudfrontDefaultCertificate?: bool

    iamCertificateId?: str

    minimumProtocolVersion?: str

    sslSupportMethod?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderViewerMtlsConfig:
    r"""
    The viewer mTLS configuration for this distribution (maximum one).

    Attributes
    ----------
    mode : str, default is Undefined, optional
        The mode for viewer mTLS. Valid values: required, optional.
    trustStoreConfig : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderViewerMtlsConfigTrustStoreConfig, default is Undefined, optional
        trust store config
    """


    mode?: str

    trustStoreConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderViewerMtlsConfigTrustStoreConfig




schema CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderViewerMtlsConfigTrustStoreConfig:
    r"""
    The trust store configuration for viewer mTLS (maximum one).

    Attributes
    ----------
    advertiseTrustStoreCaNames : bool, default is Undefined, optional
        Whether to advertise the trust store CA names to clients. Defaults to false.
    ignoreCertificateExpiry : bool, default is Undefined, optional
        Whether to ignore certificate expiry for viewer mTLS. Defaults to false.
    trustStoreId : str, default is Undefined, optional
        Identifier of the trust store to use for viewer mTLS.
    """


    advertiseTrustStoreCaNames?: bool

    ignoreCertificateExpiry?: bool

    trustStoreId?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderCustomOriginConfigOriginMtlsConfig:
    r"""
    The origin mTLS configuration for mutual TLS authentication between CloudFront and your origin.

    Attributes
    ----------
    clientCertificateArn : str, default is Undefined, optional
        ARN of the ACM certificate to use for mutual TLS authentication with the origin. The certificate must have Extended Key Usage set to TLS Client Authentication.
    """


    clientCertificateArn?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorForwardedValues:
    r"""
    The forwarded values configuration that specifies how CloudFront handles query strings, cookies and headers (maximum one).

    Attributes
    ----------
    cookies : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderForwardedValuesCookies, default is Undefined, optional
        cookies
    headers : [str], default is Undefined, optional
        Headers, if any, that you want CloudFront to vary upon for this cache behavior. Specify * to include all headers.
    queryString : bool, default is Undefined, optional
        Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior.
    queryStringCacheKeys : [str], default is Undefined, optional
        When specified, along with a value of true for query_string, all query strings are forwarded, however only the query string keys listed in this argument are cached. When omitted with a value of true for query_string, all query string keys are cached.
    """


    cookies?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderForwardedValuesCookies

    headers?: [str]

    queryString?: bool

    queryStringCacheKeys?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorFunctionAssociation:
    r"""
    distribution v1beta1 default cache behavior function association

    Attributes
    ----------
    eventType : str, default is Undefined, optional
        Specific event to trigger this function. Valid values: viewer-request, origin-request, viewer-response, origin-response.
    functionArn : str, default is Undefined, optional
        ARN of the CloudFront function.
    """


    eventType?: str

    functionArn?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorGrpcConfig:
    r"""
    A config block that sets the grpc config.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Whether the distribution is enabled to accept end user requests for content.
    """


    enabled?: bool




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorLambdaFunctionAssociation:
    r"""
    distribution v1beta1 default cache behavior lambda function association

    Attributes
    ----------
    eventType : str, default is Undefined, optional
        Specific event to trigger this function. Valid values: viewer-request, origin-request, viewer-response, origin-response.
    includeBody : bool, default is Undefined, optional
        When set to true it exposes the request body to the lambda function. Defaults to false. Valid values: true, false.
    lambdaArn : str, default is Undefined, optional
        ARN of the Lambda function.
    """


    eventType?: str

    includeBody?: bool

    lambdaArn?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderCacheTagConfig:
    r"""
    Cache tag configuration block for cache tag extraction from origin responses (maximum one). See the AWS documentation for more information about cache tags.

    Attributes
    ----------
    headerName : str, default is Undefined, optional
        Name of the HTTP header to extract cache tags. The header value must contain comma-separated tag values.
    """


    headerName?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderConnectionFunctionAssociation:
    r"""
    A connection function association configuration block (maximum one).

    Attributes
    ----------
    id : str, default is Undefined, optional
        Identifier of the connection function to associate with the distribution.
    """


    id?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderCustomErrorResponse:
    r"""
    distribution v1beta1 for provider custom error response

    Attributes
    ----------
    errorCachingMinTtl : float, default is Undefined, optional
        Minimum amount of time you want HTTP error codes to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated.
    errorCode : float, default is Undefined, optional
        4xx or 5xx HTTP status code that you want to customize.
    responseCode : float, default is Undefined, optional
        HTTP status code that you want CloudFront to return with the custom error page to the viewer.
    responsePagePath : str, default is Undefined, optional
        Path of the custom error page (for example, /custom_404.html).
    """


    errorCachingMinTtl?: float

    errorCode?: float

    responseCode?: float

    responsePagePath?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehavior:
    r"""
    Default cache behavior for this distribution (maximum one). Requires either cache_policy_id (preferred) or forwarded_values (deprecated) be set.

    Attributes
    ----------
    allowedMethods : [str], default is Undefined, optional
        Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin.
    cachePolicyId : str, default is Undefined, optional
        Unique identifier of the cache policy that is attached to the cache behavior. If configuring the default_cache_behavior either cache_policy_id or forwarded_values must be set.
    cachedMethods : [str], default is Undefined, optional
        Controls whether CloudFront caches the response to requests using the specified HTTP methods.
    compress : bool, default is Undefined, optional
        Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header (default: false).
    defaultTtl : float, default is Undefined, optional
        Default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header. The TTL defined in Cache Policy overrides this configuration.
    fieldLevelEncryptionId : str, default is Undefined, optional
        Field level encryption configuration ID.
    forwardedValues : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorForwardedValues, default is Undefined, optional
        forwarded values
    functionAssociation : [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorFunctionAssociation], default is Undefined, optional
        A config block that triggers a cloudfront function with specific actions (maximum 2).
    grpcConfig : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorGrpcConfig, default is Undefined, optional
        grpc config
    lambdaFunctionAssociation : [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorLambdaFunctionAssociation], default is Undefined, optional
        A config block that triggers a lambda function with specific actions (maximum 4).
    maxTtl : float, default is Undefined, optional
        Maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers. The TTL defined in Cache Policy overrides this configuration.
    minTtl : float, default is Undefined, optional
        Minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to 0 seconds. The TTL defined in Cache Policy overrides this configuration.
    originRequestPolicyId : str, default is Undefined, optional
        Unique identifier of the origin request policy that is attached to the behavior.
    realtimeLogConfigArn : str, default is Undefined, optional
        ARN of the real-time log configuration that is attached to this cache behavior.
    responseHeadersPolicyId : str, default is Undefined, optional
        Identifier for a response headers policy.
    smoothStreaming : bool, default is Undefined, optional
        Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior.
    targetOriginId : str, default is Undefined, optional
        Value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern either for a cache behavior or for the default cache behavior.
    trustedKeyGroups : [str], default is Undefined, optional
        List of key group IDs that CloudFront can use to validate signed URLs or signed cookies. See the CloudFront User Guide for more information about this feature.
    trustedSigners : [str], default is Undefined, optional
        List of AWS account IDs (or self) that you want to allow to create signed URLs for private content. See the CloudFront User Guide for more information about this feature.
    viewerProtocolPolicy : str, default is Undefined, optional
        Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https.
    """


    allowedMethods?: [str]

    cachePolicyId?: str

    cachedMethods?: [str]

    compress?: bool

    defaultTtl?: float

    fieldLevelEncryptionId?: str

    forwardedValues?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorForwardedValues

    functionAssociation?: [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorFunctionAssociation]

    grpcConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorGrpcConfig

    lambdaFunctionAssociation?: [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehaviorLambdaFunctionAssociation]

    maxTtl?: float

    minTtl?: float

    originRequestPolicyId?: str

    realtimeLogConfigArn?: str

    responseHeadersPolicyId?: str

    smoothStreaming?: bool

    targetOriginId?: str

    trustedKeyGroups?: [str]

    trustedSigners?: [str]

    viewerProtocolPolicy?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLoggingConfig:
    r"""
    The logging configuration that controls how logs are written to your distribution (maximum one). AWS provides two versions of access logs for CloudFront: Legacy and v2. This argument configures legacy version standard logs.

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        Amazon S3 bucket for V1 logging where access logs are stored, for example, myawslogbucket.s3.amazonaws.com. V1 logging is enabled when this argument is specified. The bucket must have correct ACL attached with "FULL_CONTROL" permission for "awslogsdelivery" account (Canonical ID: "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0") for log transfer to work.
    includeCookies : bool, default is Undefined, optional
        Whether to include cookies in access logs (default: false). This argument applies to both V1 and V2 logging.
    prefix : str, default is Undefined, optional
        Prefix added to the access log file names for V1 logging, for example, myprefix/. This argument is effective only when V1 logging is enabled.
    """


    bucket?: str

    includeCookies?: bool

    prefix?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehavior:
    r"""
    distribution v1beta1 for provider ordered cache behavior

    Attributes
    ----------
    allowedMethods : [str], default is Undefined, optional
        Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin.
    cachePolicyId : str, default is Undefined, optional
        Unique identifier of the cache policy that is attached to the cache behavior. If configuring the default_cache_behavior either cache_policy_id or forwarded_values must be set.
    cachedMethods : [str], default is Undefined, optional
        Controls whether CloudFront caches the response to requests using the specified HTTP methods.
    compress : bool, default is Undefined, optional
        Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header (default: false).
    defaultTtl : float, default is Undefined, optional
        Default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header. The TTL defined in Cache Policy overrides this configuration.
    fieldLevelEncryptionId : str, default is Undefined, optional
        Field level encryption configuration ID.
    forwardedValues : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorForwardedValues, default is Undefined, optional
        forwarded values
    functionAssociation : [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorFunctionAssociation], default is Undefined, optional
        A config block that triggers a cloudfront function with specific actions (maximum 2).
    grpcConfig : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorGrpcConfig, default is Undefined, optional
        grpc config
    lambdaFunctionAssociation : [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorLambdaFunctionAssociation], default is Undefined, optional
        A config block that triggers a lambda function with specific actions (maximum 4).
    maxTtl : float, default is Undefined, optional
        Maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers. The TTL defined in Cache Policy overrides this configuration.
    minTtl : float, default is Undefined, optional
        Minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to 0 seconds. The TTL defined in Cache Policy overrides this configuration.
    originRequestPolicyId : str, default is Undefined, optional
        Unique identifier of the origin request policy that is attached to the behavior.
    pathPattern : str, default is Undefined, optional
        Pattern (for example, images/*.jpg) that specifies which requests you want this cache behavior to apply to.
    realtimeLogConfigArn : str, default is Undefined, optional
        ARN of the real-time log configuration that is attached to this cache behavior.
    responseHeadersPolicyId : str, default is Undefined, optional
        Identifier for a response headers policy.
    smoothStreaming : bool, default is Undefined, optional
        Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior.
    targetOriginId : str, default is Undefined, optional
        Value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern either for a cache behavior or for the default cache behavior.
    trustedKeyGroups : [str], default is Undefined, optional
        List of key group IDs that CloudFront can use to validate signed URLs or signed cookies. See the CloudFront User Guide for more information about this feature.
    trustedSigners : [str], default is Undefined, optional
        List of AWS account IDs (or self) that you want to allow to create signed URLs for private content. See the CloudFront User Guide for more information about this feature.
    viewerProtocolPolicy : str, default is Undefined, optional
        Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https.
    """


    allowedMethods?: [str]

    cachePolicyId?: str

    cachedMethods?: [str]

    compress?: bool

    defaultTtl?: float

    fieldLevelEncryptionId?: str

    forwardedValues?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorForwardedValues

    functionAssociation?: [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorFunctionAssociation]

    grpcConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorGrpcConfig

    lambdaFunctionAssociation?: [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorLambdaFunctionAssociation]

    maxTtl?: float

    minTtl?: float

    originRequestPolicyId?: str

    pathPattern?: str

    realtimeLogConfigArn?: str

    responseHeadersPolicyId?: str

    smoothStreaming?: bool

    targetOriginId?: str

    trustedKeyGroups?: [str]

    trustedSigners?: [str]

    viewerProtocolPolicy?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrigin:
    r"""
    distribution v1beta1 for provider origin

    Attributes
    ----------
    connectionAttempts : float, default is Undefined, optional
        Number of times that CloudFront attempts to connect to the origin. Must be between 1-3. Defaults to 3.
    connectionTimeout : float, default is Undefined, optional
        Number of seconds that CloudFront waits when trying to establish a connection to the origin. Must be between 1-10. Defaults to 10.
    customHeader : [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginCustomHeader], default is Undefined, optional
        One or more sub-resources with name and value parameters that specify header data that will be sent to the origin (multiples allowed).
    customOriginConfig : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginCustomOriginConfig, default is Undefined, optional
        custom origin config
    domainName : str, default is Undefined, optional
        DNS domain name of either the S3 bucket, or web site of your custom origin.
    originAccessControlId : str, default is Undefined, optional
        Unique identifier of a CloudFront origin access control for this origin.
    originAccessControlIdRef : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginOriginAccessControlIDRef, default is Undefined, optional
        origin access control Id ref
    originAccessControlIdSelector : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginOriginAccessControlIDSelector, default is Undefined, optional
        origin access control Id selector
    originId : str, default is Undefined, optional
        Unique identifier for the origin.
    originPath : str, default is Undefined, optional
        Optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin.
    originShield : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginOriginShield, default is Undefined, optional
        origin shield
    responseCompletionTimeout : float, default is Undefined, optional
        Time (in seconds) that a request from CloudFront to the origin can stay open and wait for a response. Must be integer greater than or equal to the value of origin_read_timeout. If omitted or explicitly set to 0, no maximum value is enforced.
    s3OriginConfig : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginS3OriginConfig, default is Undefined, optional
        s3 origin config
    vpcOriginConfig : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginVpcOriginConfig, default is Undefined, optional
        vpc origin config
    """


    connectionAttempts?: float

    connectionTimeout?: float

    customHeader?: [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginCustomHeader]

    customOriginConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginCustomOriginConfig

    domainName?: str

    originAccessControlId?: str

    originAccessControlIdRef?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginOriginAccessControlIDRef

    originAccessControlIdSelector?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginOriginAccessControlIDSelector

    originId?: str

    originPath?: str

    originShield?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginOriginShield

    responseCompletionTimeout?: float

    s3OriginConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginS3OriginConfig

    vpcOriginConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginVpcOriginConfig




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginGroup:
    r"""
    distribution v1beta1 for provider origin group

    Attributes
    ----------
    failoverCriteria : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginGroupFailoverCriteria, default is Undefined, optional
        failover criteria
    member : [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginGroupMember], default is Undefined, optional
        Ordered member configuration blocks assigned to the origin group, where the first member is the primary origin. You must specify two members.
    originId : str, default is Undefined, optional
        Unique identifier for the origin.
    """


    failoverCriteria?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginGroupFailoverCriteria

    member?: [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginGroupMember]

    originId?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderRestrictions:
    r"""
    The restriction configuration for this distribution (maximum one).

    Attributes
    ----------
    geoRestriction : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderRestrictionsGeoRestriction, default is Undefined, optional
        geo restriction
    """


    geoRestriction?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderRestrictionsGeoRestriction




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerCertificate:
    r"""
    The SSL configuration for this distribution (maximum one).

    Attributes
    ----------
    acmCertificateArn : str, default is Undefined, optional
        ARN of the AWS Certificate Manager certificate that you wish to use with this distribution. Specify this, cloudfront_default_certificate, or iam_certificate_id.  The ACM certificate must be in  US-EAST-1.
    cloudfrontDefaultCertificate : bool, default is Undefined, optional
        true if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. Specify this, acm_certificate_arn, or iam_certificate_id.
    iamCertificateId : str, default is Undefined, optional
        IAM certificate identifier of the custom viewer certificate for this distribution if you are using a custom domain. Specify this, acm_certificate_arn, or cloudfront_default_certificate.
    minimumProtocolVersion : str, default is Undefined, optional
        Minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can only be set if cloudfront_default_certificate = false. See all possible values in this table under "Security policy." Some examples include: TLSv1.2_2019 and TLSv1.2_2021. Default: TLSv1. NOTE: If you are using a custom certificate (specified with acm_certificate_arn or iam_certificate_id), and have specified sni-only in ssl_support_method, TLSv1 or later must be specified. If you have specified vip in ssl_support_method, only SSLv3 or TLSv1 can be specified. If you have specified cloudfront_default_certificate, TLSv1 must be specified.
    sslSupportMethod : str, default is Undefined, optional
        How you want CloudFront to serve HTTPS requests. One of vip, sni-only, or static-ip. Required if you specify acm_certificate_arn or iam_certificate_id. NOTE: vip causes CloudFront to use a dedicated IP address and may incur extra charges.
    """


    acmCertificateArn?: str

    cloudfrontDefaultCertificate?: bool

    iamCertificateId?: str

    minimumProtocolVersion?: str

    sslSupportMethod?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerMtlsConfig:
    r"""
    The viewer mTLS configuration for this distribution (maximum one).

    Attributes
    ----------
    mode : str, default is Undefined, optional
        The mode for viewer mTLS. Valid values: required, optional.
    trustStoreConfig : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerMtlsConfigTrustStoreConfig, default is Undefined, optional
        trust store config
    """


    mode?: str

    trustStoreConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerMtlsConfigTrustStoreConfig




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderForwardedValuesCookies:
    r"""
    The forwarded values cookies that specifies how CloudFront handles cookies (maximum one).

    Attributes
    ----------
    forward : str, default is Undefined, optional
        Whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior. You can specify all, none or whitelist. If whitelist, you must include the subsequent whitelisted_names.
    whitelistedNames : [str], default is Undefined, optional
        If you have specified whitelist to forward, the whitelisted cookies that you want CloudFront to forward to your origin.
    """


    forward?: str

    whitelistedNames?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionArnRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionArnSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionAssociationFunctionArnRef:
    r"""
    Reference to a Function in cloudfront to populate functionArn.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionArnRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionArnRefPolicy




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionAssociationFunctionArnSelector:
    r"""
    Selector for a Function in cloudfront to populate functionArn.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionArnSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionArnSelectorPolicy




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaArnRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaArnSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaFunctionAssociationLambdaArnRef:
    r"""
    Reference to a Function in lambda to populate lambdaArn.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaArnRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaArnRefPolicy




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaFunctionAssociationLambdaArnSelector:
    r"""
    Selector for a Function in lambda to populate lambdaArn.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaArnSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaArnSelectorPolicy




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorForwardedValues:
    r"""
    The forwarded values configuration that specifies how CloudFront handles query strings, cookies and headers (maximum one).

    Attributes
    ----------
    cookies : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorForwardedValuesCookies, default is Undefined, optional
        cookies
    headers : [str], default is Undefined, optional
        Headers, if any, that you want CloudFront to vary upon for this cache behavior. Specify * to include all headers.
    queryString : bool, default is Undefined, optional
        Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior.
    queryStringCacheKeys : [str], default is Undefined, optional
        When specified, along with a value of true for query_string, all query strings are forwarded, however only the query string keys listed in this argument are cached. When omitted with a value of true for query_string, all query string keys are cached.
    """


    cookies?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorForwardedValuesCookies

    headers?: [str]

    queryString?: bool

    queryStringCacheKeys?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorForwardedValuesCookies:
    r"""
    The forwarded values cookies that specifies how CloudFront handles cookies (maximum one).

    Attributes
    ----------
    forward : str, default is Undefined, optional
        Whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior. You can specify all, none or whitelist. If whitelist, you must include the subsequent whitelisted_names.
    whitelistedNames : [str], default is Undefined, optional
        If you have specified whitelist to forward, the whitelisted cookies that you want CloudFront to forward to your origin.
    """


    forward?: str

    whitelistedNames?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorFunctionAssociation:
    r"""
    distribution v1beta1 ordered cache behavior function association

    Attributes
    ----------
    eventType : str, default is Undefined, optional
        Specific event to trigger this function. Valid values: viewer-request, origin-request, viewer-response, origin-response.
    functionArn : str, default is Undefined, optional
        ARN of the CloudFront function.
    functionArnRef : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionAssociationFunctionArnRef, default is Undefined, optional
        function arn ref
    functionArnSelector : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionAssociationFunctionArnSelector, default is Undefined, optional
        function arn selector
    """


    eventType?: str

    functionArn?: str

    functionArnRef?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionAssociationFunctionArnRef

    functionArnSelector?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderFunctionAssociationFunctionArnSelector




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorGrpcConfig:
    r"""
    A config block that sets the grpc config.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Whether the distribution is enabled to accept end user requests for content.
    """


    enabled?: bool




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehaviorLambdaFunctionAssociation:
    r"""
    distribution v1beta1 ordered cache behavior lambda function association

    Attributes
    ----------
    eventType : str, default is Undefined, optional
        Specific event to trigger this function. Valid values: viewer-request, origin-request, viewer-response, origin-response.
    includeBody : bool, default is Undefined, optional
        When set to true it exposes the request body to the lambda function. Defaults to false. Valid values: true, false.
    lambdaArn : str, default is Undefined, optional
        ARN of the Lambda function.
    lambdaArnRef : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaFunctionAssociationLambdaArnRef, default is Undefined, optional
        lambda arn ref
    lambdaArnSelector : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaFunctionAssociationLambdaArnSelector, default is Undefined, optional
        lambda arn selector
    """


    eventType?: str

    includeBody?: bool

    lambdaArn?: str

    lambdaArnRef?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaFunctionAssociationLambdaArnRef

    lambdaArnSelector?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLambdaFunctionAssociationLambdaArnSelector




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessControlIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessControlIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessIdentityRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessIdentitySelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginCustomHeader:
    r"""
    distribution v1beta1 origin custom header

    Attributes
    ----------
    name : str, default is Undefined, optional
        name
    value : str, default is Undefined, optional
        value
    """


    name?: str

    value?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginCustomOriginConfig:
    r"""
    The CloudFront custom origin configuration information. If an S3 origin is required, use origin_access_control_id or s3_origin_config instead.

    Attributes
    ----------
    httpPort : float, default is Undefined, optional
        HTTP port the custom origin listens on.
    httpsPort : float, default is Undefined, optional
        HTTPS port the custom origin listens on.
    ipAddressType : str, default is Undefined, optional
        IP protocol CloudFront uses when connecting to your origin. Valid values: ipv4, ipv6, dualstack.
    originKeepaliveTimeout : float, default is Undefined, optional
        The Custom KeepAlive timeout, in seconds. By default, AWS enforces an upper limit of 60. But you can request an increase. Defaults to 5.
    originMtlsConfig : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderCustomOriginConfigOriginMtlsConfig, default is Undefined, optional
        origin mtls config
    originProtocolPolicy : str, default is Undefined, optional
        Origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer.
    originReadTimeout : float, default is Undefined, optional
        The Custom Read timeout, in seconds. By default, AWS enforces an upper limit of 60. But you can request an increase. Defaults to 30.
    originSslProtocols : [str], default is Undefined, optional
        List of SSL/TLS protocols that CloudFront can use when connecting to your origin over HTTPS. Valid values: SSLv3, TLSv1, TLSv1.1, TLSv1.2. For more information, see Minimum Origin SSL Protocol in the Amazon CloudFront Developer Guide.
    """


    httpPort?: float

    httpsPort?: float

    ipAddressType?: str

    originKeepaliveTimeout?: float

    originMtlsConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderCustomOriginConfigOriginMtlsConfig

    originProtocolPolicy?: str

    originReadTimeout?: float

    originSslProtocols?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginGroupFailoverCriteria:
    r"""
    The failover criteria for when to failover to the secondary origin.

    Attributes
    ----------
    statusCodes : [float], default is Undefined, optional
        List of HTTP status codes for the origin group.
    """


    statusCodes?: [float]




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginGroupMember:
    r"""
    distribution v1beta1 origin group member

    Attributes
    ----------
    originId : str, default is Undefined, optional
        Unique identifier for the origin.
    """


    originId?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginOriginAccessControlIDRef:
    r"""
    Reference to a OriginAccessControl in cloudfront to populate originAccessControlId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessControlIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessControlIDRefPolicy




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginOriginAccessControlIDSelector:
    r"""
    Selector for a OriginAccessControl in cloudfront to populate originAccessControlId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessControlIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessControlIDSelectorPolicy




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginOriginShield:
    r"""
    CloudFront Origin Shield configuration information. Using Origin Shield can help reduce the load on your origin. For more information, see Using Origin Shield in the Amazon CloudFront Developer Guide.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Whether the distribution is enabled to accept end user requests for content.
    originShieldRegion : str, default is Undefined, optional
        AWS Region for Origin Shield. To specify a region, use the region code, not the region name. For example, specify the US East (Ohio) region as us-east-2.
    """


    enabled?: bool

    originShieldRegion?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginS3OriginConfig:
    r"""
    CloudFront S3 origin configuration information. If a custom origin is required, use custom_origin_config instead.

    Attributes
    ----------
    originAccessIdentity : str, default is Undefined, optional
        The CloudFront origin access identity to associate with the origin.
    originAccessIdentityRef : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderS3OriginConfigOriginAccessIdentityRef, default is Undefined, optional
        origin access identity ref
    originAccessIdentitySelector : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderS3OriginConfigOriginAccessIdentitySelector, default is Undefined, optional
        origin access identity selector
    """


    originAccessIdentity?: str

    originAccessIdentityRef?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderS3OriginConfigOriginAccessIdentityRef

    originAccessIdentitySelector?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderS3OriginConfigOriginAccessIdentitySelector




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginVpcOriginConfig:
    r"""
    The VPC origin configuration.

    Attributes
    ----------
    originKeepaliveTimeout : float, default is Undefined, optional
        The Custom KeepAlive timeout, in seconds. By default, AWS enforces an upper limit of 60. But you can request an increase. Defaults to 5.
    originReadTimeout : float, default is Undefined, optional
        The Custom Read timeout, in seconds. By default, AWS enforces an upper limit of 60. But you can request an increase. Defaults to 30.
    ownerAccountId : str, default is Undefined, optional
        The AWS account ID that owns the VPC origin. Required when referencing a VPC origin from a different AWS account for cross-account VPC origin access.
    vpcOriginId : str, default is Undefined, optional
        The VPC origin ID.
    """


    originKeepaliveTimeout?: float

    originReadTimeout?: float

    ownerAccountId?: str

    vpcOriginId?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderRestrictionsGeoRestriction:
    r"""
    distribution v1beta1 restrictions geo restriction

    Attributes
    ----------
    locations : [str], default is Undefined, optional
        ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist). If the type is specified as none an empty array can be used.
    restrictionType : str, default is Undefined, optional
        Method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist.
    """


    locations?: [str]

    restrictionType?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderS3OriginConfigOriginAccessIdentityRef:
    r"""
    Reference to a OriginAccessIdentity in cloudfront to populate originAccessIdentity.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessIdentityRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessIdentityRefPolicy




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderS3OriginConfigOriginAccessIdentitySelector:
    r"""
    Selector for a OriginAccessIdentity in cloudfront to populate originAccessIdentity.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessIdentitySelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginAccessIdentitySelectorPolicy




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProvider:
    r"""
    distribution v1beta1 spec for provider

    Attributes
    ----------
    aliases : [str], default is Undefined, optional
        Extra CNAMEs (alternate domain names), if any, for this distribution.
    anycastIpListId : str, default is Undefined, optional
        ID of the Anycast static IP list that is associated with the distribution.
    cacheTagConfig : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderCacheTagConfig, default is Undefined, optional
        cache tag config
    comment : str, default is Undefined, optional
        Any comments you want to include about the distribution.
    connectionFunctionAssociation : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderConnectionFunctionAssociation, default is Undefined, optional
        connection function association
    continuousDeploymentPolicyId : str, default is Undefined, optional
        Identifier of a continuous deployment policy. This argument should only be set on a production distribution. See the aws_cloudfront_continuous_deployment_policy resource for additional details.
    customErrorResponse : [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderCustomErrorResponse], default is Undefined, optional
        One or more custom error response elements (multiples allowed).
    defaultCacheBehavior : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehavior, default is Undefined, optional
        default cache behavior
    defaultRootObject : str, default is Undefined, optional
        Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL.
    enabled : bool, default is Undefined, optional
        Whether the distribution is enabled to accept end user requests for content.
    httpVersion : str, default is Undefined, optional
        Maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3 and http3. The default is http2.
    isIpv6Enabled : bool, default is Undefined, optional
        Whether the IPv6 is enabled for the distribution.
    loggingConfig : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLoggingConfig, default is Undefined, optional
        logging config
    orderedCacheBehavior : [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehavior], default is Undefined, optional
        Ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0.
    origin : [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrigin], default is Undefined, optional
        One or more origins for this distribution (multiples allowed).
    originGroup : [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginGroup], default is Undefined, optional
        One or more origin_group for this distribution (multiples allowed).
    priceClass : str, default is Undefined, optional
        Price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100.
    restrictions : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderRestrictions, default is Undefined, optional
        restrictions
    retainOnDelete : bool, default is Undefined, optional
        If this is set, the distribution needs to be deleted manually afterwards. Default: false.
    staging : bool, default is Undefined, optional
        A Boolean that indicates whether this is a staging distribution. Defaults to false.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    viewerCertificate : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerCertificate, default is Undefined, optional
        viewer certificate
    viewerMtlsConfig : CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerMtlsConfig, default is Undefined, optional
        viewer mtls config
    waitForDeployment : bool, default is Undefined, optional
        If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. Default: true.
    webAclId : str, default is Undefined, optional
        Unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution. To specify a web ACL created using the latest version of AWS WAF (WAFv2), use the ACL ARN, for example aws_wafv2_web_acl.example.arn. To specify a web ACL created using AWS WAF Classic, use the ACL ID, for example aws_waf_web_acl.example.id. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned.
    """


    aliases?: [str]

    anycastIpListId?: str

    cacheTagConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderCacheTagConfig

    comment?: str

    connectionFunctionAssociation?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderConnectionFunctionAssociation

    continuousDeploymentPolicyId?: str

    customErrorResponse?: [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderCustomErrorResponse]

    defaultCacheBehavior?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderDefaultCacheBehavior

    defaultRootObject?: str

    enabled?: bool

    httpVersion?: str

    isIpv6Enabled?: bool

    loggingConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderLoggingConfig

    orderedCacheBehavior?: [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrderedCacheBehavior]

    origin?: [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOrigin]

    originGroup?: [CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderOriginGroup]

    priceClass?: str

    restrictions?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderRestrictions

    retainOnDelete?: bool

    staging?: bool

    tags?: {str:str}

    viewerCertificate?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerCertificate

    viewerMtlsConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerMtlsConfig

    waitForDeployment?: bool

    webAclId?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProvider:
    r"""
    distribution v1beta1 status at provider

    Attributes
    ----------
    aliases : [str], default is Undefined, optional
        Extra CNAMEs (alternate domain names), if any, for this distribution.
    anycastIpListId : str, default is Undefined, optional
        ID of the Anycast static IP list that is associated with the distribution.
    arn : str, default is Undefined, optional
        ARN for the distribution. For example: arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5, where 123456789012 is your AWS account ID.
    cacheTagConfig : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderCacheTagConfig, default is Undefined, optional
        cache tag config
    callerReference : str, default is Undefined, optional
        Internal value used by CloudFront to allow future updates to the distribution configuration.
    comment : str, default is Undefined, optional
        Any comments you want to include about the distribution.
    connectionFunctionAssociation : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderConnectionFunctionAssociation, default is Undefined, optional
        connection function association
    continuousDeploymentPolicyId : str, default is Undefined, optional
        Identifier of a continuous deployment policy. This argument should only be set on a production distribution. See the aws_cloudfront_continuous_deployment_policy resource for additional details.
    customErrorResponse : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderCustomErrorResponse], default is Undefined, optional
        One or more custom error response elements (multiples allowed).
    defaultCacheBehavior : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehavior, default is Undefined, optional
        default cache behavior
    defaultRootObject : str, default is Undefined, optional
        Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL.
    domainName : str, default is Undefined, optional
        DNS domain name of either the S3 bucket, or web site of your custom origin.
    enabled : bool, default is Undefined, optional
        Whether the distribution is enabled to accept end user requests for content.
    etag : str, default is Undefined, optional
        Current version of the distribution's information. For example: E2QWRUHAPOMQZL.
    hostedZoneId : str, default is Undefined, optional
        CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID Z2FDTNDATAQYW2.
    httpVersion : str, default is Undefined, optional
        Maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3 and http3. The default is http2.
    id : str, default is Undefined, optional
        Identifier of the connection function to associate with the distribution.
    inProgressValidationBatches : float, default is Undefined, optional
        Number of invalidation batches currently in progress.
    isIpv6Enabled : bool, default is Undefined, optional
        Whether the IPv6 is enabled for the distribution.
    lastModifiedTime : str, default is Undefined, optional
        Date and time the distribution was last modified.
    loggingConfig : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderLoggingConfig, default is Undefined, optional
        logging config
    loggingV1Enabled : bool, default is Undefined, optional
        Whether V1 logging is enabled for the distribution.
    orderedCacheBehavior : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehavior], default is Undefined, optional
        Ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0.
    origin : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrigin], default is Undefined, optional
        One or more origins for this distribution (multiples allowed).
    originGroup : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginGroup], default is Undefined, optional
        One or more origin_group for this distribution (multiples allowed).
    priceClass : str, default is Undefined, optional
        Price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100.
    restrictions : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderRestrictions, default is Undefined, optional
        restrictions
    retainOnDelete : bool, default is Undefined, optional
        If this is set, the distribution needs to be deleted manually afterwards. Default: false.
    staging : bool, default is Undefined, optional
        A Boolean that indicates whether this is a staging distribution. Defaults to false.
    status : str, default is Undefined, optional
        Current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    tagsAll : {str:str}, default is Undefined, optional
        Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block.
    trustedKeyGroups : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderTrustedKeyGroups], default is Undefined, optional
        List of key group IDs that CloudFront can use to validate signed URLs or signed cookies. See the CloudFront User Guide for more information about this feature.
    trustedSigners : [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderTrustedSigners], default is Undefined, optional
        List of AWS account IDs (or self) that you want to allow to create signed URLs for private content. See the CloudFront User Guide for more information about this feature.
    viewerCertificate : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderViewerCertificate, default is Undefined, optional
        viewer certificate
    viewerMtlsConfig : CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderViewerMtlsConfig, default is Undefined, optional
        viewer mtls config
    waitForDeployment : bool, default is Undefined, optional
        If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. Default: true.
    webAclId : str, default is Undefined, optional
        Unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution. To specify a web ACL created using the latest version of AWS WAF (WAFv2), use the ACL ARN, for example aws_wafv2_web_acl.example.arn. To specify a web ACL created using AWS WAF Classic, use the ACL ID, for example aws_waf_web_acl.example.id. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned.
    """


    aliases?: [str]

    anycastIpListId?: str

    arn?: str

    cacheTagConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderCacheTagConfig

    callerReference?: str

    comment?: str

    connectionFunctionAssociation?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderConnectionFunctionAssociation

    continuousDeploymentPolicyId?: str

    customErrorResponse?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderCustomErrorResponse]

    defaultCacheBehavior?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderDefaultCacheBehavior

    defaultRootObject?: str

    domainName?: str

    enabled?: bool

    etag?: str

    hostedZoneId?: str

    httpVersion?: str

    id?: str

    inProgressValidationBatches?: float

    isIpv6Enabled?: bool

    lastModifiedTime?: str

    loggingConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderLoggingConfig

    loggingV1Enabled?: bool

    orderedCacheBehavior?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrderedCacheBehavior]

    origin?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOrigin]

    originGroup?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderOriginGroup]

    priceClass?: str

    restrictions?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderRestrictions

    retainOnDelete?: bool

    staging?: bool

    status?: str

    tags?: {str:str}

    tagsAll?: {str:str}

    trustedKeyGroups?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderTrustedKeyGroups]

    trustedSigners?: [CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderTrustedSigners]

    viewerCertificate?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderViewerCertificate

    viewerMtlsConfig?: CloudfrontAwsmUpboundIoV1beta1DistributionAtProviderViewerMtlsConfig

    waitForDeployment?: bool

    webAclId?: str




schema CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProviderTrustedKeyGroups:
    r"""
    distribution v1beta1 status at provider trusted key groups

    Attributes
    ----------
    keyGroupId : str, default is Undefined, optional
        ID of the key group that contains the public keys.
    keyPairIds : [str], default is Undefined, optional
        Set of CloudFront key pair IDs.
    """


    keyGroupId?: str

    keyPairIds?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionStatusAtProviderTrustedSigners:
    r"""
    distribution v1beta1 status at provider trusted signers

    Attributes
    ----------
    awsAccountNumber : str, default is Undefined, optional
        AWS account ID or self
    keyPairIds : [str], default is Undefined, optional
        Set of CloudFront key pair IDs.
    """


    awsAccountNumber?: str

    keyPairIds?: [str]




schema CloudfrontAwsmUpboundIoV1beta1DistributionSpecForProviderViewerMtlsConfigTrustStoreConfig:
    r"""
    The trust store configuration for viewer mTLS (maximum one).

    Attributes
    ----------
    advertiseTrustStoreCaNames : bool, default is Undefined, optional
        Whether to advertise the trust store CA names to clients. Defaults to false.
    ignoreCertificateExpiry : bool, default is Undefined, optional
        Whether to ignore certificate expiry for viewer mTLS. Defaults to false.
    trustStoreId : str, default is Undefined, optional
        Identifier of the trust store to use for viewer mTLS.
    """


    advertiseTrustStoreCaNames?: bool

    ignoreCertificateExpiry?: bool

    trustStoreId?: str

schema AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameRef:
    r"""
    Reference to a AutoscalingGroup in autoscaling to populate autoscalingGroupName.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameRefPolicy




schema AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameSelector:
    r"""
    Selector for a AutoscalingGroup in autoscaling to populate autoscalingGroupName.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameSelectorPolicy




schema AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProvider:
    r"""
    schedule v1beta1 spec for provider

    Attributes
    ----------
    autoscalingGroupName : str, default is Undefined, optional
        The name of the Auto Scaling group.
    autoscalingGroupNameRef : AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameRef, default is Undefined, optional
        autoscaling group name ref
    autoscalingGroupNameSelector : AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameSelector, default is Undefined, optional
        autoscaling group name selector
    desiredCapacity : float, default is Undefined, optional
        The initial capacity of the Auto Scaling group after the scheduled action runs and the capacity it attempts to maintain. Set to -1 if you don't want to change the desired capacity at the scheduled time. Defaults to 0.
    endTime : str, default is Undefined, optional
        The date and time for the recurring schedule to end, in UTC with the format "YYYY-MM-DDThh:mm:ssZ" (e.g. "2021-06-01T00:00:00Z").
    maxSize : float, default is Undefined, optional
        The maximum size of the Auto Scaling group. Set to -1 if you don't want to change the maximum size at the scheduled time. Defaults to 0.
    minSize : float, default is Undefined, optional
        The minimum size of the Auto Scaling group. Set to -1 if you don't want to change the minimum size at the scheduled time. Defaults to 0.
    recurrence : str, default is Undefined, optional
        The recurring schedule for this action specified using the Unix cron syntax format.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    startTime : str, default is Undefined, optional
        The date and time for the recurring schedule to start, in UTC with the format "YYYY-MM-DDThh:mm:ssZ" (e.g. "2021-06-01T00:00:00Z").
    timeZone : str, default is Undefined, optional
        Specifies the time zone for a cron expression. Valid values are the canonical names of the IANA time zones (such as Etc/GMT+9 or Pacific/Tahiti).
    """


    autoscalingGroupName?: str

    autoscalingGroupNameRef?: AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameRef

    autoscalingGroupNameSelector?: AutoscalingAwsmUpboundIoV1beta1ScheduleSpecForProviderAutoscalingGroupNameSelector

    desiredCapacity?: float

    endTime?: str

    maxSize?: float

    minSize?: float

    recurrence?: str

    region: str

    startTime?: str

    timeZone?: str




schema AutoscalingAwsmUpboundIoV1beta1ScheduleStatusAtProvider:
    r"""
    schedule v1beta1 status at provider

    Attributes
    ----------
    arn : str, default is Undefined, optional
        ARN assigned by AWS to the autoscaling schedule.
    autoscalingGroupName : str, default is Undefined, optional
        The name of the Auto Scaling group.
    desiredCapacity : float, default is Undefined, optional
        The initial capacity of the Auto Scaling group after the scheduled action runs and the capacity it attempts to maintain. Set to -1 if you don't want to change the desired capacity at the scheduled time. Defaults to 0.
    endTime : str, default is Undefined, optional
        The date and time for the recurring schedule to end, in UTC with the format "YYYY-MM-DDThh:mm:ssZ" (e.g. "2021-06-01T00:00:00Z").
    id : str, default is Undefined, optional
        id
    maxSize : float, default is Undefined, optional
        The maximum size of the Auto Scaling group. Set to -1 if you don't want to change the maximum size at the scheduled time. Defaults to 0.
    minSize : float, default is Undefined, optional
        The minimum size of the Auto Scaling group. Set to -1 if you don't want to change the minimum size at the scheduled time. Defaults to 0.
    recurrence : str, default is Undefined, optional
        The recurring schedule for this action specified using the Unix cron syntax format.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    startTime : str, default is Undefined, optional
        The date and time for the recurring schedule to start, in UTC with the format "YYYY-MM-DDThh:mm:ssZ" (e.g. "2021-06-01T00:00:00Z").
    timeZone : str, default is Undefined, optional
        Specifies the time zone for a cron expression. Valid values are the canonical names of the IANA time zones (such as Etc/GMT+9 or Pacific/Tahiti).
    """


    arn?: str

    autoscalingGroupName?: str

    desiredCapacity?: float

    endTime?: str

    id?: str

    maxSize?: float

    minSize?: float

    recurrence?: str

    region?: str

    startTime?: str

    timeZone?: str

schema S3AwsmUpboundIoV1beta1BucketAtProviderCorsRule:
    r"""
    bucket v1beta1 at provider cors rule

    Attributes
    ----------
    allowedHeaders : [str], default is Undefined, optional
        List of headers allowed.
    allowedMethods : [str], default is Undefined, optional
        One or more HTTP methods that you allow the origin to execute. Can be GET, PUT, POST, DELETE or HEAD.
    allowedOrigins : [str], default is Undefined, optional
        One or more origins you want customers to be able to access the bucket from.
    exposeHeaders : [str], default is Undefined, optional
        One or more headers in the response that you want customers to be able to access from their applications (for example, from a JavaScript XMLHttpRequest object).
    maxAgeSeconds : float, default is Undefined, optional
        Time in seconds that browser can cache the response for a preflight request.
    """


    allowedHeaders?: [str]

    allowedMethods?: [str]

    allowedOrigins?: [str]

    exposeHeaders?: [str]

    maxAgeSeconds?: float




schema S3AwsmUpboundIoV1beta1BucketAtProviderGrant:
    r"""
    bucket v1beta1 at provider grant

    Attributes
    ----------
    id : str, default is Undefined, optional
        Canonical user id to grant for. Used only when type is CanonicalUser.
    permissions : [str], default is Undefined, optional
        List of permissions to apply for grantee. Valid values are READ, WRITE, READ_ACP, WRITE_ACP, FULL_CONTROL.
    $type : str, default is Undefined, optional
        Type of grantee to apply for. Valid values are CanonicalUser and Group. AmazonCustomerByEmail is not supported.
    uri : str, default is Undefined, optional
        Uri address to grant for. Used only when type is Group.
    """


    id?: str

    permissions?: [str]

    $type?: str

    uri?: str




schema S3AwsmUpboundIoV1beta1BucketAtProviderLifecycleRule:
    r"""
    bucket v1beta1 at provider lifecycle rule

    Attributes
    ----------
    abortIncompleteMultipartUploadDays : float, default is Undefined, optional
        Number of days after initiating a multipart upload when the multipart upload must be completed.
    enabled : bool, default is Undefined, optional
        Lifecycle rule status.
    expiration : S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleExpiration, default is Undefined, optional
        expiration
    id : str, default is Undefined, optional
        Unique identifier for the rule. Must be less than or equal to 255 characters in length.
    noncurrentVersionExpiration : S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleNoncurrentVersionExpiration, default is Undefined, optional
        noncurrent version expiration
    noncurrentVersionTransition : [S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleNoncurrentVersionTransition], default is Undefined, optional
        When noncurrent object versions transition. See noncurrent_version_transition Block below for details.
    prefix : str, default is Undefined, optional
        Object key prefix identifying one or more objects to which the rule applies.
    tags : {str:str}, default is Undefined, optional
        Object tags key and value.
    transition : [S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleTransition], default is Undefined, optional
        Configuration of the object transition. See transition Block below for details.
    """


    abortIncompleteMultipartUploadDays?: float

    enabled?: bool

    expiration?: S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleExpiration

    id?: str

    noncurrentVersionExpiration?: S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleNoncurrentVersionExpiration

    noncurrentVersionTransition?: [S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleNoncurrentVersionTransition]

    prefix?: str

    tags?: {str:str}

    transition?: [S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleTransition]




schema S3AwsmUpboundIoV1beta1BucketAtProviderLogging:
    r"""
    Configuration of S3 bucket logging parameters. See logging Block below for details. Use the resource aws_s3_bucket_logging instead.

    Attributes
    ----------
    targetBucket : str, default is Undefined, optional
        Name of the bucket that will receive the log objects.
    targetPrefix : str, default is Undefined, optional
        To specify a key prefix for log objects.
    """


    targetBucket?: str

    targetPrefix?: str




schema S3AwsmUpboundIoV1beta1BucketAtProviderObjectLockConfiguration:
    r"""
    Configuration of S3 object locking. See object_lock_configuration Block below for details. Use the object_lock_enabled parameter and the resource aws_s3_bucket_object_lock_configuration instead.

    Attributes
    ----------
    objectLockEnabled : str, default is Undefined, optional
        Whether this bucket has an Object Lock configuration enabled. Valid value is Enabled. Use the top-level argument object_lock_enabled instead.
    $rule : S3AwsmUpboundIoV1beta1BucketSpecForProviderObjectLockConfigurationRule, default is Undefined, optional
        rule
    """


    objectLockEnabled?: str

    $rule?: S3AwsmUpboundIoV1beta1BucketSpecForProviderObjectLockConfigurationRule




schema S3AwsmUpboundIoV1beta1BucketAtProviderReplicationConfiguration:
    r"""
    Configuration of replication configuration. See replication_configuration Block below for details. Use the resource aws_s3_bucket_replication_configuration instead.

    Attributes
    ----------
    role : str, default is Undefined, optional
        ARN of the IAM role for Amazon S3 to assume when replicating the objects.
    rules : [S3AwsmUpboundIoV1beta1BucketSpecForProviderReplicationConfigurationRules], default is Undefined, optional
        Rules managing the replication. See rules Block below for details.
    """


    role?: str

    rules?: [S3AwsmUpboundIoV1beta1BucketSpecForProviderReplicationConfigurationRules]




schema S3AwsmUpboundIoV1beta1BucketAtProviderServerSideEncryptionConfiguration:
    r"""
    Configuration of server-side encryption configuration. See server_side_encryption_configuration Block below for details. Use the resource aws_s3_bucket_server_side_encryption_configuration instead.

    Attributes
    ----------
    $rule : S3AwsmUpboundIoV1beta1BucketSpecForProviderServerSideEncryptionConfigurationRule, default is Undefined, optional
        rule
    """


    $rule?: S3AwsmUpboundIoV1beta1BucketSpecForProviderServerSideEncryptionConfigurationRule




schema S3AwsmUpboundIoV1beta1BucketAtProviderVersioning:
    r"""
    Configuration of the S3 bucket versioning state. See versioning Block below for details. Use the resource aws_s3_bucket_versioning instead.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket.
    mfaDelete : bool, default is Undefined, optional
        Enable MFA delete for either Change the versioning state of your bucket or Permanently delete an object version. Default is false. This cannot be used to toggle this setting but is available to allow managed buckets to reflect the state in AWS
    """


    enabled?: bool

    mfaDelete?: bool




schema S3AwsmUpboundIoV1beta1BucketAtProviderWebsite:
    r"""
    Configuration of the S3 bucket website. See website Block below for details. Use the resource aws_s3_bucket_website_configuration instead.

    Attributes
    ----------
    errorDocument : str, default is Undefined, optional
        Absolute path to the document to return in case of a 4XX error.
    indexDocument : str, default is Undefined, optional
        Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders.
    redirectAllRequestsTo : str, default is Undefined, optional
        Hostname to redirect all website requests for this bucket to. Hostname can optionally be prefixed with a protocol (http:// or https://) to use when redirecting requests. The default is the protocol that is used in the original request.
    routingRules : str, default is Undefined, optional
        JSON array containing routing rules describing redirect behavior and when redirects are applied.
    """


    errorDocument?: str

    indexDocument?: str

    redirectAllRequestsTo?: str

    routingRules?: str




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderDestinationAccessControlTranslation:
    r"""
    Overrides to use for object owners on replication. See access_control_translation Block below for details. Must be used in conjunction with account_id owner override configuration.

    Attributes
    ----------
    owner : str, default is Undefined, optional
        Replica ownership. For default and valid values, see PUT bucket replication in the Amazon S3 API Reference. The only valid value is Destination.
    """


    owner?: str




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderDestinationMetrics:
    r"""
    Enables replication metrics . See metrics Block below for details.

    Attributes
    ----------
    minutes : float, default is Undefined, optional
        Threshold within which objects are to be replicated. The only valid value is 15.
    status : str, default is Undefined, optional
        Status of RTC. Either Enabled or Disabled.
    """


    minutes?: float

    status?: str




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderDestinationReplicationTime:
    r"""
    Enables S3 Replication Time Control (S3 RTC). See replication_time Block below for details.

    Attributes
    ----------
    minutes : float, default is Undefined, optional
        Threshold within which objects are to be replicated. The only valid value is 15.
    status : str, default is Undefined, optional
        Status of RTC. Either Enabled or Disabled.
    """


    minutes?: float

    status?: str




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleExpiration:
    r"""
    Configuration of the object expiration. See expiration Block below for details.

    Attributes
    ----------
    date : str, default is Undefined, optional
        Date after which you want the corresponding action to take effect.
    days : float, default is Undefined, optional
        Number of days after object creation when the specific rule action takes effect.
    expiredObjectDeleteMarker : bool, default is Undefined, optional
        On a versioned bucket (versioning-enabled or versioning-suspended bucket), you can add this element in the lifecycle configuration to direct Amazon S3 to delete expired object delete markers. This cannot be specified with Days or Date in a Lifecycle Expiration Policy.
    """


    date?: str

    days?: float

    expiredObjectDeleteMarker?: bool




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleNoncurrentVersionExpiration:
    r"""
    When noncurrent object versions expire. See noncurrent_version_expiration Block below for details.

    Attributes
    ----------
    days : float, default is Undefined, optional
        Number of days after object creation when the specific rule action takes effect.
    """


    days?: float




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleNoncurrentVersionTransition:
    r"""
    bucket v1beta1 lifecycle rule noncurrent version transition

    Attributes
    ----------
    days : float, default is Undefined, optional
        Number of days after object creation when the specific rule action takes effect.
    storageClass : str, default is Undefined, optional
        Amazon S3 storage class to which you want the object to transition.
    """


    days?: float

    storageClass?: str




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleTransition:
    r"""
    bucket v1beta1 lifecycle rule transition

    Attributes
    ----------
    date : str, default is Undefined, optional
        Date after which you want the corresponding action to take effect.
    days : float, default is Undefined, optional
        Number of days after object creation when the specific rule action takes effect.
    storageClass : str, default is Undefined, optional
        Amazon S3 storage class to which you want the object to transition.
    """


    date?: str

    days?: float

    storageClass?: str




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderObjectLockConfigurationRule:
    r"""
    Object Lock rule in place for this bucket. See object_lock_configuration.rule Block below for details.

    Attributes
    ----------
    defaultRetention : S3AwsmUpboundIoV1beta1BucketSpecForProviderRuleDefaultRetention, default is Undefined, optional
        default retention
    """


    defaultRetention?: S3AwsmUpboundIoV1beta1BucketSpecForProviderRuleDefaultRetention




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderReplicationConfigurationRules:
    r"""
    bucket v1beta1 replication configuration rules

    Attributes
    ----------
    deleteMarkerReplicationStatus : str, default is Undefined, optional
        Whether delete markers are replicated. The only valid value is Enabled. To disable, omit this argument. This argument is only valid with V2 replication configurations (i.e., when filter is used).
    destination : S3AwsmUpboundIoV1beta1BucketSpecForProviderRulesDestination, default is Undefined, optional
        destination
    $filter : S3AwsmUpboundIoV1beta1BucketSpecForProviderRulesFilter, default is Undefined, optional
        filter
    id : str, default is Undefined, optional
        Unique identifier for the rule. Must be less than or equal to 255 characters in length.
    prefix : str, default is Undefined, optional
        Object keyname prefix identifying one or more objects to which the rule applies. Must be less than or equal to 1024 characters in length.
    priority : float, default is Undefined, optional
        Priority associated with the rule. Priority should only be set if filter is configured. If not provided, defaults to 0. Priority must be unique between multiple rules.
    sourceSelectionCriteria : S3AwsmUpboundIoV1beta1BucketSpecForProviderRulesSourceSelectionCriteria, default is Undefined, optional
        source selection criteria
    status : str, default is Undefined, optional
        Status of the rule. Either Enabled or Disabled. The rule is ignored if status is not Enabled.
    """


    deleteMarkerReplicationStatus?: str

    destination?: S3AwsmUpboundIoV1beta1BucketSpecForProviderRulesDestination

    $filter?: S3AwsmUpboundIoV1beta1BucketSpecForProviderRulesFilter

    id?: str

    prefix?: str

    priority?: float

    sourceSelectionCriteria?: S3AwsmUpboundIoV1beta1BucketSpecForProviderRulesSourceSelectionCriteria

    status?: str




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderRuleApplyServerSideEncryptionByDefault:
    r"""
    Single object for setting server-side encryption by default. See apply_server_side_encryption_by_default Block below for details.

    Attributes
    ----------
    kmsMasterKeyId : str, default is Undefined, optional
        AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms.
    sseAlgorithm : str, default is Undefined, optional
        Server-side encryption algorithm to use. Valid values are AES256 and aws:kms
    """


    kmsMasterKeyId?: str

    sseAlgorithm?: str




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderRuleDefaultRetention:
    r"""
    Default retention period that you want to apply to new objects placed in this bucket. See default_retention Block below for details.

    Attributes
    ----------
    days : float, default is Undefined, optional
        Number of days that you want to specify for the default retention period.
    mode : str, default is Undefined, optional
        Default Object Lock retention mode you want to apply to new objects placed in this bucket. Valid values are GOVERNANCE and COMPLIANCE.
    years : float, default is Undefined, optional
        Number of years that you want to specify for the default retention period.
    """


    days?: float

    mode?: str

    years?: float




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderRulesDestination:
    r"""
    Destination for the rule. See destination Block below for details.

    Attributes
    ----------
    accessControlTranslation : S3AwsmUpboundIoV1beta1BucketSpecForProviderDestinationAccessControlTranslation, default is Undefined, optional
        access control translation
    accountId : str, default is Undefined, optional
        Account ID to use for overriding the object owner on replication. Must be used in conjunction with access_control_translation override configuration.
    bucket : str, default is Undefined, optional
        ARN of the S3 bucket where you want Amazon S3 to store replicas of the object identified by the rule.
    metrics : S3AwsmUpboundIoV1beta1BucketSpecForProviderDestinationMetrics, default is Undefined, optional
        metrics
    replicaKmsKeyId : str, default is Undefined, optional
        Destination KMS encryption key ARN for SSE-KMS replication. Must be used in conjunction with sse_kms_encrypted_objects source selection criteria.
    replicationTime : S3AwsmUpboundIoV1beta1BucketSpecForProviderDestinationReplicationTime, default is Undefined, optional
        replication time
    storageClass : str, default is Undefined, optional
        Amazon S3 storage class to which you want the object to transition.
    """


    accessControlTranslation?: S3AwsmUpboundIoV1beta1BucketSpecForProviderDestinationAccessControlTranslation

    accountId?: str

    bucket?: str

    metrics?: S3AwsmUpboundIoV1beta1BucketSpecForProviderDestinationMetrics

    replicaKmsKeyId?: str

    replicationTime?: S3AwsmUpboundIoV1beta1BucketSpecForProviderDestinationReplicationTime

    storageClass?: str




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderRulesFilter:
    r"""
    Filter that identifies subset of objects to which the replication rule applies. See filter Block below for details.

    Attributes
    ----------
    prefix : str, default is Undefined, optional
        Object keyname prefix that identifies subset of objects to which the rule applies. Must be less than or equal to 1024 characters in length.
    tags : {str:str}, default is Undefined, optional
        Map of tags that identifies subset of objects to which the rule applies. The rule applies only to objects having all the tags in its tagset.
    """


    prefix?: str

    tags?: {str:str}




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderRulesSourceSelectionCriteria:
    r"""
    Special object selection criteria. See source_selection_criteria Block below for details.

    Attributes
    ----------
    sseKmsEncryptedObjects : S3AwsmUpboundIoV1beta1BucketSpecForProviderSourceSelectionCriteriaSseKmsEncryptedObjects, default is Undefined, optional
        sse kms encrypted objects
    """


    sseKmsEncryptedObjects?: S3AwsmUpboundIoV1beta1BucketSpecForProviderSourceSelectionCriteriaSseKmsEncryptedObjects




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderServerSideEncryptionConfigurationRule:
    r"""
    Single object for server-side encryption by default configuration. See server_side_encryption_configuration.rule Block below for details.

    Attributes
    ----------
    applyServerSideEncryptionByDefault : S3AwsmUpboundIoV1beta1BucketSpecForProviderRuleApplyServerSideEncryptionByDefault, default is Undefined, optional
        apply server side encryption by default
    bucketKeyEnabled : bool, default is Undefined, optional
        Whether or not to use Amazon S3 Bucket Keys for SSE-KMS.
    """


    applyServerSideEncryptionByDefault?: S3AwsmUpboundIoV1beta1BucketSpecForProviderRuleApplyServerSideEncryptionByDefault

    bucketKeyEnabled?: bool




schema S3AwsmUpboundIoV1beta1BucketSpecForProviderSourceSelectionCriteriaSseKmsEncryptedObjects:
    r"""
    Match SSE-KMS encrypted objects. See sse_kms_encrypted_objects Block below for details. If specified, replica_kms_key_id in destination must be specified as well.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket.
    """


    enabled?: bool




schema S3AwsmUpboundIoV1beta1BucketSpecForProvider:
    r"""
    bucket v1beta1 spec for provider

    Attributes
    ----------
    bucketNamespace : str, default is Undefined, optional
        Namespace for the bucket. Determines bucket naming scope. Valid values: account-regional, global. Defaults to global (AWS).
    forceDestroy : bool, default is Undefined, optional
        Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work.
    objectLockEnabled : bool, default is Undefined, optional
        Whether this bucket has an Object Lock configuration enabled. Valid values are true or false. This argument is not supported in all regions or partitions.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    """


    bucketNamespace?: str

    forceDestroy?: bool

    objectLockEnabled?: bool

    region: str

    tags?: {str:str}




schema S3AwsmUpboundIoV1beta1BucketStatusAtProvider:
    r"""
    bucket v1beta1 status at provider

    Attributes
    ----------
    accelerationStatus : str, default is Undefined, optional
        Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended. Cannot be used in cn-north-1 or us-gov-west-1. Use the resource aws_s3_bucket_accelerate_configuration instead.
    acl : str, default is Undefined, optional
        Canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write. Defaults to private. Conflicts with grant. Use the resource aws_s3_bucket_acl instead.
    arn : str, default is Undefined, optional
        ARN of the bucket. Will be of format arn:aws:s3:::bucketname.
    bucketDomainName : str, default is Undefined, optional
        Bucket domain name. Will be of format bucketname.s3.amazonaws.com.
    bucketNamespace : str, default is Undefined, optional
        Namespace for the bucket. Determines bucket naming scope. Valid values: account-regional, global. Defaults to global (AWS).
    bucketRegion : str, default is Undefined, optional
        AWS region this bucket resides in.
    bucketRegionalDomainName : str, default is Undefined, optional
        Bucket region-specific domain name. The bucket domain name including the region name. Please refer to the S3 endpoints reference for format. Note: AWS CloudFront allows specifying an S3 region-specific endpoint when creating an S3 origin. This will prevent redirect issues from CloudFront to the S3 Origin URL. For more information, see the Virtual Hosted-Style Requests for Other Regions section in the AWS S3 User Guide.
    corsRule : [S3AwsmUpboundIoV1beta1BucketAtProviderCorsRule], default is Undefined, optional
        Rule of Cross-Origin Resource Sharing. See cors_rule Block below for details. Use the resource aws_s3_bucket_cors_configuration instead.
    forceDestroy : bool, default is Undefined, optional
        Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work.
    grant : [S3AwsmUpboundIoV1beta1BucketAtProviderGrant], default is Undefined, optional
        ACL policy grant. See grant Block below for details. Conflicts with acl. Use the resource aws_s3_bucket_acl instead.
    hostedZoneId : str, default is Undefined, optional
        Route 53 Hosted Zone ID for this bucket's region.
    id : str, default is Undefined, optional
        Name of the bucket.
    lifecycleRule : [S3AwsmUpboundIoV1beta1BucketAtProviderLifecycleRule], default is Undefined, optional
        Configuration of object lifecycle management. See lifecycle_rule Block below for details. Use the resource aws_s3_bucket_lifecycle_configuration instead.
    logging : S3AwsmUpboundIoV1beta1BucketAtProviderLogging, default is Undefined, optional
        logging
    objectLockConfiguration : S3AwsmUpboundIoV1beta1BucketAtProviderObjectLockConfiguration, default is Undefined, optional
        object lock configuration
    objectLockEnabled : bool, default is Undefined, optional
        Whether this bucket has an Object Lock configuration enabled. Valid values are true or false. This argument is not supported in all regions or partitions.
    policy : str, default is Undefined, optional
        Valid bucket policy JSON document. In this case, please make sure you use the verbose/specific version of the policy. Use the resource aws_s3_bucket_policy instead.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    replicationConfiguration : S3AwsmUpboundIoV1beta1BucketAtProviderReplicationConfiguration, default is Undefined, optional
        replication configuration
    requestPayer : str, default is Undefined, optional
        Who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. By default, the owner of the S3 bucket would incur the costs of any data transfer. See Requester Pays Buckets developer guide for more information. Use the resource aws_s3_bucket_request_payment_configuration instead.
    serverSideEncryptionConfiguration : S3AwsmUpboundIoV1beta1BucketAtProviderServerSideEncryptionConfiguration, default is Undefined, optional
        server side encryption configuration
    tags : {str:str}, default is Undefined, optional
        Key-value map of resource tags.
    tagsAll : {str:str}, default is Undefined, optional
        Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block.
    versioning : S3AwsmUpboundIoV1beta1BucketAtProviderVersioning, default is Undefined, optional
        versioning
    website : S3AwsmUpboundIoV1beta1BucketAtProviderWebsite, default is Undefined, optional
        website
    websiteDomain : str, default is Undefined, optional
        (Deprecated) Domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. Use the resource aws_s3_bucket_website_configuration instead.
    websiteEndpoint : str, default is Undefined, optional
        (Deprecated) Website endpoint, if the bucket is configured with a website. If not, this will be an empty string. Use the resource aws_s3_bucket_website_configuration instead.
    """


    accelerationStatus?: str

    acl?: str

    arn?: str

    bucketDomainName?: str

    bucketNamespace?: str

    bucketRegion?: str

    bucketRegionalDomainName?: str

    corsRule?: [S3AwsmUpboundIoV1beta1BucketAtProviderCorsRule]

    forceDestroy?: bool

    grant?: [S3AwsmUpboundIoV1beta1BucketAtProviderGrant]

    hostedZoneId?: str

    id?: str

    lifecycleRule?: [S3AwsmUpboundIoV1beta1BucketAtProviderLifecycleRule]

    logging?: S3AwsmUpboundIoV1beta1BucketAtProviderLogging

    objectLockConfiguration?: S3AwsmUpboundIoV1beta1BucketAtProviderObjectLockConfiguration

    objectLockEnabled?: bool

    policy?: str

    region?: str

    replicationConfiguration?: S3AwsmUpboundIoV1beta1BucketAtProviderReplicationConfiguration

    requestPayer?: str

    serverSideEncryptionConfiguration?: S3AwsmUpboundIoV1beta1BucketAtProviderServerSideEncryptionConfiguration

    tags?: {str:str}

    tagsAll?: {str:str}

    versioning?: S3AwsmUpboundIoV1beta1BucketAtProviderVersioning

    website?: S3AwsmUpboundIoV1beta1BucketAtProviderWebsite

    websiteDomain?: str

    websiteEndpoint?: str

schema S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketRef:
    r"""
    Reference to a Bucket in s3 to populate bucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketRefPolicy




schema S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketSelector:
    r"""
    Selector for a Bucket in s3 to populate bucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketSelectorPolicy




schema S3AwsmUpboundIoV1beta1BucketPolicySpecForProvider:
    r"""
    bucket policy v1beta1 spec for provider

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        Name of the bucket to which to apply the policy.
    bucketRef : S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketRef, default is Undefined, optional
        bucket ref
    bucketSelector : S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketSelector, default is Undefined, optional
        bucket selector
    policy : str, default is Undefined, optional
        Text of the policy. Although this is a bucket policy rather than an IAM policy, the aws_iam_policy_document data source may be used, so long as it specifies a principal. Note: Bucket policies are limited to 20 KB in size.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    """


    bucket?: str

    bucketRef?: S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketRef

    bucketSelector?: S3AwsmUpboundIoV1beta1BucketPolicySpecForProviderBucketSelector

    policy?: str

    region: str




schema S3AwsmUpboundIoV1beta1BucketPolicyStatusAtProvider:
    r"""
    bucket policy v1beta1 status at provider

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        Name of the bucket to which to apply the policy.
    id : str, default is Undefined, optional
        id
    policy : str, default is Undefined, optional
        Text of the policy. Although this is a bucket policy rather than an IAM policy, the aws_iam_policy_document data source may be used, so long as it specifies a principal. Note: Bucket policies are limited to 20 KB in size.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    """


    bucket?: str

    id?: str

    policy?: str

    region?: str

schema S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"




schema S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketRef:
    r"""
    Reference to a Bucket in s3 to populate bucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketRefPolicy




schema S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketSelector:
    r"""
    Selector for a Bucket in s3 to populate bucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketSelectorPolicy




schema S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProvider:
    r"""
    bucket public access block v1beta1 spec for provider

    Attributes
    ----------
    blockPublicAcls : bool, default is Undefined, optional
        Whether Amazon S3 should block public ACLs for this bucket. Defaults to false. Enabling this setting does not affect existing policies or ACLs. When set to true, PUT Bucket ACL and PUT Object ACL calls fail if the specified ACL allows public access, and PUT Object calls fail if the request includes an object ACL.
    blockPublicPolicy : bool, default is Undefined, optional
        Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy. When set to true, Amazon S3 rejects calls to PUT Bucket policy if the specified bucket policy allows public access.
    bucket : str, default is Undefined, optional
        S3 Bucket to which this Public Access Block configuration should be applied.
    bucketRef : S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketRef, default is Undefined, optional
        bucket ref
    bucketSelector : S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketSelector, default is Undefined, optional
        bucket selector
    ignorePublicAcls : bool, default is Undefined, optional
        Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set. When set to true, Amazon S3 ignores public ACLs on this bucket and any objects that it contains.
    region : str, default is Undefined, required
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    restrictPublicBuckets : bool, default is Undefined, optional
        Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked. When set to true, only the bucket owner and AWS services can access this bucket if it has a public policy.
    skipDestroy : bool, default is Undefined, optional
        Whether to retain the public access block upon destruction. If set to true, the resource is simply removed from state instead. This may be desirable in certain scenarios to prevent the removal of a public access block before deletion of the associated bucket.
    """


    blockPublicAcls?: bool

    blockPublicPolicy?: bool

    bucket?: str

    bucketRef?: S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketRef

    bucketSelector?: S3AwsmUpboundIoV1beta1BucketPublicAccessBlockSpecForProviderBucketSelector

    ignorePublicAcls?: bool

    region: str

    restrictPublicBuckets?: bool

    skipDestroy?: bool




schema S3AwsmUpboundIoV1beta1BucketPublicAccessBlockStatusAtProvider:
    r"""
    bucket public access block v1beta1 status at provider

    Attributes
    ----------
    blockPublicAcls : bool, default is Undefined, optional
        Whether Amazon S3 should block public ACLs for this bucket. Defaults to false. Enabling this setting does not affect existing policies or ACLs. When set to true, PUT Bucket ACL and PUT Object ACL calls fail if the specified ACL allows public access, and PUT Object calls fail if the request includes an object ACL.
    blockPublicPolicy : bool, default is Undefined, optional
        Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy. When set to true, Amazon S3 rejects calls to PUT Bucket policy if the specified bucket policy allows public access.
    bucket : str, default is Undefined, optional
        S3 Bucket to which this Public Access Block configuration should be applied.
    id : str, default is Undefined, optional
        Name of the S3 bucket the configuration is attached to
    ignorePublicAcls : bool, default is Undefined, optional
        Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set. When set to true, Amazon S3 ignores public ACLs on this bucket and any objects that it contains.
    region : str, default is Undefined, optional
        Region where this resource will be managed. Defaults to the Region set in the provider configuration.
        Region is the region you'd like your resource to be created in.
    restrictPublicBuckets : bool, default is Undefined, optional
        Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked. When set to true, only the bucket owner and AWS services can access this bucket if it has a public policy.
    skipDestroy : bool, default is Undefined, optional
        Whether to retain the public access block upon destruction. If set to true, the resource is simply removed from state instead. This may be desirable in certain scenarios to prevent the removal of a public access block before deletion of the associated bucket.
    """


    blockPublicAcls?: bool

    blockPublicPolicy?: bool

    bucket?: str

    id?: str

    ignorePublicAcls?: bool

    region?: str

    restrictPublicBuckets?: bool

    skipDestroy?: bool

schema CloudfrontAwsmUpboundIoV1beta1OriginAccessControlSpecForProvider:
    r"""
    origin access control v1beta1 spec for provider

    Attributes
    ----------
    description : str, default is Undefined, optional
        The description of the Origin Access Control.
    name : str, default is Undefined, optional
        A name that identifies the Origin Access Control.
    originAccessControlOriginType : str, default is Undefined, optional
        The type of origin that this Origin Access Control is for. Valid values are lambda, mediapackagev2, mediastore, and s3.
    signingBehavior : str, default is Undefined, optional
        Specifies which requests CloudFront signs. Specify always for the most common use case. Allowed values: always, never, and no-override.
    signingProtocol : str, default is Undefined, optional
        Determines how CloudFront signs (authenticates) requests. The only valid value is sigv4.
    """


    description?: str

    name?: str

    originAccessControlOriginType?: str

    signingBehavior?: str

    signingProtocol?: str




schema CloudfrontAwsmUpboundIoV1beta1OriginAccessControlStatusAtProvider:
    r"""
    origin access control v1beta1 status at provider

    Attributes
    ----------
    arn : str, default is Undefined, optional
        The Origin Access Control ARN.
    description : str, default is Undefined, optional
        The description of the Origin Access Control.
    etag : str, default is Undefined, optional
        The current version of this Origin Access Control.
    id : str, default is Undefined, optional
        The unique identifier of this Origin Access Control.
    name : str, default is Undefined, optional
        A name that identifies the Origin Access Control.
    originAccessControlOriginType : str, default is Undefined, optional
        The type of origin that this Origin Access Control is for. Valid values are lambda, mediapackagev2, mediastore, and s3.
    signingBehavior : str, default is Undefined, optional
        Specifies which requests CloudFront signs. Specify always for the most common use case. Allowed values: always, never, and no-override.
    signingProtocol : str, default is Undefined, optional
        Determines how CloudFront signs (authenticates) requests. The only valid value is sigv4.
    """


    arn?: str

    description?: str

    etag?: str

    id?: str

    name?: str

    originAccessControlOriginType?: str

    signingBehavior?: str

    signingProtocol?: str


