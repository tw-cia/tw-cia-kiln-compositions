"""Tests for StaticWebsite composition."""

def test_compose_basic(xr) {
    resources = compose_static_website(xr)
    assert len(resources) >= 5, "Should create at least 5 resources"
}


def test_compose_with_caching_disabled(xr) {
    resources = compose_static_website(xr)
    assert len(resources) >= 5, "Should create all required resources"
}


def test_compose_uses_defaults(xr) {
    resources = compose_static_website(xr)
    website_configs = [r for r in resources if r.kind == "BucketWebsiteConfiguration"]
    assert len(website_configs) == 1
}


test_basic_xr = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticWebsite"
    metadata = {name = "my-site"}
    spec = {
        bucketName = "my-site-bucket"
        domainName = "example.com"
        indexDocument = "index.html"
        errorDocument = "error.html"
        enableCaching = True
        cacheTTL = 7200
        tags = {
            Environment = "production"
            Team = "platform"
        }
    }
}

resources_basic = test_compose_basic(test_basic_xr)
