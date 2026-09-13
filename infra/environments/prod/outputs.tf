output "alb_dns_name" {
  description = "The public DNS URL of the Application Load Balancer (Main Production Web Access URL)"
  value       = module.alb.alb_dns_name
}

output "vpc_id" {
  description = "The ID of the provisioned VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = module.networking.private_db_subnet_ids
}

output "ec2_instance_ids" {
  description = "IDs of the EC2 application instances"
  value       = module.compute.instance_ids
}

output "ec2_private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = module.compute.private_ips
}

output "db_instance_endpoint" {
  description = "Connection endpoint for the RDS PostgreSQL database"
  value       = module.database.db_instance_endpoint
}

output "db_secretsmanager_secret_arn" {
  description = "ARN of the AWS Secrets Manager secret storing DB credentials"
  value       = module.database.db_secretsmanager_secret_arn
}

output "s3_bucket_name" {
  description = "The name of the S3 storage bucket"
  value       = module.storage.s3_bucket_id
}

output "sns_topic_arn" {
  description = "ARN of the SNS alarm notifications topic"
  value       = module.monitoring.sns_topic_arn
}
