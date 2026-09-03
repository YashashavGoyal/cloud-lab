output "alb_security_group_id" {
  description = "Security Group ID of the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "Security Group ID of the EC2 Application instances"
  value       = aws_security_group.ec2.id
}

output "db_security_group_id" {
  description = "Security Group ID of the RDS PostgreSQL database"
  value       = aws_security_group.db.id
}

output "ec2_iam_instance_profile_name" {
  description = "Name of the IAM Instance Profile for EC2 instances"
  value       = aws_iam_instance_profile.ec2.name
}

output "ec2_iam_instance_profile_arn" {
  description = "ARN of the IAM Instance Profile for EC2 instances"
  value       = aws_iam_instance_profile.ec2.arn
}

output "ec2_iam_role_arn" {
  description = "ARN of the IAM Role for EC2 SSM management"
  value       = aws_iam_role.ec2_ssm.arn
}
