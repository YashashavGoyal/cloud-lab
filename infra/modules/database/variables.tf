variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "private_db_subnet_ids" {
  description = "List of IDs for private database subnets"
  type        = list(string)
}

variable "db_security_group_id" {
  description = "Security Group ID attached to the RDS PostgreSQL database"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes (GP3)"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "The upper limit to which RDS can automatically scale storage in GB"
  type        = number
  default     = 100
}

variable "instance_class" {
  description = "The database instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.7"
}

variable "db_name" {
  description = "The name of the initial database to create"
  type        = string
  default     = "cloudlabdb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "cloudlab_admin"
}

variable "multi_az" {
  description = "Specifies if the RDS instance is Multi-AZ"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
