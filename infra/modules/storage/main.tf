# Storage Module - Secure Amazon S3 Bucket with Encryption, Public Access Block, Versioning & Lifecycle Rules

# 1. Random Suffix Generator for Globally Unique Bucket Naming
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

locals {
  effective_bucket_name = var.bucket_name != "" ? var.bucket_name : "${var.bucket_prefix}-${var.environment}-storage-${random_id.bucket_suffix.hex}"
}

# 2. S3 Bucket Resource
resource "aws_s3_bucket" "main" {
  bucket        = local.effective_bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      Name        = local.effective_bucket_name
      Environment = var.environment
      Tier        = "Storage"
    }
  )
}

# 3. Block All Public Access (Zero-Trust S3 Bucket Security)
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 4. Server-Side Encryption at Rest (SSE-S3 / AES256 or SSE-KMS)
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn
    }
    bucket_key_enabled = true
  }
}

# 5. S3 Object Versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# 6. S3 Lifecycle Configuration for Cost Optimization (Cold Storage Transitions)
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "archive-noncurrent-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_transition {
      noncurrent_days = var.ia_transition_days
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = var.glacier_transition_days
      storage_class   = "GLACIER"
    }
  }

  depends_on = [aws_s3_bucket_versioning.main]
}
