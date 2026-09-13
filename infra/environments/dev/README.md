# Development Environment Stack (`infra/environments/dev/`)

This directory contains the root environment deployment stack for the CloudLab development tier. It instantiates and wires together all 7 reusable infrastructure modules (`networking`, `security`, `compute`, `database`, `alb`, `storage`, and `monitoring`).

## Module Architecture Summary

```text
                        ┌─────────────────────────────────────┐
                        │     infra/environments/dev/main.tf  │
                        └──────────────────┬──────────────────┘
                                           │
         ┌──────────────────┬──────────────┼──────────────┬──────────────────┐
         ▼                  ▼              ▼              ▼                  ▼
┌─────────────────┐ ┌───────────────┐ ┌──────────┐ ┌────────────┐ ┌────────────────────┐
│ module.networking│ │module.security│ │module.alb│ │module.comp │ │  module.database   │
└─────────────────┘ └───────────────┘ └──────────┘ └────────────┘ └────────────────────┘
                                           │              │
                                           ▼              ▼
                                    ┌──────────────┐ ┌───────────┐
                                    │module.storage│ │module.mon │
                                    └──────────────┘ └───────────┘
```

## Quick Start Deployment Commands

```bash
# 1. Navigate to dev environment
cd infra/environments/dev

# 2. Initialize Terraform & download providers/modules
terraform init

# 3. Validate code syntax and formatting
terraform validate

# 4. Preview resource creation execution plan
terraform plan

# 5. Provision the complete development cloud stack
terraform apply

# 6. Destroy all cloud resources when lab session is finished
terraform destroy
```

## Outputs

When `terraform apply` finishes, the primary web application access URL will be printed:
- `alb_dns_name`: `http://cloudlab-dev-alb-xxxx.us-east-1.elb.amazonaws.com`
