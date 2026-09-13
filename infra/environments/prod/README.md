# Production Environment Stack (`infra/environments/prod/`)

This directory contains the root environment deployment stack for the CloudLab production tier. It instantiates all 7 reusable infrastructure modules (`networking`, `security`, `compute`, `database`, `alb`, `storage`, and `monitoring`) with strict production safeguards (Multi-AZ NAT Gateways, `t3.medium` instances, deletion protection, automated final database snapshots, and `force_destroy = false`).

## Module Architecture Summary

```text
                      ┌────────────────────────────────────────┐
                      │    infra/environments/prod/main.tf     │
                      └───────────────────┬────────────────────┘
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
# 1. Navigate to production environment
cd infra/environments/prod

# 2. Initialize Terraform & download providers/modules
terraform init

# 3. Validate code syntax and formatting
terraform validate

# 4. Preview production resource execution plan
terraform plan

# 5. Provision the production cloud stack
terraform apply
```

## Outputs

When `terraform apply` finishes, the production web application access URL will be printed:
- `alb_dns_name`: `http://cloudlab-prod-alb-xxxx.us-east-1.elb.amazonaws.com`
