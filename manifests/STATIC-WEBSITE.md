# Static Website Composition

This composition manages static websites hosted on AWS S3 with CloudFront distribution.

## Overview

The `StaticWebsite` composition creates the following AWS resources:

- **S3 Bucket** - Private bucket to store website content
- **S3 Bucket Website Configuration** - Configure bucket for static website hosting
- **S3 Bucket Public Access Block** - Restrict direct public access
- **CloudFront Origin Access Identity (OAI)** - Secure access to S3 from CloudFront
- **S3 Bucket Policy** - Allow CloudFront to access bucket content via OAI
- **CloudFront Distribution** - CDN distribution with HTTPS redirect and compression

## Composition Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `bucketName` | string | Yes | - | Name of the S3 bucket |
| `domainName` | string | Yes | - | Domain name for the website |
| `acmCertificateArn` | string | No | - | ARN of ACM certificate for custom domain (future support) |
| `indexDocument` | string | No | `index.html` | Default document to serve |
| `errorDocument` | string | No | `error.html` | Error page document |
| `enableLogging` | boolean | No | `false` | Enable S3 access logging |
| `logBucketName` | string | No | - | Bucket for storing logs (required if enableLogging=true) |
| `enableCloudFrontCompression` | boolean | No | `true` | Enable compression in CloudFront |
| `cacheTTL` | integer | No | `3600` | Default cache TTL in seconds |

## Usage

### Create a Website Claim

```yaml
apiVersion: platform.demotw.com/v1
kind: WebsiteClaim
metadata:
  name: my-website
  namespace: default
spec:
  bucketName: my-awesome-website-bucket
  domainName: example.com
  indexDocument: index.html
  errorDocument: error.html
  enableLogging: false
  enableCloudFrontCompression: true
  cacheTTL: 3600
  resourceRef:
    name: my-website
```

### Apply the Claim

```bash
kubectl apply -f example-static-website-claim.yaml
```

## CloudFront Behavior

- **Protocol**: Automatically redirects HTTP to HTTPS
- **Compression**: Enabled by default for text-based content
- **Cache**: Default TTL is 3600 seconds (configurable)
- **Origins**: Single S3 origin with Origin Access Identity for secure access
- **Allowed Methods**: GET, HEAD, OPTIONS (suitable for static content)

## Security Features

1. **Private S3 Bucket**: The bucket is configured as private
2. **Origin Access Identity**: CloudFront accesses S3 via OAI instead of public URLs
3. **HTTPS Only**: CloudFront redirects all HTTP traffic to HTTPS
4. **Public Access Block**: All public access to the bucket is blocked

## Future Enhancements

- Custom domain support with ACM certificate
- Multiple cache behaviors for different content types
- Lambda@Edge integration for custom edge functions
- Origin Shield for additional caching layer
- Route53 integration for automatic DNS setup

## Notes

- S3 bucket names must be globally unique across AWS
- The bucket is configured to block all public access; access is only via CloudFront
- CloudFront uses the default AWS certificate initially; custom domains require ACM certificate setup
