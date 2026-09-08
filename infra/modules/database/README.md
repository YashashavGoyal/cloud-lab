# Database Module — Multi-AZ RDS PostgreSQL

This module provisions an Amazon RDS PostgreSQL instance configured for multi-AZ high availability, storage encryption, custom parameter groups, and automated credential management via AWS Secrets Manager.

## Features

- **Multi-AZ High Availability**: Deploys Primary database instance in AZ-A and Standby instance in AZ-B for automatic failover.
- **Storage Security**: Enforces GP3 storage with KMS encryption at rest.
- **Zero-Trust Network Isolation**: Placed strictly in private DB subnets (`publicly_accessible = false`) with ingress restricted to `ec2_security_group_id` on port 5432.
- **SSL Connection Enforcement**: Custom parameter group with `rds.force_ssl = 1`.
- **Automated Credential Management**: Generates a random 16-character password and stores JSON connection metadata in AWS Secrets Manager.

## Inputs

| Name | Description | Type | Default | Required |
| :--- | :--- | :--- | :--- | :---: |
| `environment` | Deployment environment tier (e.g. `dev`, `staging`, `prod`) | `string` | n/a | yes |
| `private_db_subnet_ids` | List of IDs for private database subnets | `list(string)` | n/a | yes |
| `db_security_group_id` | Security Group ID attached to RDS PostgreSQL | `string` | n/a | yes |
| `allocated_storage` | Storage capacity in GB (GP3) | `number` | `20` | no |
| `max_allocated_storage` | Upper threshold for auto-scaling storage | `number` | `100` | no |
| `instance_class` | Database instance type | `string` | `"db.t4g.micro"` | no |
| `engine_version` | PostgreSQL engine version | `string` | `"15.7"` | no |
| `db_name` | Initial database name | `string` | `"cloudlabdb"` | no |
| `db_username` | Master username | `string` | `"cloudlab_admin"` | no |
| `multi_az` | Enable Multi-AZ failover deployment | `bool` | `true` | no |
| `skip_final_snapshot` | Skip snapshot before deletion | `bool` | `true` | no |
| `tags` | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| :--- | :--- |
| `db_instance_endpoint` | Connection endpoint (`address:port`) |
| `db_instance_address` | Hostname of the RDS instance |
| `db_instance_port` | Database port (`5432`) |
| `db_instance_name` | Initial database name |
| `db_instance_id` | RDS database instance ID |
| `db_instance_arn` | ARN of the RDS database instance |
| `db_secretsmanager_secret_arn` | ARN of the AWS Secrets Manager secret storing database credentials |
