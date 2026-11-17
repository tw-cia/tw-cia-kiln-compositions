# Static Site Composition

A Kiln composition for deploying static websites using AWS S3 and CloudFront with secure Origin Access Control (OAC).

## Overview

The `staticsite.kcl` composition creates a complete static website infrastructure with:

- **S3 Bucket**: Private bucket for website content
- **Public Access Block**: Enforces private access to the bucket
- **Origin Access Control**: CloudFront OAC for secure S3 access
- **CloudFront Distribution**: Global CDN with static site optimizations
- **Bucket Policy**: Allows only CloudFront (via OAC) to read objects

The site is served on CloudFront's `.cloudfront.net` domain. Users can add custom domains and SSL certificates separately.

## Composition Flow

1. **Create S3 bucket** with specified region and tags
2. **Block all public access** to the bucket
3. **Create CloudFront OAC** for secure S3 access
4. **Wait for OAC ID** to be observed (returned from AWS)
5. **Create CloudFront distribution** using the OAC
6. **Wait for distribution ARN** to be observed
7. **Create bucket policy** limiting access to the specific CloudFront distribution

The composition handles dependencies automatically—resources that require observed state from previous resources only get created after that state is available.

## Configuration

### Required Fields

- **bucketName**: Globally unique S3 bucket name
  - Must be valid S3 bucket name (lowercase, 3-63 chars, no underscores, etc.)
  - Used as `external-name` for all composed resources

### Optional Fields

- **indexDocument** (default: `index.html`)
  - Root object returned for requests to `/`
  - Common values: `index.html`, `index.htm`

- **priceClass** (default: `PriceClass_100`)
  - CloudFront price tier:
    - `PriceClass_100`: North America, Europe, Asia
    - `PriceClass_200`: Above + Middle East, Africa
    - `PriceClass_All`: All global edge locations
  - Choose based on target audience geography

- **region** (default: `us-east-1`)
  - AWS region for S3 bucket
  - CloudFront itself is global with no region

- **tags** (optional)
  - Key-value pairs applied to S3 bucket and CloudFront distribution
  - Example: `{environment = "production", team = "platform"}`

## Usage

### Minimal Example

```kcl
site = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticSite"
    metadata.name = "my-site"
    spec.bucketName = "my-unique-bucket-name"
}
```

### Full Example

```kcl
site = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticSite"
    metadata = {
        name = "marketing-site"
        namespace = "websites"
    }
    spec = {
        bucketName = "acme-marketing-prod"
        indexDocument = "index.html"
        region = "us-east-1"
        priceClass = "PriceClass_All"
        tags = {
            environment = "production"
            team = "marketing"
        }
    }
}
```

## Composition Outputs

After composition, the `status` field contains:

- **bucketArn**: ARN of the S3 bucket (e.g., `arn:aws:s3:::bucket-name`)
- **bucketDomainName**: S3 regional domain name (e.g., `bucket.s3.us-east-1.amazonaws.com`)
- **distributionId**: CloudFront distribution ID (e.g., `E1234567890ABC`)
- **distributionArn**: CloudFront distribution ARN
- **distributionDomainName**: CloudFront domain (e.g., `d1234567890.cloudfront.net`)

Use `distributionDomainName` to create DNS CNAME records pointing your custom domain to CloudFront.

## Implementation Details

### Resource Names

Composed resources use the following names (for tracking in composition state):

- `bucket`: S3 Bucket
- `bucket-public-access-block`: Public Access Block
- `origin-access-control`: CloudFront OAC
- `distribution`: CloudFront Distribution
- `bucket-policy`: S3 Bucket Policy

These are set via the `krm.kcl.dev/composition-resource-name` annotation on each resource.

### Deterministic Values

The S3 regional domain name is deterministic (not assigned by AWS):

```
${bucketName}.s3.${region}.amazonaws.com
```

This allows the CloudFront origin to be configured without waiting for S3 to observe the bucket.

### Caching Policy

The composition uses the AWS-managed `Managed-CachingOptimized` cache policy:
- Policy ID: `658327ea-f89d-4fab-a63d-7e88639e58f6`
- Optimizes caching for static content
- Stable across all AWS accounts and regions

## Security

### OAC vs OAI

The composition uses CloudFront Origin Access Control (OAC), which is the modern replacement for Origin Access Identity (OAI):

- **OAC**: Supports all S3 regions, sigv4 signing, better security
- **OAI**: Legacy, limited to us-east-1 without workarounds

### Bucket Policy

The bucket policy restricts access to:
- Principal: `cloudfront.amazonaws.com`
- Action: `s3:GetObject`
- Resource: All objects in the bucket (`arn:aws:s3:::bucket/*`)
- Condition: Source ARN must be the specific CloudFront distribution

This ensures only CloudFront can read from the bucket.

### HTTPS

CloudFront is configured to:
- Redirect HTTP to HTTPS
- Use CloudFront's default certificate (*.cloudfront.net)
- Support custom certificates (not composed, users add via CloudFront)

## Examples

See the `examples/` directory for:

- `staticsite_example.kcl`: Basic usage patterns
- `staticsite_advanced.kcl`: Advanced patterns (site lists, factories, composition output usage)

## Composing with Other Resources

You can combine this composition with other AWS resources:

**Route53 DNS Records** (custom domain):
```kcl
# After composition, use distributionDomainName for CNAME:
dnsRecord = {
    # Route53 A record (alias) pointing to CloudFront distribution
    # Reference the status.distributionDomainName from the composed resource
}
```

**AWS Certificate Manager** (custom domain SSL):
```kcl
# Add a certificate to CloudFront after composition
# Update the CloudFront distribution with the custom certificate
```

## Troubleshooting

### Bucket Already Exists

The composition uses `external-name` to manage existing or externally created buckets. If you get "bucket already exists" errors:

- Use a different bucket name
- Or manually associate the existing bucket by its name

### OAC or Distribution Not Created

Check that previous resources were successfully created. The composition depends on:

1. OAC requires S3 bucket (implicit dependency)
2. Distribution requires OAC ID (observed state)
3. Bucket policy requires distribution ARN (observed state)

If earlier resources fail, later ones won't be created.

### DNS Propagation

After creating the composition and DNS records:

- DNS propagation: 5 minutes to 24 hours
- CloudFront caching: 24 hours to clear fully
- S3 object updates: Immediate on S3, cached by CloudFront

## Future Enhancements

Potential additions (not currently composed):

- Custom domain + SSL certificate
- Route53 health checks
- CloudFront access logs
- S3 access logs
- WAF integration
- Lambda@Edge functions
- Terraform workspace for state management
