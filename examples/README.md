# Static Site Composition Examples

This directory contains KCL examples demonstrating how to use the `staticsite` composition to deploy static websites on AWS S3 and CloudFront.

## Files

### `staticsite_example.kcl`

Basic usage patterns showing different configuration scenarios:

- **Minimal Blog**: Uses all defaults except bucket name
  - Useful for quick testing or development
  - Defaults to `us-east-1`, `index.html`, `PriceClass_100`

- **API Documentation Site**: Full configuration with tags and custom region
  - European hosting with custom tags for cost tracking
  - Shows explicit configuration of all options

- **Global Marketing Site**: Maximum scale configuration
  - Uses `PriceClass_All` for global edge locations
  - Appropriate for high-traffic production sites

- **Staging Site**: Development environment optimized for cost
  - Lower price class to reduce staging costs
  - Tagged for quick identification

### `staticsite_advanced.kcl`

Advanced patterns for real-world scenarios:

- **Using Composition Output**: Shows how to reference status values
  - `distributionDomainName` for DNS CNAME targets
  - `bucketArn` and `bucketDomainName` for policies

- **Site Lists**: Batch creating multiple sites from configuration
  - Demonstrates iteration over site configs
  - Shows merging tags for consistency

- **Factory Functions**: Parameterized site creation
  - Lambda functions for DRY configuration
  - Environment-aware defaults

- **Mixed Resources**: Combining staticsite with other AWS resources
  - Example structure for Route53 integration
  - Shows how to reference composition outputs

## Common Patterns

### 1. Simple Blog Site

```kcl
site = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticSite"
    metadata.name = "my-blog"
    spec.bucketName = "my-blog-static-2024"
}
```

### 2. Production Site with Custom Domain (Framework)

```kcl
# Step 1: Create the base site
site = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticSite"
    metadata.name = "example-com"
    spec = {
        bucketName = "example-com-static"
        region = "us-east-1"
        priceClass = "PriceClass_All"
        tags = {environment = "production"}
    }
}

# Step 2: After composition, manually create Route53 record pointing to:
# site.status.distributionDomainName
```

### 3. Regional Sites (US + EU)

```kcl
# Content served from closest edge location
sites = [
    {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "StaticSite"
        metadata.name = "us-site"
        spec = {
            bucketName = "acme-us-site"
            region = "us-east-1"
            priceClass = "PriceClass_100"
        }
    },
    {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "StaticSite"
        metadata.name = "eu-site"
        spec = {
            bucketName = "acme-eu-site"
            region = "eu-west-1"
            priceClass = "PriceClass_100"
        }
    }
]
```

### 4. Environment-Specific Configuration

```kcl
_ENV = "production"  # Set via external config/CI

createWebsite = lambda name, bucket, env="production" -> any {
    {
        apiVersion = "platform.demotw.com/v1alpha1"
        kind = "StaticSite"
        metadata = {
            name = "${name}-${env}"
            namespace = if env == "production" then "prod" else "staging"
        }
        spec = {
            bucketName = "${bucket}-${env}"
            region = "us-east-1"
            priceClass = if env == "production" then "PriceClass_All" else "PriceClass_100"
            tags = {environment = env}
        }
    }
}

# Use the factory
website = createWebsite("app", "acme-app", _ENV)
```

### 5. Using Composition Output in Other Resources

After the site composition completes, its status contains:

```kcl
# Reference the site (from composition result)
site = ...  # Result of composition

# Create Route53 CNAME record (conceptual example)
route53Record = {
    apiVersion = "route53.aws.upbound.io/v1beta1"
    kind = "Record"
    metadata.name = "example-com-alias"
    spec.forProvider = {
        zoneId = "Z1234567890ABC"
        name = "example.com"
        type = "A"
        # Alias records point directly to CloudFront
        aliasTarget = {
            name = site.status.distributionDomainName
            zoneId = "Z2FDTNDATAQYW2"  # CloudFront hosted zone ID (global)
            evaluateTargetHealth = False
        }
    }
}
```

## Running Examples

### View the KCL

```bash
cat staticsite_example.kcl
```

### Render to YAML (if Kiln CLI is available)

```bash
kiln render staticsite_example.kcl
```

### Apply to Kubernetes (with Crossplane installed)

```bash
kiln render staticsite_example.kcl | kubectl apply -f -
```

## Tips

### Bucket Naming

S3 bucket names must be:
- Globally unique across all AWS accounts
- 3-63 characters long
- Lowercase and numbers only (and hyphens, not at start/end)
- No consecutive hyphens
- Not an IP address format

Good names:
- `acme-blog-2024`
- `company-docs-prod`
- `team-static-assets`

### Price Class Selection

- **PriceClass_100** (~70% of edge locations)
  - North America, Europe, Asia
  - Cheapest option
  - Good for most use cases

- **PriceClass_200** (~90% of edge locations)
  - Adds Africa, Middle East
  - 20-30% more than PriceClass_100

- **PriceClass_All** (all edge locations)
  - Maximum global coverage
  - 2x cost of PriceClass_100
  - For latency-sensitive global audiences

### Tags Best Practices

Use tags for:

```kcl
tags = {
    environment = "production"      # dev/staging/prod
    team = "platform"               # Ownership
    cost-center = "engineering"     # Billing
    created-by = "kiln"             # Tool tracking
    purpose = "marketing"           # What it's for
}
```

### S3 Bucket Lifecycle

After composition, manage the bucket:

```bash
# Upload content
aws s3 sync ./dist/ s3://your-bucket-name/

# Set cache headers (improves CloudFront caching)
aws s3 cp s3://your-bucket-name/ s3://your-bucket-name/ \
  --recursive --metadata-directive COPY \
  --cache-control "max-age=31536000,public"

# Invalidate CloudFront cache after updates
aws cloudfront create-invalidation \
  --distribution-id <distribution-id> \
  --paths "/*"
```

## Troubleshooting

### "Bucket already exists in another AWS account"

Use a unique bucket name. Bucket names are globally unique; try:
```
<company>-<site>-<date>-<random>
```

### "Distribution not being created"

Check that:
1. The S3 bucket was created successfully
2. The OAC was created and assigned an ID
3. CloudFront has permission to access your account

Look at the composition status and resource events.

### "Files not accessible through CloudFront"

Check:
1. Files are uploaded to the bucket
2. Bucket policy allows CloudFront access
3. CloudFront distribution is `enabled = True`
4. Object ACLs are correct (should be private)

## Next Steps

1. Choose an example that matches your use case
2. Update the bucket name to something unique
3. Render and apply it to your Crossplane cluster
4. Monitor the composition status
5. Once complete, upload your content to S3
6. Create Route53 records for custom domains
7. Test the site through CloudFront

For more details, see `manifests/STATICSITE.md`.
