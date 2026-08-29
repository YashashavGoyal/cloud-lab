# CloudLab Repository Structure

```text
cloudlab/
├── infra/
│   ├── modules/               # Reusable infrastructure blueprints
│   │   ├── networking/        # VPC, subnets, IGW, NAT
│   │   ├── security/          # Security Groups & IAM roles
│   │   ├── compute/           # EC2 instances & docker app
│   │   ├── alb/               # Load Balancer & target groups
│   │   ├── database/          # RDS PostgreSQL
│   │   ├── storage/           # S3 bucket
│   │   └── monitoring/        # CloudWatch log groups & alarms
│   │
│   └── environments/          # Environment deployments
│       ├── dev/               # Development environment entrypoint
│       ├── staging/           # Staging environment entrypoint
│       └── prod/              # Production environment entrypoint
│
├── docs/                      # Architecture, security & repository documentation
│   ├── architecture.md
│   └── structure.md
│
└── .github/workflows/         # CI/CD automation pipelines
```
