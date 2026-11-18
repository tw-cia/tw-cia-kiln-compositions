# History of the Kiln compositions and XRDs

This project had no git repository until a baseline commit was made on the
\`main\` branch. Everything before that was reconstructed after the fact.

Each commit on \`main\` is one step in that history. Every step updates this
file, so the file at any commit describes everything up to that point. The
steps before the last commit were rebuilt from the sources described below.
The last commit sets the tree to the project as it stood when this was
written, and records where the reconstruction differs from the original.

## How the steps were reconstructed

Three sources, in order of how much they could be trusted:

1. **Claude Code file backups.** Claude Code keeps a versioned copy of each
   file before each edit, under \`~/.claude/file-history\`. The session
   transcripts index them with timestamps. Each backup is a complete copy of
   the file at that moment. This is the main source.
2. **Session transcripts.** Every \`Write\` and \`Edit\` call is recorded with its
   arguments. These replay the changes the backups do not capture, and confirm
   them.
3. **Cluster metadata.** Each XRD carries a \`generation\` counter and
   \`managedFields\` timestamps, which date when it was applied.

The replay applies every backup and every edit in time order. A backup resets a
file to its recorded content. An edit is applied only if its text is present,
and otherwise it is skipped. Generated manifests were regenerated from the
reconstructed KCL with \`kiln generate-all\`, where that succeeded.

For the session in which the StaticWebSite and CdnDistribution work was done,
the reconstruction matches the test results observed live: 86, 86, 87, 94, 95
and 102 tests passing, at each step.

## What the reconstruction cannot recover

- **Edits before the first backup.** Several early files were edited before any
  backup was made. Their starting content is unknown.
- **Shell writes.** Files written with \`cat >\`, \`sed -i\`, \`kiln import\` or
  \`kiln install-skills\` are not recorded as edits. Their content comes from the
  final tree, not from the time they were written.
- **Deletions.** A file deleted with \`rm\` leaves no record. Experimental files
  are kept until the last session that touched them, and then dropped.
- **Parallel sessions.** From 12:40 to 14:43 on 17 November, several sessions
  wrote into the same folder at the same time, on the same request. Their
  states interleave, and the steps show the state at the end of each session,
  not a clean design step.
- **Test results before 16:00 on 17 November.** Intermediate states from before
  then fail to type-check when rebuilt. That is either the state at the time, or
  a gap in the reconstruction. The transcripts do not say which.
- **Case-insensitive file names.** macOS treats \`StaticWebsite_test.k\` and
  \`staticwebsite_test.k\` as one file. The last step fixes the name.

## Steps

### 1. StaticWebSite: first attempt, from an empty Kiln project
*2026-11-17T12:44:05 UTC*

Session b34a070f (2026-11-17). The first request in the project: an empty
Kiln project, asked for a composition that serves static websites from S3
through CloudFront.

What changed: a StaticWebsite.k composition, a StaticWebsiteSpec in
schemas_compositions.k, a README and a sample XR under render-fixtures/.

Reasoning: none recorded beyond the request. The session took
`kiln generate` succeeding as proof the composition was right.

Challenge: no tests were written, and the Kiln workflow (schema, failing
test, compose, then generate) was not followed. The reconstruction has no
test results for this state.

Reconstructed: this commit is built from session transcripts and Claude
Code file backups. Files edited before any backup existed are missing.

**Tests:** not run: no KCL package at this step
**Generation:** not run: no kiln.toml yet

**Files changed:**
- `A .gitignore`
- `A AGENTS.md`
- `A README.md`
- `A kcl-scripts/cdndistribution.k`
- `A kcl-scripts/kcl.mod`
- `A kcl-scripts/schemas_compositions.k`
- `A kcl-scripts/schemas_providers.k`
- `A kcl-scripts/staticwebsite.k`
- `A render-fixtures/staticwebsite/observed-1-bucket-and-access-control.yaml`
- `A render-fixtures/staticwebsite/observed-2-certificate-validated.yaml`
- `A render-fixtures/staticwebsite/observed-3-distribution.yaml`
- `A render-fixtures/staticwebsite/xr.yaml`

### 2. Parallel attempt: hand-written manifests for the static website
*2026-11-17T12:50:36 UTC*

Session f975665e (2026-11-17, 12:50). Ran in the same folder as b34a070f,
at the same time, on the same request.

What changed: a StaticWebsiteSpec and hand-written XRD, composition and
claim YAML under manifests/, plus STATIC-WEBSITE.md.

Reasoning: wrote the Crossplane YAML directly, rather than KCL that Kiln
generates. This went against the project's KCL-first design, and the
result was not reused later.

Challenge: two sessions overwrote each other's files in one directory, so
this is an experiment, not a step towards the final design.

**Tests:** not run: no KCL package at this step
**Generation:** not run: no kiln.toml yet

**Files changed:**
- `D README.md`
- `M kcl-scripts/schemas_compositions.k`
- `M kcl-scripts/staticwebsite.k`
- `A manifests/STATIC-WEBSITE.md`
- `A manifests/example-static-website-claim.yaml`
- `A manifests/static-website-composition.yaml`
- `M render-fixtures/staticwebsite/xr.yaml`

### 3. Parallel attempt: examples and a second KCL composition
*2026-11-17T12:59:37 UTC*

Session 78acdb3e (2026-11-17, 12:52). Another run of the same request in the
same folder.

What changed: staticSite.k and staticSiteComposition.k, plus examples/
(README, QUICKSTART, basic and advanced YAML).

Reasoning: documentation-first. The examples were written before the
composition was checked against anything.

Challenge: the examples describe a shape that the composition does not yet
produce, so they were later dropped.

**Tests:** not run: no KCL package at this step
**Generation:** not run: no kiln.toml yet

**Files changed:**
- `A COMPOSITION.md`
- `A examples/QUICKSTART.md`
- `A examples/README.md`
- `A examples/staticsite-advanced.yaml`
- `A examples/staticsite-basic.yaml`
- `M kcl-scripts/schemas_compositions.k`
- `A kcl-scripts/staticSite.k`
- `A kcl-scripts/staticSiteComposition.k`
- `D manifests/STATIC-WEBSITE.md`
- `D manifests/example-static-website-claim.yaml`
- `D manifests/static-website-composition.yaml`

### 4. StaticSite: three observed-state stages, with a KCL type error
*2026-11-17T13:15:11 UTC*

Session 9a0da484 (2026-11-17, 13:11). Built the first composition with the
observed-state staging the project later kept: the bucket, public access
block and OAC first; the distribution once the OAC is observed; the
status once the distribution has a domain name.

What changed: staticsite.k, staticsite_test.k, the StaticSiteSpec and
observed fixtures under render-fixtures/staticsite/.

Reasoning: the function reads everything it needs from `ocds`, so each stage
can be checked on its own, rather than the whole site appearing at once.

Challenge: at this state the tests fail with a KCL TypeError. The session
reported the composition as "tested and verified", but this reconstruction
shows the test run failing.

**Tests:** error[E2G22]: TypeError | error[E2G22]: TypeError | error[E2G22]: TypeError
**Generation:** not run: no kiln.toml yet

**Files changed:**
- `D COMPOSITION.md`
- `D examples/QUICKSTART.md`
- `D examples/staticsite-advanced.yaml`
- `D examples/staticsite-basic.yaml`
- `M kcl-scripts/schemas_compositions.k`
- `M kcl-scripts/staticSite.k`
- `D kcl-scripts/staticSiteComposition.k`
- `A kcl-scripts/staticsite_test.k`
- `A render-fixtures/staticsite/observed-distribution.yaml`
- `A render-fixtures/staticsite/observed-oac-and-distribution.yaml`
- `A render-fixtures/staticsite/observed-oac.yaml`
- `A render-fixtures/staticsite/xr.yaml`

### 5. Composition written to the wrong folder, with examples
*2026-11-17T13:22:57 UTC*

Session 47a319b5 (2026-11-17, 13:20). Created manifests/staticsite.kcl and
three supporting files, plus examples/. The composition was not written to
kcl-scripts/ at all.

Reasoning: the session assumed kcl-scripts/ was empty and not the place to
build, so it wrote somewhere else.

Challenge: the output went outside the Kiln layout. It is not part of the composition
that later states build on.

**Tests:** not run: no KCL package at this step
**Generation:** not run: no kiln.toml yet

**Files changed:**
- `M examples/README.md`
- `A examples/staticsite_advanced.kcl`
- `A examples/staticsite_example.kcl`
- `D kcl-scripts/staticSite.k`
- `D kcl-scripts/staticsite_test.k`
- `A manifests/INDEX.md`
- `A manifests/STATICSITE.md`
- `A manifests/staticsite.kcl`
- `A manifests/staticsite_composition.kcl`
- `A manifests/staticsite_xrd.kcl`
- `D render-fixtures/staticsite/observed-distribution.yaml`
- `D render-fixtures/staticsite/observed-oac-and-distribution.yaml`
- `D render-fixtures/staticsite/observed-oac.yaml`
- `D render-fixtures/staticsite/xr.yaml`

### 6. StaticSite: schemas and examples, but no tests
*2026-11-17T13:31:18 UTC*

Session 9254a59e (2026-11-17, 13:26). Three files changed: a composition
schema, an S3 composition and an example.

Reasoning: the session acknowledged the request to focus on KCL and then
skipped the tests. The user had to correct this.

Challenge: the project rule is that tests come with every kind, even when
the rest of the work is deferred. Recorded as a lesson in the session's
own summary, and repeated in the project's AGENTS.md.

**Tests:** not run: no KCL package at this step
**Generation:** not run: no kiln.toml yet

**Files changed:**
- `D examples/README.md`
- `D examples/staticsite_advanced.kcl`
- `D examples/staticsite_example.kcl`
- `A kcl-scripts/composition_s3staticwebsite.k`
- `A kcl-scripts/example_staticsite.k`
- `M kcl-scripts/schemas_compositions.k`
- `D manifests/INDEX.md`
- `D manifests/STATICSITE.md`
- `D manifests/staticsite.kcl`
- `D manifests/staticsite_composition.kcl`
- `D manifests/staticsite_xrd.kcl`

### 7. Kiln initialised: first schema and test, one edit
*2026-11-17T13:56:02 UTC*

Session 3bdaaf2f (2026-11-17, 13:56). Ran `kiln init` and wrote the first
spec schema in schemas_compositions.k.

Reasoning: Kiln's workflow is schema, then test, then compose, then
generate. This session started at the schema, as the workflow requires.

Challenge: the session stopped after one edit. The composition and tests
came later, in another session.

**Tests:** not run: no KCL package at this step
**Generation:** not run: no kiln.toml yet

**Files changed:**
- `D kcl-scripts/composition_s3staticwebsite.k`
- `D kcl-scripts/example_staticsite.k`

### 8. Skills and StaticWebsite composition, rewritten under the Kiln workflow
*2026-11-17T14:43:19 UTC*

Session bf64f0d6 (2026-11-17, 14:02-14:43). The largest early session, with 50
edits. It produced a set of skills under .claude/skills/, a KCL primer,
and a rewritten StaticWebsite composition with its own test file.

What changed: staticwebsite.k and StaticWebsite_test.k, the schemas, the
skill notes, and render-fixtures/staticwebsite.yaml.

Reasoning: the session wrote notes on Kiln and KCL for later use, and
rebuilt the composition around the Kiln workflow.

Challenge: this state fails the KCL parser (InvalidSyntax) in the
reconstruction. The rewrite was iterated many times in the session, so the
state at the session's end is the one kept here.

**Tests:** error[E1001]: InvalidSyntax
**Generation:** not run: no kiln.toml yet

**Files changed:**
- `A .claude/skills/crossplane-intro.md`
- `A .claude/skills/kcl-guide-for-kiln.md`
- `A .claude/skills/kcl-primer.md`
- `A .claude/skills/kiln-workflow.md`
- `A KCL_PRIMER.md`
- `A kcl-scripts/StaticWebsite_test.k`
- `A kcl-scripts/main.k`
- `M kcl-scripts/schemas_compositions.k`
- `M kcl-scripts/staticwebsite.k`
- `A render-fixtures/staticwebsite.yaml`

### 9. Live deployment on cluster, then a full teardown
*2026-11-17T19:24:24 UTC*

Session 06177406 (2026-11-17, 15:45-19:24). Deployed the StaticWebsite
composition to the cluster and debugged it there, including the XRD scope
(namespaced versus cluster) and the naming of the composition.

What changed: staticwebsite.k rewritten, schemas adjusted, and the XRD
hand-edited five times while debugging.

Challenge: the session deleted everything it had created. The XR, the
composition, the XRD, the S3 bucket, the CloudFront distribution and the
index.html were all removed, and each was checked afterwards. The hand
edits to the XRD were debugging, not design, and were replaced by generated
output later.

**Tests:** error[E2G22]: TypeError | error[E2G22]: TypeError | error[E2G22]: TypeError
**Generation:** ok

**Files changed:**
- `D .claude/skills/crossplane-intro.md`
- `D .claude/skills/kcl-guide-for-kiln.md`
- `D .claude/skills/kcl-primer.md`
- `D .claude/skills/kiln-workflow.md`
- `D KCL_PRIMER.md`
- `A improvements.md`
- `M kcl-scripts/StaticWebsite_test.k`
- `D kcl-scripts/main.k`
- `M kcl-scripts/schemas_compositions.k`
- `M kcl-scripts/staticwebsite.k`
- `A kiln.toml`
- `A manifests/crossplane-compositions/staticwebsite/composition.yaml`
- `A manifests/crossplane-compositions/staticwebsite/xrd.yaml`
- `D render-fixtures/staticwebsite.yaml`
- `M render-fixtures/staticwebsite/xr.yaml`
- `A test-trololo-website.yaml`

### 10. Narrow schemas, and a handover in SESSION-NOTES.md
*2026-11-18T07:37:21 UTC*

Session a6ede902 (2026-11-17, 19:42 to 2026-11-18, 07:37). Split the
certificate concern into dnsvalidatedcertificate.k and tightened the
schemas.

What changed: schemas_compositions.k narrowed, staticwebsite.k and its test
adjusted, and dnsvalidatedcertificate.k with its test added.

Reasoning: a narrow spec makes the XRD smaller, which helps with the
composition size limit. The session recorded the size findings in
SESSION-NOTES.md.

Challenge: the narrow-schema change was not yet on the cluster when the
session ended. The notes say to run `kubectl diff` first.

**Tests:** error[E2G22]: TypeError | error[E2G22]: TypeError | error[E2G22]: TypeError
**Generation:** ok

**Files changed:**
- `A SESSION-NOTES.md`
- `D improvements.md`
- `M kcl-scripts/StaticWebsite_test.k`
- `A kcl-scripts/dnsvalidatedcertificate.k`
- `A kcl-scripts/dnsvalidatedcertificate_test.k`
- `M kcl-scripts/schemas_compositions.k`
- `M kcl-scripts/staticwebsite.k`
- `M kiln.toml`
- `A manifests/crossplane-compositions/dnsvalidatedcertificate/composition.yaml`
- `A manifests/crossplane-compositions/dnsvalidatedcertificate/xrd.yaml`
- `M manifests/crossplane-compositions/staticwebsite/composition.yaml`
- `M manifests/crossplane-compositions/staticwebsite/xrd.yaml`
- `D test-trololo-website.yaml`

### 11. dnsvalidatedcertificate: providerConfig set from the cluster
*2026-11-18T08:06:01 UTC*

Session 19252b21 (2026-11-18, 08:01-08:20). Continued the certificate work,
and set providerConfig in kiln.toml after reading the cluster.

What changed: kiln.toml (providerConfig), schemas_compositions.k,
staticwebsite.k and the dnsvalidatedcertificate kind.

Reasoning: the only ClusterProviderConfig on the cluster was `pod-identity`,
not `default`. Without the setting, the managed resources would have stayed
unready with no error.

Challenge: name collisions with compositions already on the cluster
(staticwebsite-kcl-first, dnsvalidatedcertificate) had to be deleted before
reapplying.

**Tests:** error[E2G22]: TypeError | error[E2G22]: TypeError | error[E2G22]: TypeError
**Generation:** ok

**Files changed:**
- `D SESSION-NOTES.md`
- `M kcl-scripts/StaticWebsite_test.k`
- `M kcl-scripts/dnsvalidatedcertificate.k`
- `M kcl-scripts/dnsvalidatedcertificate_test.k`
- `M kcl-scripts/schemas_compositions.k`
- `M kcl-scripts/staticwebsite.k`
- `M manifests/crossplane-compositions/dnsvalidatedcertificate/composition.yaml`
- `M manifests/crossplane-compositions/dnsvalidatedcertificate/xrd.yaml`
- `M manifests/crossplane-compositions/staticwebsite/composition.yaml`
- `M manifests/crossplane-compositions/staticwebsite/xrd.yaml`

### 12. Certificate experiments, and a summary of the Kiln experience
*2026-11-18T09:04:16 UTC*

Session 80e51230 (2026-11-18, 08:31-09:04). Tested a certificate-first
composition on the cluster, with a deployment for the trololo site, then
removed it.

What changed: certificate.k and its test, staticwebsite.k, kiln.toml, and
deployments/test-trololo/staticwebsite.yaml.

Challenge: the deployment was torn down, and the S3 object and the cluster
compositions were deleted afterwards. The session's experience notes went
to kiln-experience-summary.md in the project root.

**Tests:** error[E2G22]: TypeError | error[E2G22]: TypeError | error[E2G22]: TypeError
**Generation:** ok

**Files changed:**
- `M kcl-scripts/StaticWebsite_test.k`
- `A kcl-scripts/certificate.k`
- `A kcl-scripts/certificate_test.k`
- `D kcl-scripts/dnsvalidatedcertificate.k`
- `D kcl-scripts/dnsvalidatedcertificate_test.k`
- `M kcl-scripts/schemas_compositions.k`
- `M kcl-scripts/staticwebsite.k`
- `M kiln.toml`
- `D manifests/crossplane-compositions/dnsvalidatedcertificate/composition.yaml`
- `D manifests/crossplane-compositions/dnsvalidatedcertificate/xrd.yaml`
- `D manifests/crossplane-compositions/staticwebsite/composition.yaml`
- `M manifests/crossplane-compositions/staticwebsite/xrd.yaml`

### 13. Read-only check: did earlier tooling change files?
*2026-11-18T09:16:47 UTC*

Session 18c7c53c (2026-11-18, 09:15). A question about whether earlier tooling had changed
files. The session ran only read-only Python over kcl-scripts/schemas_providers.k,
and the one change in this commit is kiln.toml.

Reasoning: the answer was that nothing except kiln init and kiln import had
written files, and this commit records only that.

**Tests:** error[E2G22]: TypeError | error[E2G22]: TypeError | error[E2G22]: TypeError
**Generation:** ok

**Files changed:**
- `D kcl-scripts/certificate.k`
- `D kcl-scripts/certificate_test.k`
- `M kiln.toml`

### 14. TlsCertificate becomes its own kind, with a child-XR wait
*2026-11-18T09:42:17 UTC*

Session cf37dde6 (2026-11-18, 09:31-09:42). Moved the certificate out of the
static website into tlscertificate.k, and made StaticWebSite compose it as a
child XR. The static site now waits for the certificate to validate.

What changed: tlscertificate.k and its test, staticwebsite.k rewritten to
read the child's status, the TlsCertificate XRD and composition applied to
the cluster.

Reasoning: a certificate is reused by more than one kind, so it gets its own
kind. The child reports a status field the parent reads uncast.

Challenge: the docs comparison showed the experience notes had several gaps
that the project docs had not fixed.

**Tests:** error[E2G22]: TypeError | error[E2G22]: TypeError | error[E2G22]: TypeError
**Generation:** ok

**Files changed:**
- `M kcl-scripts/StaticWebsite_test.k`
- `M kcl-scripts/staticwebsite.k`
- `A kcl-scripts/tlscertificate.k`
- `A kcl-scripts/tlscertificate_test.k`

### 15. Infrastructure prompt: webservice, load balancer and autoscaling experiments
*2026-11-18T10:53:19 UTC*

Session 1c73f64f (2026-11-18, 09:47-10:53). The second prompt, the Kiln
infrastructure brief: auto-scaling group, launch template, load balancer,
certificate, CloudFront in front of the load balancer. This session tried
the pieces separately.

What changed: webservice.k, loadbalancer.k, autoscalinggroup.k, cdnwebservice.k
and their tests, deployments/web.yaml and cdn-web.yaml, and schemas for each.

Reasoning: each AWS piece got its own kind, to see how they compose. The
session looked up the Terraform documentation for each field, to check the
provider's field names.

Challenge: the pieces overlapped, and the final design merged them into
WebFleet and CdnDistribution in the next session.

**Tests:** error[E2G22]: TypeError | error[E2G22]: TypeError | error[E2G22]: TypeError
**Generation:** ok

**Files changed:**
- `A deployments/cdn-web.yaml`
- `A deployments/web.yaml`
- `A kcl-scripts/autoscalinggroup.k`
- `A kcl-scripts/autoscalinggroup_test.k`
- `A kcl-scripts/cdnwebservice.k`
- `A kcl-scripts/cdnwebservice_test.k`
- `A kcl-scripts/loadbalancer.k`
- `A kcl-scripts/loadbalancer_test.k`
- `M kcl-scripts/schemas_compositions.k`
- `A kcl-scripts/webservice.k`
- `A kcl-scripts/webservice_test.k`
- `A manifests/crossplane-compositions/autoscalinggroup/composition.yaml`
- `A manifests/crossplane-compositions/autoscalinggroup/xrd.yaml`
- `A manifests/crossplane-compositions/cdnwebservice/composition.yaml`
- `A manifests/crossplane-compositions/cdnwebservice/xrd.yaml`
- `A manifests/crossplane-compositions/loadbalancer/composition.yaml`
- `A manifests/crossplane-compositions/loadbalancer/xrd.yaml`
- `A manifests/crossplane-compositions/staticwebsite/composition.yaml`
- `M manifests/crossplane-compositions/staticwebsite/xrd.yaml`
- `A manifests/crossplane-compositions/tlscertificate/composition.yaml`
- `A manifests/crossplane-compositions/tlscertificate/xrd.yaml`
- `A manifests/crossplane-compositions/webservice/composition.yaml`
- `A manifests/crossplane-compositions/webservice/xrd.yaml`
