"""
Example: Static website composition instance
This file demonstrates how to create a static website on S3 with CloudFront
"""

from composition_s3staticwebsite import S3StaticWebsite

# Simple static website with minimal config
simple_site = S3StaticWebsite {
    spec = {
        siteName = "my-simple-site"
        indexDocument = "index.html"
        errorDocument = "404.html"
    }
}

# Production website with custom domain and ACM certificate
production_site = S3StaticWebsite {
    spec = {
        siteName = "my-production-site"
        domainName = "example.com"
        certificateArn = "arn:aws:acm:us-east-1:123456789012:certificate/abc123"

        indexDocument = "index.html"
        errorDocument = "404.html"

        enableVersioning = True
        cacheTtlSeconds = 7200
        priceClass = "PriceClass_100"
        enableCompressionAutomatically = True

        blockPublicAcl = True
        blockPublicPolicy = True

        tags = {
            "environment" = "production"
            "team" = "platform"
            "cost-center" = "engineering"
        }
    }
}

# Development site with longer cache TTL
dev_site = S3StaticWebsite {
    spec = {
        siteName = "my-dev-site"
        indexDocument = "index.html"

        cacheTtlSeconds = 300  # 5 minutes for quick updates
        priceClass = "PriceClass_All"
        enableVersioning = True

        tags = {
            "environment" = "development"
            "team" = "frontend"
        }
    }
}
