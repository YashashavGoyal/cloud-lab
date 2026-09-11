output "sns_topic_arn" {
  description = "The ARN of the SNS alert notifications topic"
  value       = aws_sns_topic.alerts.arn
}

output "sns_topic_name" {
  description = "The name of the SNS alert notifications topic"
  value       = aws_sns_topic.alerts.name
}

output "ec2_log_group_name" {
  description = "The name of the CloudWatch Log Group for EC2 application logs"
  value       = aws_cloudwatch_log_group.ec2_app.name
}

output "ec2_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for EC2 application logs"
  value       = aws_cloudwatch_log_group.ec2_app.arn
}

output "alb_log_group_name" {
  description = "The name of the CloudWatch Log Group for ALB access logs"
  value       = aws_cloudwatch_log_group.alb_access.name
}

output "alb_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for ALB access logs"
  value       = aws_cloudwatch_log_group.alb_access.arn
}

output "ec2_cpu_alarm_arn" {
  description = "The ARN of the EC2 High CPU CloudWatch metric alarm"
  value       = aws_cloudwatch_metric_alarm.ec2_high_cpu.arn
}

output "alb_5xx_alarm_arn" {
  description = "The ARN of the ALB High HTTP 5xx Error metric alarm"
  value       = aws_cloudwatch_metric_alarm.alb_high_5xx.arn
}

output "rds_storage_alarm_arn" {
  description = "The ARN of the RDS Low Free Storage Space metric alarm"
  value       = aws_cloudwatch_metric_alarm.rds_low_storage.arn
}
