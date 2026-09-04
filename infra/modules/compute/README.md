# Compute Module

This module provisions containerized EC2 application instances in private subnets:
- **Zero Public IP**: Instances are strictly private (`associate_public_ip_address = false`)
- **IMDSv2 Enforcement**: Blocks SSRF credential theft attacks (`http_tokens = "required"`)
- **Encrypted EBS Storage**: 20GB `gp3` root volume encrypted at rest
- **Automated Docker Bootstrap**: User data script installs Docker and launches containerized application on port 8080
- **SSH-less Administration**: Attached to IAM Instance Profile for AWS Systems Manager (SSM) access

## Usage

```hcl
module "compute" {
  source = "../../modules/compute"

  environment                  = "dev"
  private_app_subnet_ids       = module.networking.private_app_subnet_ids
  ec2_security_group_id        = module.security.ec2_security_group_id
  ec2_iam_instance_profile_name = module.security.ec2_iam_instance_profile_name
  instance_type                = "t3.micro"
  instance_count               = 2
  app_port                     = 8080

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
| `private_app_subnet_ids` | List of private app subnet IDs | `list(string)` | n/a | yes |
| `ec2_security_group_id` | Security Group ID for EC2 instances | `string` | n/a | yes |
| `iam_instance_profile_name` | IAM Instance Profile name for EC2 instances | `string` | n/a | yes |
| `instance_type` | EC2 instance size | `string` | `"t3.micro"` | no |
| `ami_id` | AMI ID for EC2 (Leave blank for latest Amazon Linux 2023) | `string` | `""` | no |
| `app_port` | Application container port | `number` | `8080` | no |
| `instance_count` | Number of EC2 instances to launch | `number` | `2` | no |
| `tags` | Map of resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| :--- | :--- |
| `instance_ids` | List of IDs of the provisioned EC2 instances |
| `private_ips` | List of private IP addresses assigned to EC2 instances |
| `ami_id_used` | AMI ID used to launch the EC2 instances |
