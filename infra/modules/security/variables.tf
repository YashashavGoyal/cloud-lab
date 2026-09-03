variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where security groups will be created"
  type        = string
}

variable "app_port" {
  description = "Application container port for EC2 instances"
  type        = number
  default     = 8080
}

variable "tags" {
  description = "A map of tags to assign to all security resources"
  type        = map(string)
  default     = {}
}
