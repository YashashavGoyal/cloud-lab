variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "List of private application subnet IDs where EC2 instances will be launched"
  type        = list(string)
}

variable "ec2_security_group_id" {
  description = "Security Group ID for EC2 instances"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM Instance Profile name for EC2 instances (SSM access)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (Amazon Linux 2023). Leave empty to use data source lookup."
  type        = string
  default     = ""
}

variable "app_port" {
  description = "Port on which the containerized web app listens"
  type        = number
  default     = 8080
}

variable "instance_count" {
  description = "Number of EC2 application instances to launch"
  type        = number
  default     = 2
}

variable "tags" {
  description = "A map of tags to assign to compute resources"
  type        = map(string)
  default     = {}
}
