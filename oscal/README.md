# OSCAL (Lab 6.1)

Machine-readable control documentation for this portfolio's Terraform modules. An assessor starts here, follows `links[rel=evidence]` into the Object Lock vault, and runs `scripts/verify-evidence.sh`, no human in the room.

## Components

| File | Module | Controls described |
|---|---|---|
| [`components/compliant-s3-v1.json`](components/compliant-s3-v1.json) | Lab 2.3 `compliant-s3` ([`terraform/primitives/compliant-s3/`](../terraform/primitives/compliant-s3/)) | sc-28, ac-3, au-3, cm-6 |

The component definition *describes* Lab 2.3's implementations; it does not deploy anything new. Party name is `0xBahalaNa`. Evidence hrefs keep the lab placeholders (`EVIDENCE_VAULT` / `LATEST`) for fidelity to the GRCEngClub reference. Real resolution is below.

## Profiles

| File | Selection |
|---|---|
| [`profiles/cge-p-minimum.json`](profiles/cge-p-minimum.json) | sc-28, ac-3, au-3, cm-6 from the NIST 800-53 Rev 5 catalog |

## Evidence location

Both placeholders in `components/compliant-s3-v1.json` are deliberate. Every `rel: "evidence"` href reads
`s3://EVIDENCE_VAULT/runs/LATEST/evidence-LATEST.tar.gz`. `EVIDENCE_VAULT` stands in for the Object-Locked vault
bucket, the `evidence-vault` primitive from Lab 2.5, re-applied for Lab 4.4 and left standing, which
`grc-gate.yaml` reads from a repo variable of the same name, so the component JSON stays lab-exact. The live
bucket is `cgep-lab-grc-evidence-vault-7f9da4cb`.
`runs/LATEST/evidence-LATEST.tar.gz` stands in for the run-scoped key the pipeline actually writes, here
`runs/30765900955/evidence-30765900955-4c334c91312b657c95bd113395806096fd34230d.tar.gz`. The run ID and the commit
SHA are both baked into the object name, so a resolved href points at exactly one signed bundle from exactly one
commit, not at a moving target. Substitute both, and
`EVIDENCE_VAULT=cgep-lab-grc-evidence-vault-7f9da4cb bash scripts/verify-evidence.sh 30765900955` walks the chain end to end: SHA-256
integrity, `cosign verify-blob` against the Fulcio certificate and Rekor entry, then the S3 object-retention date,
and reports `CHAIN INTACT`. The two earlier Lab 4.4 runs (`29622061513`, `29622795676`) no longer verify: the
vault's default retention is one day, so their preservation check now fails as expired, which is why run
`30765900955` is a fresh `workflow_dispatch` from 2026-08-02, captured so these links resolve to a bundle still
inside its retention window.

## Validate / resolve

Built in a scratch trestle workspace (`~/scratch/lab-6-1/`), then copied flat into this directory (checklist shape ≠ trestle nested layout).

```bash
cd ~/scratch/lab-6-1
trestle validate -f component-definitions/compliant-s3-v1/component-definition.json
trestle validate -f profiles/cge-p-minimum/profile.json
```

**Why the `cd`:** `trestle` finds models through the `.trestle/` directory that `trestle init` creates at the
workspace root, so `-f` takes a *workspace-relative* path, not a filesystem one. This repo is not a trestle
workspace, so `trestle validate -f oscal/components/compliant-s3-v1.json` from the repo root fails on the missing
root before it ever opens the JSON. The files committed here are byte-identical copies of the ones validated in
`~/scratch/lab-6-1/`, so reproducing the check means recreating that workspace rather than pointing `trestle` at
`oscal/`.

Evidence capture: [`evidence/lab-6-1/trestle-validate.txt`](../evidence/lab-6-1/trestle-validate.txt).

**Declared tooling delta:** Lab Step 6 writes `trestle profile-resolve`; compliance-trestle v4.0.3 requires `trestle author profile-resolve -n cge-p-minimum -o cge-p-minimum-resolved`. Resolved catalog is run for verification, not committed.
