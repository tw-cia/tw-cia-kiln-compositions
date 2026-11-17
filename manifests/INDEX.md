# Static Site Composition - File Index

## Overview

This is a complete KCL-based Kiln composition for deploying static websites using AWS S3 and CloudFront.

## Files in This Directory (`manifests/`)

### Core Composition

- **`staticsite.kcl`** (8.0 KB)
  - Main composition implementation in KCL
  - Defines the `compose` function that creates all AWS resources
  - Includes schemas for `StaticSiteSpec` and `StaticSiteStatus`
  - Handles resource dependencies and observed state

### Supporting Files

- **`staticsite_xrd.kcl`**
  - CompositeResourceDefinition (XRD) for the StaticSite custom resource
  - Defines the API schema that users interact with
  - OpenAPI schema with validation rules

- **`staticsite_composition.kcl`**
  - Crossplane Composition wrapper
  - Ties XRD to the KCL function
  - Defines the pipeline for composition execution

- **`STATICSITE.md`** (Comprehensive Documentation)
  - Complete guide to the composition
  - Configuration reference
  - Security details
  - Troubleshooting guide

## Files in `examples/` Directory

- **`README.md`** (Examples Guide)
  - Introduction to the examples
  - Common patterns and use cases
  - Running examples
  - Tips and best practices

- **`staticsite_example.kcl`** (2.2 KB)
  - 4 basic examples:
    - Minimal blog (defaults)
    - API documentation (custom tags and region)
    - Global marketing site (all regions)
    - Staging site (cost-optimized)

- **`staticsite_advanced.kcl`** (3.0 KB)
  - Advanced patterns:
    - Using composition output
    - Site lists and batch creation
    - Factory functions
    - Integration with other resources

## Architecture

```
User creates StaticSite resource
        ↓
Crossplane detects XRD match
        ↓
Composition runs (via KCL function)
        ↓
staticsite.kcl compose() function executes:
        ├─ Create S3 Bucket
        ├─ Create Bucket Public Access Block
        ├─ Create CloudFront OAC
        ├─ Wait for OAC ID (observed state)
        ├─ Create CloudFront Distribution
        ├─ Wait for Distribution ARN (observed state)
        ├─ Create Bucket Policy
        └─ Update XR status with outputs
        ↓
Composition completes
        ↓
User can access site at distributionDomainName
```

## Key Design Decisions

### Why KCL?

- **Type-safe**: Schemas ensure correct configuration
- **Composable**: Functions and lambdas for reusable patterns
- **Readable**: Clear, Pythonic syntax
- **Powerful**: Full programming language (no YAML limitations)

### Why OAC over OAI?

- Modern standard (OAI is legacy)
- Supports all S3 regions
- Better security (sigv4 signing)
- Recommended by AWS

### Dependency Handling

Resources requiring observed state only get created after that state exists:

1. **Immediate**: S3 bucket, public access block, OAC
2. **After OAC ID**: CloudFront distribution
3. **After Distribution ARN**: Bucket policy
4. **After Distribution ID**: XR status

This prevents failures and unnecessary operations.

## Usage Summary

### 1. Define the Site

Create a StaticSite resource (see `examples/` for patterns):

```kcl
site = {
    apiVersion = "platform.demotw.com/v1alpha1"
    kind = "StaticSite"
    metadata.name = "my-site"
    spec.bucketName = "my-unique-bucket"
}
```

### 2. Apply the Resource

```bash
kiln render site.kcl | kubectl apply -f -
```

### 3. Wait for Composition

Monitor the composition status:

```bash
kubectl get staticsites
kubectl describe staticsite my-site
```

### 4. Upload Content

```bash
aws s3 sync ./dist/ s3://my-unique-bucket/
```

### 5. Configure DNS (Optional)

Create a Route53 CNAME pointing your domain to the CloudFront distribution domain.

## Integration Points

### Crossplane

- Requires Crossplane controller
- Requires KCL function provider
- Requires AWS Upbound provider(s)

### AWS

- S3 for content storage
- CloudFront for caching and delivery
- IAM for access control
- Route53 for DNS (optional)

### DNS/SSL

Not composed, but can be added:
- Route53 records (point to CloudFront)
- AWS Certificate Manager (custom HTTPS)
- CloudFront custom domain configuration

## Testing

To verify the composition works:

```bash
# Render to YAML and inspect
kiln render manifests/staticsite_example.kcl

# Check KCL syntax
kcl check manifests/staticsite.kcl

# Apply a test site
kiln render examples/staticsite_example.kcl | \
  kubectl apply -f -

# Monitor composition
kubectl get staticsites -w
kubectl logs -f deployment/crossplane
```

## Contributing

To extend the composition:

1. Edit `staticsite.kcl` for logic changes
2. Update `STATICSITE.md` for documentation
3. Add examples to `examples/staticsite_example.kcl` or new files
4. Update this index if adding files

## References

- **Kiln Documentation**: Composition syntax and patterns
- **Crossplane**: Kubernetes resource composition
- **KCL**: Kusion Configuration Language
- **AWS S3 & CloudFront**: Cloud infrastructure
- **OpenAPI**: Schema definition standards

## Support

For issues or questions:

1. Check `STATICSITE.md` troubleshooting section
2. Review examples in `examples/` for your use case
3. Check Crossplane/KCL documentation
4. Examine composed AWS resources in AWS console

## License

This composition is part of the testing-kiln project.
