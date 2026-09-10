variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "bucket_name" {
  description = "Optional custom name for the S3 bucket. If omitted, a unique name using environment and random suffix will be generated."
  type        = string
  default     = ""
}

variable "bucket_prefix" {
  description = "Prefix for the auto-generated S3 bucket name if bucket_name is not specified"
  type        = string
  default     = "cloudlab"
}

variable "enable_versioning" {
  description = "Enable object versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "Optional custom KMS Key ARN for Server-Side Encryption (SSE-KMS). If omitted, default AES256 (SSE-S3) encryption is used."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = true
}

variable "ia_transition_days" {
  description = "Number of days after which non-current object versions transition to STANDARD_IA"
  type        = number
  default     = 30
}

variable "glacier_transition_days" {
  description = "Number of days after which non-current object versions transition to GLACIER"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
