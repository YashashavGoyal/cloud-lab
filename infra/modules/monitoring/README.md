# CloudWatch Monitoring & Observability Module

This module provisions centralized CloudWatch Log Groups, metric alarms for the 3-tier infrastructure (EC2, ALB, RDS), and Amazon SNS alert notification topics.

## Features

- **Centralized Log Retention**: Log groups for EC2 application logs and ALB access logs with configurable retention (`retention_in_days = 14`) to prevent unlimited storage billing.
- **Proactive SNS Alerts**: Integrates Amazon SNS topic (`cloudlab-${var.environment}-alerts-topic`) with optional email notifications for instant incident alerts.
- **Compute Tier Alarm**: Triggers when EC2 average CPU utilization exceeds **80%** over two 5-minute evaluation windows.
- **Load Balancer Tier Alarm**: Triggers when ALB HTTP 5xx target error count exceeds **10** in a 5-minute window.
- **Database Tier Alarm**: Triggers when RDS PostgreSQL free storage drops below **5 GB**.

## Inputs

| Name | Description | Type | Default | Required |
| :--- | :--- | :--- | :--- | :---: |
| `environment` | Deployment environment tier (e.g. `dev`, `staging`, `prod`) | `string` | n/a | yes |
| `log_retention_days` | Log retention period in days | `number` | `14` | no |
| `alert_email` | Optional email address for SNS alert subscriptions | `string` | `""` | no |
| `cpu_threshold` | High CPU threshold percentage | `number` | `80` | no |
| `alb_5xx_threshold` | High 5xx error count threshold | `number` | `10` | no |
| `rds_low_storage_threshold_bytes` | Low storage threshold in bytes (default 5GB) | `number` | `5368709120` | no |
| `alb_arn_suffix` | Optional ALB ARN suffix dimension | `string` | `null` | no |
| `db_instance_identifier` | Optional RDS DB instance identifier dimension | `string` | `null` | no |
| `tags` | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| :--- | :--- |
| `sns_topic_arn` | ARN of the SNS alert topic |
| `sns_topic_name` | Name of the SNS alert topic |
| `ec2_log_group_name` | EC2 log group name (`/cloudlab/${var.environment}/ec2-app-logs`) |
| `ec2_log_group_arn` | EC2 log group ARN |
| `alb_log_group_name` | ALB log group name (`/cloudlab/${var.environment}/alb-access-logs`) |
| `alb_log_group_arn` | ALB log group ARN |
| `ec2_cpu_alarm_arn` | EC2 high CPU metric alarm ARN |
| `alb_5xx_alarm_arn` | ALB high 5xx metric alarm ARN |
| `rds_storage_alarm_arn` | RDS low storage metric alarm ARN |
