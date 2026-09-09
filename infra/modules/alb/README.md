# Application Load Balancer (ALB) Module

This module provisions a public-facing Application Load Balancer (ALB), Target Group, Target Group Attachments for EC2 application instances, and HTTP Listener rules.

## Features

- **Multi-AZ Public Load Balancing**: Deploys ALB across public subnets (`public-subnet-1`, `public-subnet-2`).
- **Port Translation & Routing**: Listens on HTTP Port 80 and forwards traffic to backend EC2 containers on Port 8080.
- **Automated Health Checks**: Regularly probes target instances on `/` every 30 seconds to route traffic only to healthy nodes.
- **Connection Draining**: Configures `deregistration_delay = 30` seconds for graceful target removal during deployments.
- **Security Hardening**: `drop_invalid_header_fields = true` drops non-standard HTTP header fields to protect backend instances against HTTP request smuggling attacks.

## Inputs

| Name | Description | Type | Default | Required |
| :--- | :--- | :--- | :--- | :---: |
| `environment` | Deployment environment tier (e.g. `dev`, `staging`, `prod`) | `string` | n/a | yes |
| `vpc_id` | VPC ID | `string` | n/a | yes |
| `public_subnet_ids` | List of public subnet IDs for ALB placement | `list(string)` | n/a | yes |
| `alb_security_group_id` | Security Group ID attached to ALB | `string` | n/a | yes |
| `ec2_instance_ids` | List of target EC2 instance IDs | `list(string)` | n/a | yes |
| `app_port` | Backend application port | `number` | `8080` | no |
| `health_check_path` | HTTP health check endpoint path | `string` | `"/"` | no |
| `enable_deletion_protection` | Disable deletion via API | `bool` | `false` | no |
| `tags` | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| :--- | :--- |
| `alb_dns_name` | Public DNS name of the ALB (main website entrypoint) |
| `alb_arn` | ARN of the Load Balancer |
| `alb_id` | ID of the Load Balancer |
| `alb_zone_id` | Route 53 canonical hosted zone ID |
| `target_group_arn` | Target Group ARN |
| `target_group_name` | Target Group Name |
