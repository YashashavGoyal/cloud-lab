# Networking Module

This module provisions a 3-tier, multi-AZ networking foundation in AWS:
- **VPC** with configurable CIDR space and DNS hostnames enabled
- **Public Subnets** for Application Load Balancers and NAT Gateways
- **Private Application Subnets** for EC2 instance workloads
- **Private Database Subnets** (Isolated, zero-route data tier) for Amazon RDS
- **Internet Gateway** and configurable **NAT Gateway(s)** (Single NAT for non-prod savings, Multi-AZ NAT for prod)

## Usage

```hcl
module "networking" {
  source = "../../modules/networking"

  environment               = "dev"
  vpc_cidr                  = "10.0.0.0/16"
  availability_zones        = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnet_cidrs   = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_subnet_cidrs    = ["10.0.21.0/24", "10.0.22.0/24"]
  single_nat_gateway        = true

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
| `vpc_cidr` | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| `availability_zones` | List of availability zones | `list(string)` | n/a | yes |
| `public_subnet_cidrs` | CIDR blocks for public subnets | `list(string)` | n/a | yes |
| `private_app_subnet_cidrs` | CIDR blocks for private app subnets | `list(string)` | n/a | yes |
| `private_db_subnet_cidrs` | CIDR blocks for private DB subnets | `list(string)` | n/a | yes |
| `single_nat_gateway` | Deploy a single shared NAT GW for cost savings | `bool` | `true` | no |
| `tags` | Map of resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| :--- | :--- |
| `vpc_id` | ID of the VPC |
| `vpc_cidr_block` | CIDR block of the VPC |
| `public_subnet_ids` | List of IDs of public subnets |
| `private_app_subnet_ids` | List of IDs of private app subnets |
| `private_db_subnet_ids` | List of IDs of private DB subnets |
| `nat_gateway_ips` | List of Elastic IPs attached to NAT Gateways |
