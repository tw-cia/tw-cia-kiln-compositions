# Static Website Composition Examples

This directory contains example manifests for deploying static websites using the StaticSite composition.

## Examples

### staticsite-basic.yaml
A basic example with minimal configuration:
- Simple S3 bucket and CloudFront distribution
- Default index.html as root object
- Error handling for 403/404
- HTTPS redirect policy
- Basic tagging

**Use case:** Personal projects, documentation sites, or proof-of-concepts.

### staticsite-advanced.yaml
A production-ready example with comprehensive configuration:
- Custom bucket naming
- Versioning enabled for rollback capability
- Comprehensive error responses with custom pages
- Multiple domain aliases (CDN + www + alternate domains)
- HTTPS-only enforcement
- Detailed tagging for cost tracking and automation

**Use case:** Production websites, critical documentation, multi-domain setups.

## Applying Examples

To deploy a static website, modify the example to match your needs and apply it:

```bash
# Apply the basic example
kubectl apply -f examples/staticsite-basic.yaml

# Or apply your customized version
kubectl apply -f your-custom-site.yaml
```

## Key Configuration Options

| Field | Description | Default |
|-------|-------------|---------|
| `siteName` | Name for resource identification | (required) |
| `domainName` | Primary CloudFront domain | (required) |
| `alternateNames` | Additional domain aliases | `[]` |
| `bucketName` | S3 bucket name (auto-generated if empty) | `${siteName}-website-${timestamp}` |
| `enableVersioning` | Enable S3 bucket versioning | `false` |
| `enableLogging` | Enable S3 access logging | `true` |
| `defaultRootObject` | Root object served for `/` | `index.html` |
| `errorResponses` | HTTP status code → file mapping | 403→index.html, 404→404.html |
| `viewerProtocolPolicy` | Viewer protocol enforcement | `redirect-to-https` |
| `tags` | Resource tags (labels) | `{}` |

## Notes

- The composition automatically creates:
  - S3 bucket with private ACL and public access block
  - CloudFront distribution with OAI for secure S3 access
  - Bucket policy restricting access to CloudFront only
  - Automatic HTTPS redirection and caching optimization

- The S3 bucket is kept private; access is restricted to CloudFront via Origin Access Identity (OAI)

- Error pages (404.html, etc.) should be pre-uploaded to the S3 bucket

- CloudFront caching is optimized for static content with gzip compression enabled
