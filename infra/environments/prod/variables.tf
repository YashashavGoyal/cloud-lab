variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.2.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "List of private application subnet CIDR blocks"
  type        = list(string)
  default     = ["10.2.11.0/24", "10.2.12.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "List of private database subnet CIDR blocks"
  type        = list(string)
  default     = ["10.2.21.0/24", "10.2.22.0/24"]
}

variable "availability_zones" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "single_nat_gateway" {
  description = "Provision a single NAT Gateway or dedicated NAT Gateway per AZ"
  type        = bool
  default     = false
}

variable "app_port" {
  description = "Backend container application port"
  type        = number
  default     = 8080
}

variable "instance_type" {
  description = "EC2 instance type for application servers"
  type        = string
  default     = "t3.medium"
}

variable "instance_count" {
  description = "Number of EC2 application instances"
  type        = number
  default     = 2
}

variable "db_instance_class" {
  description = "RDS database instance class"
  type        = string
  default     = "db.t4g.medium"
}

variable "deletion_protection" {
  description = "Enable deletion protection on production database and load balancer resources"
  type        = bool
  default     = true
}

variable "alert_email" {
  description = "Email address to receive SNS alert notifications"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project   = "CloudLab"
    ManagedBy = "Terraform"
  }
}
