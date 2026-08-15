# AWS security services baseline (Lab 5.2)

Account-level baseline: multi-region CloudTrail (management events + log-file validation) and Security Hub with NIST 800-53 Rev 5 + AWS Foundational Security Best Practices subscribed. Evidence artifact: `evidence/lab-5-2/security-hub-findings.json`.

## Controls

| Service | Controls | How this baseline satisfies them |
|---|---|---|
| CloudTrail | AU-2, AU-12 | Multi-region management-event trail (`cgep-lab-mgmt`) records API activity account-wide. |
| CloudTrail | AU-10 | `enable_log_file_validation = true`: hourly signed digest files for tamper detection. |
| Security Hub | RA-5, SI-4 | NIST 800-53 Rev 5 + FSBP subscriptions produce continuous, normalized findings. |
| AWS Config | CM-2, CM-6, CM-8 | **Not deployed** (see Declared delta). |

## Declared delta

`config.tf` is omitted. The lab’s reference walkthrough does not deploy Config (SCP-blocked in the author’s test account). This sandbox is the org management account (SCPs do not apply here), but we still skip Config for lab fidelity. Security Hub’s Config.1 finding (“AWS Config should be enabled…”) is itself evidence of that gap.

CloudTrail SSE `rule` block is multi-line. The lab’s single-line nested form (`rule { apply_server_side_encryption_by_default { … } }`) is invalid HCL and fails `terraform init`; attributes are unchanged.

The AWS account ID in `evidence/lab-5-2/security-hub-findings.json` is redacted to the AWS-docs placeholder `123456789012` (CloudTrail/Security Hub ARNs embed the account ID; S3-only evidence in earlier labs never did). Consistent with the Lab 4.3 precedent of keeping the real account ID out of the public repo.

## Apply notes

- If Security Hub is already enabled: `terraform import aws_securityhub_account.this <ACCOUNT_ID>` before the first apply.
- Privileged AWS ops in this sandbox require an MFA session.
- No `config.tf`. Do not add one unless intentionally departing from this delta.
