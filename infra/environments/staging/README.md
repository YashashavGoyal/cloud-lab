# Staging Environment Stack (`infra/environments/staging/`)

This directory contains the root environment deployment stack for the CloudLab staging tier. It instantiates all 7 reusable infrastructure modules (`networking`, `security`, `compute`, `database`, `alb`, `storage`, and `monitoring`) with production-equivalent configurations (multi-AZ NAT Gateways, `t3.small` instances, and automated DB snapshots).

## Module Architecture Summary

```text
                     ┌─────────────────────────────────────────┐
                     │   infra/environments/staging/main.tf    │
                     └────────────────────┬────────────────────┘
                                          │
         ┌──────────────────┬─────────────┼─────────────┬──────────────────┐
         ▼                  ▼             ▼             ▼                  ▼
┌─────────────────┐ ┌───────────────┐ ┌──────────┐ ┌────────────┐ ┌────────────────────┐
│ module.networking│ │module.security│ │module.alb│ │module.comp │ │  module.database   │
└─────────────────┘ └───────────────┘ └──────────┘ └────────────┘ └────────────────────┘
                                          │             │
                                          ▼             ▼
                                   ┌──────────────┐ ┌───────────┐
                                   │module.storage│ │module.mon │
                                   └──────────────┘ └───────────┘
```

## Quick Start Deployment Commands

```bash
# 1. Navigate to staging environment
cd infra/environments/staging

# 2. Initialize Terraform & download providers/modules
terraform init

# 3. Validate code syntax and formatting
terraform validate

# 4. Preview resource creation execution plan
terraform plan

# 5. Provision the staging cloud stack
terraform apply

# 6. Destroy all cloud resources when finished
terraform destroy
```

## Outputs

When `terraform apply` finishes, the staging web application access URL will be printed:
- `alb_dns_name`: `http://cloudlab-staging-alb-xxxx.us-east-1.elb.amazonaws.com`
