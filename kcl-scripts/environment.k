import .schemas_compositions

# Environment: a named network (such as prod) with the applications that run in
# it. Each application is a WebFleet child XR, placed in the environment's
# subnets, and named "<environment>-<application>" in AWS. The environment reports
# each fleet's load balancer DNS name once the child has one.
composeEnvironment = lambda oxr, ocds -> [any] {
    # Checked before the typed binding below: a VPC to create is a dict that does
    # not match NetworkSpec, so KCL would otherwise fail with a type error first.
    assert oxr.spec.network?.vpcId is not Undefined, "creating a VPC is not supported yet"
    spec: schemas_compositions.EnvironmentSpec = oxr.spec

    # Bind XR values to locals before building resource dicts (see kcl-primer).
    _envName = spec.name
    _region = spec.region
    _network = spec.network
    _apps = spec.webFleets or []

    # The child XR's name in the composition, and the observed child's status.
    _childName = lambda app -> str {"web-fleet-${app.name}"}
    _observedDnsName = lambda app -> any {
        ocds[_childName(app)]?.Resource?.status?.loadBalancerDnsName
    }

    _webFleets = [{
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "WebFleet"
        metadata.annotations = {"krm.kcl.dev/composition-resource-name" = _childName(app)}
        spec = {
            name = "${_envName}-${app.name}"
            region = _region
            network = _network
            imageId = app.imageId
            instanceType = app.instanceType
            port = app.port
            healthCheckPath = app.healthCheckPath
            minSize = app.minSize
            maxSize = app.maxSize
            domain = app.domain
            **({"userData" = app.userData} if app.userData else {})
            **({"scalingSchedules" = app.scalingSchedules} if app.scalingSchedules else {})
        }
    } for app in _apps]

    _dnsNames = {app.name: _observedDnsName(app) for app in _apps if _observedDnsName(app)}

    _xr = {
        apiVersion = oxr.apiVersion
        kind = oxr.kind
        metadata = oxr.metadata
        status = schemas_compositions.EnvironmentStatus {webFleetDnsNames = _dnsNames}
    } if _dnsNames else None

    _webFleets + ([_xr] if _xr else [])
}
