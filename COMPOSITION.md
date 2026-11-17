# Static Website Composition

This Kiln project includes a composition for managing static websites hosted on AWS S3 with CloudFront CDN.

## Composition Structure

### Files

- **`kcl-scripts/staticSiteComposition.k`** - Schema definition for the StaticSite custom resource
- **`kcl-scripts/staticSite.k`** - Composition logic that renders Crossplane resources
- **`examples/`** - Example usage manifests

### Generated Manifests

Kiln generates the following files in `manifests/`:

- **`staticsite-xrd.yaml`** - Custom Resource Definition (XRD) for StaticSite
- **`staticsite-composition.yaml`** - Composition that renders S3 + CloudFront resources

## Resource Stack

When you create a StaticSite custom resource, the composition creates:

1. **S3 Bucket** - Stores website content
   - Private ACL
   - Public Access Block enabled
   - Optional versioning
   - Optional access logging

2. **CloudFront Distribution** - CDN for global delivery
   - Origin Access Identity for secure S3 access
   - Configurable caching policies
   - Support for multiple domain aliases
   - Error page routing

3. **Bucket Policy** - Restricts S3 access to CloudFront only

## Configuration

The StaticSite composition is configured via the `spec` section. Key options:

```yaml
siteName: required - Name for resource identification
domainName: required - Primary CloudFront domain
alternateNames: [] - Additional domain aliases

# S3 Configuration
bucketName: "" - Custom bucket name (auto-generated if empty)
enableVersioning: false
enableLogging: true
loggingBucket: "" - Custom logging bucket

# CloudFront Configuration
defaultRootObject: "index.html"
errorResponses: 
  "403": "index.html"
  "404": "404.html"
viewerProtocolPolicy: "redirect-to-https"
cachePolicyId: "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized

# Tags
tags: {}
```

## Usage

### 1. Deploy a Static Website

```bash
# Create a simple website
kubectl apply -f examples/staticsite-basic.yaml

# Or deploy your customized manifest
kubectl apply -f your-site.yaml
```

### 2. Upload Content to S3

After the composition creates resources:

```bash
# Get the bucket name from the status
kubectl get staticsite my-website -o jsonpath='{.status.s3BucketName}'

# Upload your content
aws s3 sync ./dist/ s3://my-website-bucket-123456/
```

### 3. Access Your Site

The CloudFront distribution endpoint is available via status:

```bash
kubectl get staticsite my-website -o jsonpath='{.status.cloudFrontDomainName}'
```

## Architecture Diagram

```
                    Internet
                       |
                       v
                  CloudFront
                   (CDN Edge)
                       |
                       v
        Origin Access Identity
                       |
                       v
                  S3 Bucket
              (Website Content)
```

## Security Notes

- S3 buckets are created with **private ACL** and **public access blocks** enabled
- Access to S3 is restricted to CloudFront via **Origin Access Identity (OAI)**
- CloudFront certificates use AWS managed defaults (customize via ACM if needed)
- Support for HTTPS-only viewer protocol policy (default: redirect-to-https)

## Examples

See `examples/` directory for:
- **staticsite-basic.yaml** - Minimal configuration
- **staticsite-advanced.yaml** - Production-ready with versioning and comprehensive error handling

## Extending the Composition

To customize the composition:

1. Edit `kcl-scripts/staticSiteComposition.k` to add new spec fields
2. Edit `kcl-scripts/staticSite.k` to modify the resource generation logic
3. Regenerate manifests: `kiln build`

## References

- AWS S3 Documentation: https://docs.aws.amazon.com/s3/
- CloudFront Documentation: https://docs.aws.amazon.com/cloudfront/
- Crossplane AWS Provider: https://doc.crds.dev/github.com/crossplane/provider-aws
- KCL Language: https://www.kcl-lang.io/
