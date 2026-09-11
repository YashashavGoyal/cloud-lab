variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain log events in CloudWatch Log Groups"
  type        = number
  default     = 14
}

variable "alert_email" {
  description = "Optional email address to receive SNS alert notifications for CloudWatch alarms"
  type        = string
  default     = ""
}

variable "cpu_threshold" {
  description = "High CPU utilization alarm threshold percentage for EC2 instances"
  type        = number
  default     = 80
}

variable "alb_5xx_threshold" {
  description = "Threshold count for ALB HTTP 5xx target errors in a 5-minute evaluation period"
  type        = number
  default     = 10
}

variable "rds_low_storage_threshold_bytes" {
  description = "Free storage space threshold in bytes for RDS PostgreSQL database instance (default 5GB)"
  type        = number
  default     = 5368709120
}

variable "alb_arn_suffix" {
  description = "Optional ALB ARN suffix for CloudWatch metric dimensions"
  type        = string
  default     = null
}

variable "db_instance_identifier" {
  description = "Optional RDS DB instance identifier for CloudWatch metric dimensions"
  type        = string
  default     = null
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
