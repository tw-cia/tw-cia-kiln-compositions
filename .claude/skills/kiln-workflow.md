---
name: kiln-workflow
description: >
  Kiln composition development workflow. Step-by-step guide for building,
  testing, and debugging compositions with the right validation at each step.
---

# Kiln Composition Development Workflow

This is the proven workflow to build Kiln compositions with minimal trial-and-error.

## Phase 1: Design (30 min)

### 1.1 Define Your XR API
What should users be able to request?

**Example**: "Users want to create a static website by specifying bucket name and domain."

### 1.2 Write Schemas

Create `kcl-scripts/schemas_compositions.k`:

```kcl
schema StaticWebsiteSpec:
 bucketName: str                 # Required
 domainName: str = "example.com" # Optional with default
 tags: {str: str} = {}           # Dict type

schema StaticWebsiteStatus:
 ready: bool = False
 bucketArn: str = ""
```

**Validate**: `kiln generate StaticWebsite` succeeds

## Phase 2: Build Composition (1-2 hours)

### 2.1 Start Minimal
Begin with ONE resource, not all of them.

```kcl
composeStaticWebsite = lambda oxr, ocds -> [{str:any}] {
    bucket = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "Bucket"
        metadata = {name = oxr.spec.bucketName}
        spec = {
            forProvider = {
                bucket = oxr.spec.bucketName
                region = "us-east-1"
            }
            providerConfigRef = {name = "aws-provider"}
        }
    }
    [bucket]
}
```

**Validate**: 
```bash
kiln generate StaticWebsite
kiln render StaticWebsite
# Inspect output: Is the Bucket resource correct?
```

### 2.2 Add Resources One at a Time

Add second resource:

```kcl
composeStaticWebsite = lambda oxr, ocds -> [{str:any}] {
    bucket = { ... }
    
    policy = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata = {name = oxr.spec.bucketName + "-policy"}
        spec = { ... }
    }
    
    [bucket, policy]
}
```

**Validate at each step**:
```bash
kiln generate StaticWebsite
kiln render StaticWebsite
# Check: Is the second resource in the output? Is it correct?
```

Repeat for each resource (bucket → policy → distribution, etc.)

### 2.3 Add Status Updates

After all resources are created, add status patches:

```kcl
statusPatch = {
    ready = True
    bucketArn = ocds["bucket"]?.Resource?.status?.atProvider?.arn
}
dxr = {**oxr, status = statusPatch}

[bucket, policy, distribution, dxr]
```

**Validate**: `kiln render StaticWebsite` shows XR with status fields

## Phase 3: Test (15 min)

### 3.1 Verify All Checks Pass

```bash
# Step 1: Schemas compile
kiln generate-all
# Should output: ✓ StaticWebsite

# Step 2: Everything renders
kiln render-all
# Should output: ✓ StaticWebsite
```

### 3.2 Inspect Rendered Output

```bash
# See the full XR and all MRs
kiln render StaticWebsite > /tmp/output.yaml

# Count resources
grep "^kind:" /tmp/output.yaml | sort | uniq -c

# Verify specific resource
grep -A 20 "kind: Distribution" /tmp/output.yaml
```

### 3.3 Create Additional Test Fixtures (Optional)

For different scenarios:

**`render-fixtures/staticwebsite-with-cert/xr.yaml`** - with custom domain and cert

**`render-fixtures/staticwebsite-minimal/xr.yaml`** - with just required fields

Then render each:
```bash
kiln render StaticWebsite --fixture staticwebsite-with-cert
```

## Phase 4: Debug (If Things Break)

### 4.1 Identify Where It Breaks

```bash
kiln generate-all  # Did schemas work?
kiln render-all    # Did composition work?
```

### 4.2 Check the Generated Composition

```bash
cat manifests/crossplane-compositions/staticwebsite/composition.yaml | grep -A 2 "source:" | head -20
```

