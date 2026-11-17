# Quick Start Guide - Static Website Composition

Deploy a static website on S3 with CloudFront in 5 minutes.

## Prerequisites

- Kubernetes cluster with Crossplane installed
- AWS provider configured in Crossplane
- `kubectl` configured to access your cluster
- Your website content ready (HTML files, assets, etc.)

## 1. Deploy the Composition

```bash
# Apply the composition and XRD
kubectl apply -f manifests/staticsite-composition.yaml
kubectl apply -f manifests/staticsite-xrd.yaml
```

## 2. Create a StaticSite Resource

Create a minimal configuration:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: example.platform.demotw.com/v1
kind: StaticSite
metadata:
  name: my-site
  namespace: default
spec:
  siteName: my-site
  domainName: www.example.com
  tags:
    environment: production
EOF
```

Or use the provided example:

```bash
kubectl apply -f examples/staticsite-basic.yaml
```

## 3. Wait for Resources to Create

Monitor the creation:

```bash
# Watch the custom resource status
kubectl get staticsite my-site -w

# Check composition status
kubectl describe staticsite my-site
```

Resources should be ready in 2-5 minutes.

## 4. Get Your S3 Bucket Name

```bash
S3_BUCKET=$(kubectl get staticsite my-site -o jsonpath='{.status.s3BucketName}')
echo "S3 Bucket: $S3_BUCKET"
```

## 5. Upload Your Website Content

```bash
# Sync your website files to the bucket
aws s3 sync ./dist/ s3://$S3_BUCKET/ --delete

# Or upload specific files
aws s3 cp index.html s3://$S3_BUCKET/
aws s3 cp --recursive assets/ s3://$S3_BUCKET/assets/
```

## 6. Access Your Website

```bash
# Get the CloudFront domain
CF_DOMAIN=$(kubectl get staticsite my-site -o jsonpath='{.status.cloudFrontDomainName}')
echo "Website: https://$CF_DOMAIN"
```

Visit the URL in your browser. You may need to wait a few minutes for the CloudFront distribution to fully deploy.

## Next Steps

- **Add custom domain**: Update `domainName` and `alternateNames` in the spec
- **Enable versioning**: Set `enableVersioning: true` for rollback capability
- **Custom error pages**: Upload `404.html` and `403.html` to your S3 bucket
- **Enable logging**: Set `enableLogging: true` to track access patterns

## Troubleshooting

### Resources stuck in "creating" state

```bash
# Check the composition logs
kubectl describe managed <resource-type> <resource-name>

# Check the AWS provider logs
kubectl logs -n crossplane-system -l app=crossplane-provider-aws
```

### 403 Access Denied errors

- Ensure the S3 bucket is properly created
- Verify CloudFront Origin Access Identity is configured
- Check S3 bucket policy allows CloudFront access

### 404 errors for root path

- Ensure `index.html` exists in the bucket
- Verify the file name matches `defaultRootObject` in the spec (default: `index.html`)
- Check S3 bucket for the file: `aws s3 ls s3://$S3_BUCKET/`

## Configuration Reference

| Option | Purpose | Default |
|--------|---------|---------|
| `siteName` | Resource identifier and naming | Required |
| `domainName` | Primary CloudFront domain | Required |
| `alternateNames` | Additional domain aliases | None |
| `enableVersioning` | S3 versioning for rollback | `false` |
| `defaultRootObject` | Root file for `/` requests | `index.html` |
| `viewerProtocolPolicy` | HTTPS enforcement | `redirect-to-https` |

For more options, see the advanced example: `examples/staticsite-advanced.yaml`

## Clean Up

```bash
# Delete the StaticSite resource (this will remove all created resources)
kubectl delete staticsite my-site

# Note: S3 bucket deletion may fail if it's not empty; empty it first:
aws s3 rm s3://$S3_BUCKET --recursive
```

## Resources

- Full documentation: See `COMPOSITION.md` in the project root
- Schema reference: `kcl-scripts/staticSiteComposition.k`
- More examples: `examples/` directory
