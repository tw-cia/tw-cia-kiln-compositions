# Static Website Kiln Composition

A Crossplane composition for managing static websites hosted on AWS S3 with CloudFront CDN distribution.

## Overview

This composition creates a complete static website infrastructure on AWS with:

- **S3 Bucket**: For hosting your static website files
- **Public Access Block**: Security controls to prevent accidental public exposure
- **Website Configuration**: Configures S3 to serve as a website with index and error documents
- **CloudFront Distribution**: Global CDN for fast content delivery
- **Origin Access Control**: Secure S3 bucket access from CloudFront

## Project Structure

```
.
├── kiln.toml                           # Kiln project configuration
├── README.md                           # This file
├── kcl-scripts/
│   ├── schemas_compositions.k          # StaticWebsiteSpec schema definition
│   ├── schemas_providers.k             # Imported AWS provider schemas
│   └── StaticWebsite.k                 # Composition logic (KCL)
├── manifests/
│   ├── crossplane-providers/           # AWS provider manifests
│   ├── functions.yaml                  # Crossplane functions for KCL
│   └── crossplane-compositions/
│       └── StaticWebsite/
│           ├── composition.yaml        # Generated Composition manifest
│           └── xrd.yaml                # Generated CompositeResourceDefinition
├── crds/                               # Downloaded provider CRDs
└── render-fixtures/
    └── StaticWebsite/
        └── xr.yaml                     # Sample StaticWebsite resource
```

## Composition Spec

The `StaticWebsite` resource accepts the following configuration:

```yaml
apiVersion: platform.example.com/v1
kind: StaticWebsite
metadata:
  name: my-website
spec:
  bucketName: my-unique-bucket-name     # Required: globally unique S3 bucket name
  domainName: example.com               # Optional: custom domain for CloudFront aliases
  region: us-east-1                     # Optional: AWS region (default: us-east-1)
  versioningEnabled: false              # Optional: enable S3 versioning (default: false)
  blockPublicAccess: true               # Optional: block public access (default: true)
  enableLogging: false                  # Optional: enable S3 logging (default: false)
  cacheTtl: 3600                        # Optional: CloudFront cache TTL in seconds (default: 3600)
  tags:                                 # Optional: tags for all resources
    Environment: production
    Application: website
  certificateArn: arn:aws:acm:...      # Optional: ACM certificate for HTTPS
```

## Resources Created

### S3 Bucket
- Configured for website hosting
- Optional versioning support
- Optional access logging
- Customizable tags

### CloudFront Distribution
- Automatic HTTPS redirect
- IPv6 support
- Configurable cache TTL
- Support for custom domains (with appropriate SSL certificate)
- Origin Access Control for secure S3 access

### Security
- Public access blocking on S3 bucket
- Secure S3 access through CloudFront only
- Origin Access Control (OAC) implementation

## Deployment

### Prerequisites

1. **Crossplane** installed in your Kubernetes cluster
2. **AWS provider** (Upbound) configured
3. **KCL function** deployed (included in `manifests/functions.yaml`)

### Deploy the Composition

```bash
# Apply the Composition and XRD to your cluster
kubectl apply -f manifests/crossplane-compositions/StaticWebsite/

# Apply the AWS provider manifests
kubectl apply -f manifests/crossplane-providers/
```

### Create a Static Website

```bash
# Save this to website.yaml
cat > website.yaml <<EOF
apiVersion: platform.example.com/v1
kind: StaticWebsite
metadata:
  name: my-site
spec:
  bucketName: my-awesome-website-bucket
  domainName: example.com
  region: us-east-1
  cacheTtl: 3600
  tags:
    Environment: production
EOF

# Apply the resource
kubectl apply -f website.yaml

# Check the status
kubectl describe staticwebsite my-site
```

## Development

### Generate Composition Files

After modifying the KCL code:

```bash
# Generate a single composition
kiln generate StaticWebsite

# Generate all compositions
kiln generate-all

# Render (requires Docker)
kiln render-all
```

### Test KCL Code

```bash
# Run KCL tests
kcl test ./kcl-scripts
```

### Add Provider Resources

To add more AWS resources to this composition:

1. Download the CRD: `kiln pull-crds`
2. Import the resource schema: `kiln import crds/path/to/resource.yaml`
3. Update `kcl-scripts/StaticWebsite.k` to use the new resource
4. Regenerate: `kiln generate StaticWebsite`

## Customization

### Modify Cache Behavior

Edit `kcl-scripts/StaticWebsite.k` and adjust the `defaultCacheBehavior` section to modify cache rules, compression settings, etc.

### Add Additional Origins

Extend the `origin` list in the distribution configuration to serve content from multiple origins.

### Enable S3 Logging

Modify the XR spec to include logging bucket configuration and update the composition to create the logging setup.

## Related Resources

- [Crossplane Documentation](https://crossplane.io)
- [Upbound AWS Provider](https://marketplace.upbound.io/providers/upbound/provider-aws)
- [KCL Language](https://www.kcl-lang.io/)
- [Kiln Documentation](https://github.com/upbound/kiln)
