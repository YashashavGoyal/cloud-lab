variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where the ALB will be deployed"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security Group ID attached to the Application Load Balancer"
  type        = string
}

variable "ec2_instance_ids" {
  description = "List of EC2 instance IDs to register with the Target Group"
  type        = list(string)
}

variable "app_port" {
  description = "Port on which the backend application containers listen"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "Destination path for HTTP health check requests"
  type        = string
  default     = "/"
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
