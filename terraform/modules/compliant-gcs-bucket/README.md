this module enforces SC-12, SC-13, SC-28, AU-11, CM-6 on a compliant GCS bucket.

## Evidence

`evidence/lab-2-4/plan.json` redacts the throwaway GCP project ID to `your-gcp-project` and the project number to `PROJECT_NUMBER` (not a fake 12-digit like `123456789012` — that form can look real inside `service-123456789012@…` emails; `PROJECT_NUMBER` is self-announcing). The placeholder-restore step protects committed `.tf`, but `plan.json` is generated *after* local substitution, so it embeds the real IDs; the project number was never typed at all — GCP derived it into `service-<N>@gs-project-accounts.iam.gserviceaccount.com`. Same forward-redact pattern as Lab 5.2 (`c8ae744`); history is not rewritten.