This shows the actual KCL code embedded. If syntax errors, the problem is usually:
- Dictionary syntax (commas, colons)
- Indentation in schemas
- Variable typos

### 4.3 Validate One Resource at a Time

Temporarily reduce to one resource:
```kcl
composeStaticWebsite = lambda oxr, ocds -> [{str:any}] {
    bucket = { ... }
    [bucket]  # Just bucket for now
}
```

Then `kiln render StaticWebsite` to verify it works, then add next resource.

### 4.4 Check forProvider Fields

For each MR, verify the `forProvider` spec matches the provider schema.

Schemas are in `kcl-scripts/schemas_providers.k`. Search:
```bash
grep -A 30 "class BucketForProvider" kcl-scripts/schemas_providers.k
```

This shows all available fields, types, and defaults.

## Checklist: Before You Declare Done

```
Schemas:
 ☐ XRSpec schema defined
 ☐ XRStatus schema defined
 ☐ kiln generate-all passes

Composition:
 ☐ All resources create successfully
 ☐ All resources have correct forProvider fields
 ☐ Resources reference each other correctly (if needed)
 ☐ Status patch is correct

Rendering:
 ☐ kiln render-all passes
 ☐ XR shows all composed resources
 ☐ XR status fields are populated
 ☐ MRs have correct apiVersion, kind, forProvider
 ☐ Inspect rendered YAML for correctness

Documentation:
 ☐ Comment any non-obvious composition logic
 ☐ Document any assumptions (e.g., "assumes aws-provider is installed")
 ☐ Note any limitations (e.g., "only supports us-east-1")
```

## Common Mistakes to Avoid

| Mistake | Consequence | Prevention |
|---------|-------------|-----------|
| Build all resources before testing | Hard to debug which one is wrong | Test after each resource |
| Use wrong provider apiVersion | MR won't create | Check `schemas_providers.k` |
| Forget providerConfigRef | MR has no credentials | Every MR needs this field |
| Dictionary syntax (commas) | InvalidSyntax error | Use newlines, not commas |
| Hard-code AWS account ID | Works in test, fails in prod | Use IAM role or Crossplane cross-account |
| Forget to return MRs as list | Composition returns nothing | End with `[resource1, resource2, ...]` |
| Update XR spec but forProvider unchanged | Updates won't work | Composition must reflect spec changes |

## Troubleshooting Commands

```bash
# See what's in the Composition
kubectl get composition staticwebsite-kcl-first -o yaml

# See all XRs of this type
kubectl get staticwebsite

# See the XR details
kubectl describe staticwebsite my-site

# See all MRs created by this XR
kubectl get buckets,distributions,policies -l crossplane.io/composite=my-site

# Check a specific MR
kubectl describe bucket my-site-bucket
# Look at status.conditions for why it's stuck

# View provider status
kubectl get providers
kubectl logs -n crossplane-system -l pkg.crossplane.io/provider=aws-s3 -f
```

## KCL Reminders

If composition syntax fails:

- **Check**: Dictionary properties use `key = value`, not commas
- **Check**: Schemas have one-space indentation
- **Check**: Lambda returns a list: `[resource1, resource2]`
- **Check**: Variable names match (typos cause "not defined" errors)
- **Ask**: `/kcl-primer` for quick reference

## Crossplane Reminders

If composition creates but resources don't sync:

- **Check**: Provider is installed (`kubectl get providers`)
- **Check**: Provider credentials configured (`kubectl get clusterproviderconfigs`)
- **Check**: forProvider fields match the resource type
- **Check**: Resource doesn't already exist in AWS (Crossplane can't claim it)
- **Ask**: `/crossplane-intro` for concepts

## Next Steps After Done

1. **Install in cluster**: Deploy the generated Composition and XRD
2. **Create XR**: Users create `StaticWebsite` resources
3. **Monitor**: Watch MRs sync, check status updates
4. **Iterate**: Adjust composition based on real use cases
