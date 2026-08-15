# GCP security services baseline (Lab 5.4)

Project-scope preventative baseline: three Org Policies (reject at the API), Workload Identity Federation for keyless GitHub Actions auth, and Data Access audit logs for Cloud Storage / Cloud KMS / IAM. Evidence artifact: `evidence/lab-5-4/iam-policy.json` (output of `gcloud projects get-iam-policy`).

## Data Access logs lesson

Data Access logs are off by default in GCP. Every organization that hasn't explicitly enabled them is missing audit records for every storage read, KMS operation, and IAM change. This is the most common finding in GCP compliance assessments.

## Checklist scope

The lab checklist names **no control IDs**. Derived mappings (AC-2, AC-3, CM-6, AU-2/AU-12, IA-5) live in the study note, not a committed control table, same precedent as Labs 2.5 / 4.3 / 4.4.

## Declared adaptations

| ID | What | Why |
|---|---|---|
| A1 | `terraform{}` with `required_version = ">= 1.6"` and google `~> 5.0` | Lab shows bare resources only; needed to `init` (same pattern as Lab 5.2 / Lab 2.4). |
| A2 | `provider "google"` with `project = var.gcp_project` | Required for the google provider. |
| A3 | `variables.tf` declaring `var.gcp_project` | Lab references the variable but never defines it. |
| A4 | Default `"your-gcp-project"` | Lab-exact placeholder already used by Lab 2.4. |
| D1 | WIF `attribute_condition` / `principalSet` keep `GRCEngClub/cgep-app-starter` | Fidelity choice (option a): demo workflow cannot authenticate from this repo. |
| D2 | New `.github/workflows/gcp-wif-demo.yaml` | Do not reopen Lab 4.3/4.4 `grc-gate.yaml`. |
| D3 | `on: workflow_dispatch` | Checklist does not require a PR green/red pair. |

`setup-gcloud@v2` is included so the lab’s `gcloud storage ls` step has a CLI; the lab snippet omits it.

Security Command Center is **not** provisioned (requires org admin; Org Policy is the lab’s stated substitute).

## Apply notes

- Enable APIs first: `orgpolicy.googleapis.com`, `cloudkms.googleapis.com`, `iam.googleapis.com`, `cloudresourcemanager.googleapis.com`.
- Roles: `roles/orgpolicy.policyAdmin`, `roles/iam.workloadIdentityPoolAdmin`, `roles/logging.admin`. Owner alone is not enough for the WIF pool provider.
- Both `gcloud auth login` **and** `gcloud auth application-default login` (Terraform google provider uses ADC).
- Org Policy propagation: 5–10 minutes before a violation test is conclusive.
- WIF pools soft-delete for 30 days. Get the apply right before destroy, or undelete + `--purge` to reuse the `github-actions` id.
- Evidence capture: substitute a throwaway project → apply → `gcloud projects get-iam-policy … > evidence/lab-5-4/iam-policy.json` → destroy → `git checkout` to restore `"your-gcp-project"`. Redact real project ID **and** project number before commit.
