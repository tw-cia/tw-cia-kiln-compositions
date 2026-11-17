---
name: crossplane-intro
description: >
  Crossplane concepts and architecture. Use when understanding how XRs, 
  Compositions, and cloud resources relate, or when debugging resource creation.
---

# Crossplane Introduction

Crossplane is a Kubernetes-native infrastructure-as-code framework. It lets you define cloud resources using Kubernetes manifests, with **Compositions** acting as infrastructure templates.

## Core Concepts

### XR (Composite Resource)
**What**: The resource the user creates. It's the **interface/API** to your infrastructure.

**Example**:
```yaml
apiVersion: platform.demotw.com/v1alpha1
kind: StaticWebsite
metadata:
  name: my-site
spec:
  bucketName: my-site-bucket
  domainName: example.com
```

**Key point**: Users only interact with XRs. They don't need to know about the underlying AWS resources.

### XRD (Composite Resource Definition)
**What**: The schema that defines what an XR can request. Generated automatically by Kiln from your `schemas_compositions.k`.

**Contains**:
- Spec schema (what users provide)
- Status schema (what Crossplane observes/reports back)
- Structural OpenAPI validation

**Generated in**: `manifests/crossplane-compositions/<kind>/xrd.yaml`

### Composition
**What**: The function that maps an XR → list of managed resources (MRs).

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: staticwebsite-kcl-first
spec:
  compositeTypeRef:
    apiVersion: platform.demotw.com/v1alpha1
    kind: StaticWebsite
  mode: Pipeline
  pipeline:
  - step: compose
    functionRef:
      name: function-kcl  # Uses KCL to compose
    input:
      spec:
        source: |
          # Your KCL composition code here
          composeStaticWebsite = lambda oxr, ocds -> [...]
```

**Key point**: This is what Kiln generates from your `.k` files. Don't edit it manually.

### MR (Managed Resource)
**What**: The actual cloud resource (S3 bucket, Lambda, RDS, etc.). Defined by **provider CRDs**.

**Example**:
```yaml
apiVersion: s3.aws.upbound.io/v1beta1
kind: Bucket
metadata:
  name: my-site-bucket
spec:
  forProvider:
    bucket: my-site-bucket
    region: us-east-1
  providerConfigRef:
    name: aws-provider
```

**Key points**:
- One XR → Multiple MRs
- Each MR maps to one cloud resource
- `forProvider` contains cloud provider-specific config
- `providerConfigRef` points to credentials/auth

### Provider
**What**: Crossplane extension that knows how to manage resources from a cloud provider (AWS, GCP, Azure, etc.).

**Examples**:
- `provider-aws-s3` - Manages S3 resources
- `provider-aws-cloudfront` - Manages CloudFront resources
- `provider-kubernetes` - Manages Kubernetes resources

**Installed in**: `manifests/crossplane-providers/provider-*.yaml`

## The Flow

```
User creates XR
    ↓
Crossplane detects the XR
    ↓
Composition maps XR → MRs (using your KCL function)
    ↓
Crossplane creates the MRs via providers
    ↓
Providers create actual cloud resources
    ↓
MR status updates as cloud resources stabilize
    ↓
XR status updates based on MR status
    ↓
User sees their infrastructure ready
```

## Composition Function Details

Your KCL lambda receives two arguments:

```kcl
composeMyThing = lambda oxr, ocds -> [{str:any}] {
    # oxr = observed composite resource
    # ocds = observed composed resources (map of already-created MRs)
    
    # Return list of MRs to create/update
}
```

### oxr (Observed XR)
The XR the user created. Access with:
- `oxr.spec.*` - The user's spec input
- `oxr.metadata.*` - Kubernetes metadata (name, namespace, etc.)
- `oxr.status.*` - Current status

### ocds (Observed Composed Resources)
Map of MRs that already exist. Useful for:
- Reading outputs from previous resources (e.g., bucket ARN)
- Conditional resource creation
- Referencing one resource from another

**Access**: `ocds["bucket"]?.Resource?.status?.atProvider?.arn`

## Lifecycle

### Cold Start (First Time)
```
XR created
Composition runs → creates all MRs
MRs reconcile with cloud provider
Status trickles back up
```

### Steady State
```
XR exists and matches cloud state
Composition not re-run unless XR changes
Providers keep MRs in sync with cloud
```

### Update
```
User updates XR spec
Composition re-runs
MRs updated based on new composition output
Cloud resources updated
```

### Deletion
```
User deletes XR
MRs deleted (by default; can configure retention)
Cloud resources deleted
```

## Status Flow

**MR Status** comes from cloud provider:
```yaml
status:
  atProvider:        # What exists in the cloud
    arn: arn:aws:...
    domainName: ...
  conditions:        # Reconciliation state
  - type: Synced
    status: "True"   # In sync with cloud
  - type: Ready
    status: "True"   # Fully provisioned
```

**XR Status** is set by composition (you define it):
```yaml
status:
  ready: true
  bucketArn: arn:aws:...
  distributionDomain: d123.cloudfront.net
```

## Key Mental Models

### 1. XR is the API Contract
Your users never see CloudFormation, Terraform, or AWS console. They request a `StaticWebsite`, not individual S3/CloudFront resources.

### 2. Composition is a Function
Not configuration. It's code that runs every time the XR changes, deciding what MRs to create.

### 3. MRs are Declarative
You say "create an S3 bucket with this config", Crossplane ensures it exists and is configured that way. If someone deletes it in AWS console, Crossplane recreates it.

### 4. Status is Observable
Both MRs and XR status come from cloud providers. This is real state, not cached state.

## Common Patterns

### Conditional Resources
Only create a resource if a condition is met:
```kcl
policy = [bucketPolicyMR] if hasDistribution else []
```

### Cross-Resource References
One MR references another:
```kcl
distribution = {
    spec = {
        forProvider = {
            origin = [{
                domainName = ocds["bucket"]?.Resource?.status?.atProvider?.bucketRegionalDomainName
            }]
        }
    }
}
```

### Status Propagation
Update XR status based on observed MRs:
```kcl
statusPatch = {
    bucketArn = ocds["bucket"]?.Resource?.status?.atProvider?.arn
    ready = all MRs synced and ready
}
```

## Debugging

### "Resource not created"
Check:
1. Composition ran: `kubectl get composition`
2. XR created: `kubectl get staticwebsite`
3. MRs created: `kubectl get buckets.s3.aws.upbound.io`
4. Provider installed: Check `manifests/crossplane-providers/`

### "Resource stuck in creating"
Check MR status:
```bash
kubectl describe bucket my-site-bucket
# Look at conditions.message
```

### "Status not updating"
Check if provider is running and has credentials:
```bash
kubectl get providers
kubectl get clusterproviderconfigs
```

## Resources

- **Crossplane Docs**: https://docs.crossplane.io/
- **Composition Guide**: https://docs.crossplane.io/latest/concepts/compositions/
- **Provider Docs**: https://marketplace.upbound.io/ (find your providers)
- **Kiln**: Wraps all this in KCL so you don't write YAML
