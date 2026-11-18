import .cdnwebservice

_cdnWebServiceOxr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "CdnWebService"
    metadata.name = "shop-cdn"
    spec = {
        domainName = "cdn.shop.example.com"
        originDomainName = "origin.shop.example.com"
        hostedZoneId = "Z123EXAMPLE"
        origin = {
            region = "ap-southeast-1"
            vpcId = "vpc-0123456789abcdef0"
            loadBalancerSubnetIds = ["subnet-pub-aaaa", "subnet-pub-bbbb"]
            loadBalancerSecurityGroupIds = ["sg-lb0123456789abcd"]
            instanceSubnetIds = ["subnet-priv-aaaa", "subnet-priv-bbbb"]
            instanceSecurityGroupIds = ["sg-inst0123456789ab"]
            imageId = "ami-0123456789abcdef0"
        }
    }
}

_cdnViewerCertificateArn = "arn:aws:acm:us-east-1:111111111111:certificate/viewer"
_cdnOriginDnsName = "origin-1234567890.ap-southeast-1.elb.amazonaws.com"
_cdnDistributionDomainName = "d111abcdef8.cloudfront.net"

# The viewer certificate is requested but not issued yet.
_cdnViewerCertificatePending = {Resource = {status = {
    certificateArn = _cdnViewerCertificateArn
    validated = False
}}}

# The viewer certificate is issued. It carries conditions too, as a real XR does.
_cdnViewerCertificateValidated = {Resource = {status = {
    certificateArn = _cdnViewerCertificateArn
    validated = True
    conditions = [{"type" = "Ready", status = "True"}]
}}}

# The origin web service has its load balancer, so its origin name resolves.
_cdnOriginReady = {Resource = {status = {
    url = "https://origin.shop.example.com"
    loadBalancerDnsName = _cdnOriginDnsName
    conditions = [{"type" = "Ready", status = "True"}]
}}}

# CloudFront has created the distribution and reports its domain name.
_cdnDistributionObserved = {Resource = {status = {atProvider = {
    arn = "arn:aws:cloudfront::111111111111:distribution/EDISTEXAMPLE"
    domainName = _cdnDistributionDomainName
    hostedZoneId = "Z2FDTNDATAQYW2"
    id = "EDISTEXAMPLE"
}}}}

# Everything is ready up to the distribution.
_cdnReadyForDistribution = {
    origin = _cdnOriginReady
    "viewer-certificate" = _cdnViewerCertificateValidated
}

_cdnWebServiceKinds = lambda result -> [str] {
    [r.kind for r in result]
}

# Cold start: the origin web service and the viewer certificate are requested. Nothing else yet.
test_cdnWebService_cold_start_requests_the_origin_and_the_viewer_certificate = lambda {
    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, {})

    assert _cdnWebServiceKinds(result) == ["WebService", "TlsCertificate"]
}

test_cdnWebService_origin_is_a_web_service_at_the_origin_name = lambda {
    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, {})

    origin = result[0]
    assert origin.apiVersion == "platform.demotw.com/v1alpha1"
    assert origin.kind == "WebService"
    assert origin.metadata.name == "shop-cdn-origin"
    assert origin.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "origin"
    assert origin.spec.domainName == "origin.shop.example.com"
    assert origin.spec.hostedZoneId == "Z123EXAMPLE"
    assert origin.spec.region == "ap-southeast-1"
    assert origin.spec.vpcId == "vpc-0123456789abcdef0"
    assert origin.spec.loadBalancerSubnetIds == ["subnet-pub-aaaa", "subnet-pub-bbbb"]
    assert origin.spec.loadBalancerSecurityGroupIds == ["sg-lb0123456789abcd"]
    assert origin.spec.instanceSubnetIds == ["subnet-priv-aaaa", "subnet-priv-bbbb"]
    assert origin.spec.instanceSecurityGroupIds == ["sg-inst0123456789ab"]
    assert origin.spec.imageId == "ami-0123456789abcdef0"
}

test_cdnWebService_origin_passes_its_instance_settings_through = lambda {
    oxr = {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "CdnWebService"
        metadata.name = "shop-cdn"
        spec = {
            domainName = "cdn.shop.example.com"
            originDomainName = "origin.shop.example.com"
            hostedZoneId = "Z123EXAMPLE"
            origin = {
                region = "ap-southeast-1"
                vpcId = "vpc-0123456789abcdef0"
                loadBalancerSubnetIds = ["subnet-pub-aaaa", "subnet-pub-bbbb"]
                loadBalancerSecurityGroupIds = ["sg-lb0123456789abcd"]
                instanceSubnetIds = ["subnet-priv-aaaa", "subnet-priv-bbbb"]
                instanceSecurityGroupIds = ["sg-inst0123456789ab"]
                imageId = "ami-0123456789abcdef0"
                targetPort = 8080
                userData = "#!/bin/bash\necho hello\n"
            }
        }
    }

    result = cdnwebservice.composeCdnWebService(oxr, {})

    assert result[0].spec.targetPort == 8080
    assert result[0].spec.userData == "#!/bin/bash\necho hello\n"
}

