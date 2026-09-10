# Amazon S3 Object Storage Module

This module provisions an Amazon S3 bucket for centralized object storage, application upload handling, media assets, and log archives with production-grade security, encryption, and lifecycle management.

## Features

- **Globally Unique Bucket Naming**: Uses `random_id` 4-byte hex suffix (or explicit custom `bucket_name`) to prevent naming conflicts across AWS accounts.
- **Zero-Trust Public Access Block**: Sets `block_public_acls`, `block_public_policy`, `ignore_public_acls`, and `restrict_public_buckets` to `true` for 100% private security.
- **Server-Side Encryption (SSE)**: Default encryption at rest using AES256 (SSE-S3) or AWS KMS (SSE-KMS) with Bucket Keys enabled to reduce KMS API costs.
- **Object Versioning**: Keeps historical object versions (`status = "Enabled"`) to protect against accidental deletions or ransomware overwrites.
- **Automated Lifecycle Archiving**: Transitions non-current object versions to `STANDARD_IA` after 30 days and `GLACIER` after 90 days for cost optimization.

## Inputs

| Name | Description | Type | Default | Required |
| :--- | :--- | :--- | :--- | :---: |
| `environment` | Deployment environment tier (e.g. `dev`, `staging`, `prod`) | `string` | n/a | yes |
| `bucket_name` | Explicit custom bucket name | `string` | `""` | no |
| `bucket_prefix` | Auto-generated bucket prefix | `string` | `"cloudlab"` | no |
| `enable_versioning` | Enable object versioning | `bool` | `true` | no |
| `kms_key_arn` | Optional custom KMS key ARN for SSE-KMS | `string` | `null` | no |
| `force_destroy` | Allow deletion of non-empty bucket | `bool` | `true` | no |
| `ia_transition_days` | Days to transition to STANDARD_IA | `number` | `30` | no |
| `glacier_transition_days` | Days to transition to GLACIER | `number` | `90` | no |
| `tags` | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| :--- | :--- |
| `s3_bucket_id` | S3 bucket name/ID |
| `s3_bucket_arn` | S3 bucket ARN |
| `s3_bucket_domain_name` | S3 bucket domain name |
| `s3_bucket_regional_domain_name` | S3 bucket regional domain name |
| `s3_bucket_hosted_zone_id` | Route 53 hosted zone ID for S3 origin |
