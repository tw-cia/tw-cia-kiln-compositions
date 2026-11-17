# KCL Guide for Kiln Compositions

KCL is a configuration language (like HCL, not like Python). It has functional features but fundamentally designs data structures, not general programs.

**Official KCL Documentation**: https://www.kcl-lang.io/docs/user_docs/guides/

This guide focuses on KCL patterns used in Kiln compositions. For complete KCL language reference, see the official docs above.

## Core Syntax Differences from Python/JS

### Dictionaries/Objects: Newlines, Not Commas

**❌ WRONG** (looks like JSON):
```kcl
{key: "value", nested: {inner: "data"}}
```

**✅ RIGHT** (KCL style):
```kcl
{
    key = "value"
    nested = {
        inner = "data"
    }
}
```

**Key rules:**
- Use `=` not `:` for key-value pairs
- Separate properties with **newlines**, not commas
- No commas at the end of blocks

### No Assertions, No Exceptions

KCL has no `assert`, `try/except`, or traditional control flow.

**❌ WRONG:**
```kcl
def test_something():
    assert len(resources) > 0
```

**✅ RIGHT (if you need validation):**
Tests in Kiln are YAML fixtures + `kiln render`. Validation happens at schema level and during rendering.

### Lambda Functions

Composition functions are lambdas that take observed XR and observed composed resources, return a list of resources.

```kcl
compose = lambda oxr, ocds -> [{str:any}] {
    # oxr = observed composite resource (the XR)
    # ocds = observed composed resources (map of already-created resources)
    # Return type: list of dictionaries (Kubernetes resources)
    
    bucket = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "Bucket"
        metadata = {name = oxr.spec.bucketName}
        spec = {forProvider = {bucket = oxr.spec.bucketName}}
    }
    
    [bucket]  # Return list with one resource
}
```

**Function signature breakdown:**
- `lambda oxr, ocds ->` : takes two arguments
- `[{str:any}]` : return type (list of string-keyed dicts)
- `{ ... }` : function body (multiple statements allowed)
- Implicit return of last expression

### Schemas

Schemas define the shape of your composite resource spec and status.

```kcl
schema MySpecSpec:
    name: str                          # Required string
    count: int = 5                     # Optional, default 5
    tags: {str: str} = {}              # Optional dict, default empty
    enabled: bool = True               # Optional bool

schema MySpecStatus:
    ready: bool = False
    message: str = ""
```

**Rules:**
- One space indent (not 4 spaces like Python)
- Type annotations are required: `name: str`
- Defaults with `= value`
- `{str: str}` = string-keyed, string-valued dict

### Variable Assignment

```kcl
x = 10
name = "bucket-" + oxr.spec.name    # String concat with +
items = [1, 2, 3]
obj = {key = value}
```

**No `let`, `const`, `var` keywords.** Just assign.

## Kiln Composition Structure

Typical file: `kcl-scripts/mycomposition.k`

```kcl
# Schema definitions (what users request)
schema MyCompositionSpec:
    name: str
    # ... more fields

schema MyCompositionStatus:
    ready: bool = False
    # ... more fields

# Composition function (what resources get created)
composeMyComposition = lambda oxr, ocds -> [{str:any}] {
    spec = oxr.spec
    
    # Build resource 1
    resource1 = {
        apiVersion = "..."
        kind = "..."
        metadata = {name = spec.name}
        spec = {forProvider = {...}}
    }
    
    # Build resource 2
    resource2 = {
        apiVersion = "..."
        kind = "..."
        metadata = {name = spec.name + "-extra"}
        spec = {forProvider = {...}}
    }
    
    # Return both
    [resource1, resource2]
}
```

## Common Patterns

### Conditional Resources

```kcl
# Only include policy if distributionArn exists
policy = [awsResource(...)] if statusIn?.distributionArn else []

# Then concatenate:
[bucket] + policy + [distribution]
```

### Accessing Nested Values

```kcl
name = oxr.spec.name                    # Direct access
region = oxr.spec?.region or "us-east-1"  # Optional with default
value = ocds["bucket"]?.Resource?.status?.atProvider?.arn  # Safe nav
```

### String Interpolation

```kcl
arn = "arn:aws:s3:::" + bucket_name + "/*"
name = "${bucket_name}-oac"              # Also works
```

### Type Annotations in Functions

If you need helper functions with explicit types:

```kcl
awsResource = lambda apiVersion: str, kind: str, name: str, forProvider: dict -> {str:any} {
    {
        apiVersion = apiVersion
        kind = kind
        metadata = {name = name}
        spec = {forProvider = forProvider}
    }
}

bucket = awsResource("s3.aws.upbound.io/v1beta1", "Bucket", "my-bucket", {...})
```

## Common Gotchas

| Mistake | Fix |
|---------|-----|
| Using commas between dict properties | Remove commas, use newlines |
| Using `:` instead of `=` in dicts | Switch to `=` |
| `{key: value}` JSON syntax | Use `{key = value}` KCL style |
| Trying `assert` or `try/except` | Validate via schema + render tests |
| 4-space indentation in schemas | Use 1 space (kiln import auto-fixes this) |
| Forgetting return type in lambda | Add `-> [{str:any}]` |
| Using commas in lambda params | Use `, ` (space after comma is fine in params) |

## Testing Your Composition

KCL doesn't have unit tests. Instead:

1. **Schemas compile**: `kiln generate-all` succeeds
2. **Composition renders**: `kiln render MyComposition` produces valid YAML
3. **Resources are correct**: Inspect the rendered YAML output

```bash
kiln render MyComposition 2>&1 | grep -A 20 "kind: MyResource"
```

## Import and Schema References

You can import other modules:

```kcl
import schemas_compositions
import schemas_providers

spec: schemas_compositions.MySpec = oxr.spec
forProvider: schemas_providers.BucketForProvider = {region = "us-east-1"}
```

Schemas are auto-imported from `schemas_compositions.k` and `schemas_providers.k`.

## Learning Resources

- **Official KCL Docs**: https://www.kcl-lang.io/docs/user_docs/guides/ (language reference)
- **Built-in docs**: `kiln docs` (comprehensive, dense)
- **Search for examples**: Look for `*.k` files in other Kiln projects' `kcl-scripts/` directories
- **For Crossplane specifics**: Crossplane KCL function docs

## Example: Complete S3 Composition

```kcl
schema S3SiteSpec:
    bucketName: str
    region: str = "us-east-1"

schema S3SiteStatus:
    ready: bool = False

composeS3Site = lambda oxr, ocds -> [{str:any}] {
    bucket = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "Bucket"
        metadata = {name = oxr.spec.bucketName}
        spec = {
            forProvider = {
                bucket = oxr.spec.bucketName
                region = oxr.spec.region
            }
            providerConfigRef = {name = "aws-provider"}
        }
    }
    
    policy = {
        apiVersion = "s3.aws.upbound.io/v1beta1"
        kind = "BucketPolicy"
        metadata = {name = oxr.spec.bucketName + "-policy"}
        spec = {
            forProvider = {
                bucket = oxr.spec.bucketName
                policy = {
                    Version = "2012-10-17"
                    Statement = [{
                        Effect = "Allow"
                        Action = "s3:GetObject"
                        Resource = "arn:aws:s3:::" + oxr.spec.bucketName + "/*"
                    }]
                }
            }
            providerConfigRef = {name = "aws-provider"}
        }
    }
    
    [bucket, policy]
}
```

---

**TL;DR**: KCL dicts use `key = value` with newlines (no commas). Functions are lambdas returning lists. No assertions or exceptions. Schema properties need type annotations.