# CloudFront only reads viewer certificates from us-east-1, whatever region the origin runs in.
test_cdnWebService_viewer_certificate_is_requested_in_us_east_1 = lambda {
    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, {})

    cert = result[1]
    assert cert.apiVersion == "platform.demotw.com/v1alpha1"
    assert cert.kind == "TlsCertificate"
    assert cert.metadata.name == "shop-cdn-viewer-certificate"
    assert cert.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "viewer-certificate"
    assert cert.spec.domainName == "cdn.shop.example.com"
    assert cert.spec.hostedZoneId == "Z123EXAMPLE"
    assert cert.spec.region == "us-east-1"
}

# The viewer certificate is requested but not issued: CloudFront waits for it.
test_cdnWebService_no_distribution_until_the_viewer_certificate_is_issued = lambda {
    ocds = {origin = _cdnOriginReady, "viewer-certificate" = _cdnViewerCertificatePending}

    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, ocds)

    assert "Distribution" not in _cdnWebServiceKinds(result)
}

# The certificate is issued, but the origin has no load balancer name yet: CloudFront has nothing to reach.
test_cdnWebService_no_distribution_until_the_origin_has_a_load_balancer = lambda {
    ocds = {"viewer-certificate" = _cdnViewerCertificateValidated}

    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, ocds)

    assert "Distribution" not in _cdnWebServiceKinds(result)
}

# Once both are ready, the distribution serves the origin over HTTPS with the viewer certificate.
test_cdnWebService_distribution_serves_the_origin_over_https = lambda {
    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, _cdnReadyForDistribution)

    dist = [r for r in result if r.kind == "Distribution"][0]
    assert dist.apiVersion == "cloudfront.aws.m.upbound.io/v1beta1"
    assert dist.metadata.annotations["krm.kcl.dev/composition-resource-name"] == "distribution"
    fwd = dist.spec.forProvider
    assert fwd.aliases == ["cdn.shop.example.com"]
    assert fwd.enabled
    assert fwd.origin[0].domainName == "origin.shop.example.com"
    assert fwd.origin[0].customOriginConfig.originProtocolPolicy == "https-only"
    assert fwd.origin[0].customOriginConfig.httpsPort == 443
    assert fwd.origin[0].customOriginConfig.originSslProtocols == ["TLSv1.2"]
    assert fwd.viewerCertificate.acmCertificateArn == _cdnViewerCertificateArn
    assert fwd.viewerCertificate.sslSupportMethod == "sni-only"
    assert fwd.viewerCertificate.minimumProtocolVersion == "TLSv1.2_2021"
}

test_cdnWebService_distribution_redirects_viewers_to_https_and_does_not_cache = lambda {
    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, _cdnReadyForDistribution)

    dist = [r for r in result if r.kind == "Distribution"][0]
    behaviour = dist.spec.forProvider.defaultCacheBehavior
    assert behaviour.targetOriginId == dist.spec.forProvider.origin[0].originId
    assert behaviour.viewerProtocolPolicy == "redirect-to-https"
    # AWS managed policies: CachingDisabled, and AllViewerExceptHostHeader so the origin sees its own name.
    assert behaviour.cachePolicyId == "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    assert behaviour.originRequestPolicyId == "b689b0a8-53d0-40ab-baf2-68738e2966ac"
}

# No alias until CloudFront reports the distribution's domain name.
test_cdnWebService_no_alias_until_the_distribution_is_observed = lambda {
    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, _cdnReadyForDistribution)

    assert "Record" not in _cdnWebServiceKinds(result)
}

test_cdnWebService_points_the_public_name_at_the_distribution = lambda {
    ocds = {origin = _cdnOriginReady, "viewer-certificate" = _cdnViewerCertificateValidated, distribution = _cdnDistributionObserved}

    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, ocds)

    records = [r for r in result if r.kind == "Record"]
    assert len(records) == 2
    a = records[0]
    assert a.apiVersion == "route53.aws.m.upbound.io/v1beta1"
    assert a.spec.forProvider.zoneId == "Z123EXAMPLE"
    assert a.spec.forProvider.name == "cdn.shop.example.com"
    assert a.spec.forProvider["type"] == "A"
    assert a.spec.forProvider.alias.name == _cdnDistributionDomainName
    assert a.spec.forProvider.alias.zoneId == "Z2FDTNDATAQYW2"
    assert records[1].spec.forProvider["type"] == "AAAA"
}

# No status until the public name points at the distribution.
test_cdnWebService_reports_no_status_before_the_alias_exists = lambda {
    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, _cdnReadyForDistribution)

    assert "CdnWebService" not in _cdnWebServiceKinds(result)
}

test_cdnWebService_reports_url_and_distribution_once_the_alias_exists = lambda {
    ocds = {origin = _cdnOriginReady, "viewer-certificate" = _cdnViewerCertificateValidated, distribution = _cdnDistributionObserved}

    result = cdnwebservice.composeCdnWebService(_cdnWebServiceOxr, ocds)

    xr = result[-1]
    assert xr.kind == "CdnWebService"
    assert xr.apiVersion == "platform.demotw.com/v1alpha1"
    assert xr.metadata.name == "shop-cdn"
    assert xr.status.url == "https://cdn.shop.example.com"
    assert xr.status.distributionDomainName == _cdnDistributionDomainName
}
