Feedback from building a real composition with Kiln. Please improve Kiln so the
problems below are caught locally (in `kcl test` / `kiln render`) instead of on
the cluster.

## Context

A session built a namespaced `StaticWebsite` kind (format = "yaml",
scope = "Namespaced") composing Upbound AWS v2 resources: S3 Bucket and
BucketPolicy, CloudFront OriginAccessControl and Distribution, ACM Certificate
and CertificateValidation, and Route53 Records. It works now, but most of the time
went on failures that Kiln had enough information to catch earlier. The
`kcl test` loop and the `scope` setting in kiln.toml worked well; keep those as
they are.

## Problems and requested changes, most valuable first

### 1. Check scope at import and render time
Upbound providers ship two groups per service: `<svc>.aws.upbound.io`
(cluster-scoped, legacy) and `<svc>.aws.m.upbound.io` (namespaced).
`kiln pull-crds` downloads both. Importing the legacy one by mistake and
composing it from a namespaced XR renders fine, but the cluster rejects it:
  "cannot apply cluster scoped composed resource ... for a namespaced composite resource"
The CRDs in `crds/` record each kind's `spec.scope`, and kiln.toml records the XR's scope.
- `kiln import`: warn when the CRD's scope differs from the project/kind scope.
- `kiln render`: fail when a rendered composed resource's kind is cluster-scoped
  and the XR is namespaced (look the kind up in `crds/`), with an error that
  names the namespaced group to use instead.

### 2. Validate rendered resources against the CRD schemas
Compose functions can build resources as plain dicts, which bypasses the
imported KCL schemas. Wrong shapes then render cleanly and only fail on apply, e.g.
  ".spec.forProvider.bucket: field not declared in schema"
The `.m.` APIs differ from the legacy ones: single blocks are objects rather than
one-item lists, BucketPolicy `policy` is a JSON string, and Bucket has no
`forProvider.bucket`.
- Validate every rendered composed resource against the OpenAPI schema of its
  CRD in `crds/`: unknown fields, wrong types, missing required fields such as
  `region`. Do this in `kiln render` by default, or behind a flag included in
  `render-all`.

### 3. Render observed stages
- `kiln render <Kind> --observed-resources <directory>` silently rendered the
  cold-start output, as if nothing were observed. Passing a single multi-document
  file worked. Either load every YAML file in a directory or reject it with a clear error.
- `kiln render-all` renders only `xr.yaml`, so resources gated on observed
  state (here: the distribution, DNS records and XR status) are never exercised
  there. Also render `xr.yaml` together with all `render-fixtures/<kind>/observed-*.yaml`
  files when present, and document this naming convention.

### 4. Default providerConfigRef
Composed resources without `spec.providerConfigRef` default to
`ClusterProviderConfig/default`. On this cluster that doesn't exist, so the
resources sat with no status and no events, and nothing pointed to the cause.
- Add an optional kiln.toml setting, e.g.
    providerConfig = { kind = "ClusterProviderConfig", name = "pod-identity" }
  (with a per-kind override, like `scope`), and have generation or a helper
  apply it to every composed resource that doesn't set one. At minimum,
  document the default and how silently it fails in `kiln docs`.

### 5. Make composition size visible
Generation already prunes unused provider schemas (the final composition was
~42KB), but the docs don't say so. After an earlier oversized composition hit
the Kubernetes annotation limit ("metadata.annotations: Too long: may not be
more than 262144 bytes"), the imported schemas were deleted by hand, which
removed the type checking that would have caught problem 2.
- Say in `kiln docs` that unused schemas are pruned and that you should not
  trim imported schemas by hand.
- Make `kiln generate` warn when a composition approaches 262144 bytes, and
  name the largest contributors.

### 6. Skill and doc additions
- kcl-primer: inside a resource dict that defines its own `spec.<x>` key,
  `spec.<y>` refers to that inner `spec`, not the XR's, and this gives a confusing
  "expected str, got {str:str}" error. Bind XR values to locals first.
- kcl-primer: on a schema instance, `"field" in obj` is True for any declared
  attribute, even if unset. Test the value instead (`not obj.field`).
- crossplane-intro: a managed resource's `status.atProvider` can lag reality
  until the provider's next poll (~10 min). Where a dependent resource exists
  for this purpose, gate on its Ready condition instead, e.g. ACM
  CertificateValidation Ready rather than Certificate `atProvider.status == "ISSUED"`.
- kiln skill: with a namespaced XR, import only `<svc>.aws.m.upbound.io` CRDs.
  Warn that copying legacy (`.aws.upbound.io`) examples gives the wrong shapes.

## Acceptance
- A test project that composes a cluster-scoped kind from a namespaced XR fails
  `kiln render` with a scope error.
- A rendered resource with an undeclared `forProvider` field fails validation.
- `render-all` renders observed fixtures when they exist, and
  `--observed-resources <directory>` either loads the directory or errors.
- New behaviour has tests in the Kiln repo, and `kiln docs` and the skills are
  updated (run `kiln install-skills --force` to check they install).
