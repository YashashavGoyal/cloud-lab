# Security Module

This module manages security boundaries and IAM authentication across CloudLab:
- **Application Load Balancer Security Group**: Inbound HTTP/HTTPS from public internet
- **EC2 Security Group**: Inbound app port (8080) strictly from ALB SG, outbound internet access via NAT Gateway
- **RDS PostgreSQL Security Group**: Inbound PostgreSQL port (5432) strictly from EC2 SG, zero egress
- **IAM SSM Role & Instance Profile**: Enables SSH-less EC2 session management via AWS Systems Manager

## Usage

```hcl
module "security" {
  source = "../../modules/security"

  environment = "dev"
  vpc_id      = module.networking.vpc_id
  app_port    = 8080

  tags = {
    Project     = "CloudLab"
    Environment = "dev"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
| :--- | :--- | :--- | :--- | :--- |
| `environment` | Deployment environment name (e.g. dev, staging, prod) | `string` | n/a | yes |
| `vpc_id` | ID of the VPC where security groups are created | `string` | n/a | yes |
| `app_port` | Application container port for EC2 instances | `number` | `8080` | no |
| `tags` | Map of resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| :--- | :--- |
| `alb_security_group_id` | Security Group ID for the Application Load Balancer |
| `ec2_security_group_id` | Security Group ID for EC2 application instances |
| `db_security_group_id` | Security Group ID for RDS PostgreSQL database |
| `ec2_iam_instance_profile_name` | Name of the IAM Instance Profile for EC2 |
| `ec2_iam_instance_profile_arn` | ARN of the IAM Instance Profile for EC2 |
| `ec2_iam_role_arn` | ARN of the IAM Role for EC2 SSM management |
