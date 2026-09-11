# Monitoring Module - CloudWatch Log Groups, Metric Alarms & SNS Alert Notifications

# 1. Centralized CloudWatch Log Group for EC2 Application Logs
resource "aws_cloudwatch_log_group" "ec2_app" {
  name              = "/cloudlab/${var.environment}/ec2-app-logs"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.tags,
    {
      Name        = "cloudlab-${var.environment}-ec2-app-logs"
      Environment = var.environment
    }
  )
}

# 2. Centralized CloudWatch Log Group for ALB Access Logs
resource "aws_cloudwatch_log_group" "alb_access" {
  name              = "/cloudlab/${var.environment}/alb-access-logs"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.tags,
    {
      Name        = "cloudlab-${var.environment}-alb-access-logs"
      Environment = var.environment
    }
  )
}

# 3. Amazon SNS Topic for Alarm Notifications
resource "aws_sns_topic" "alerts" {
  name = "cloudlab-${var.environment}-alerts-topic"

  tags = merge(
    var.tags,
    {
      Name        = "cloudlab-${var.environment}-alerts-topic"
      Environment = var.environment
    }
  )
}

# Conditional Email Subscription for SNS Alerts
resource "aws_sns_topic_subscription" "email" {
  count     = var.alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# 4. Metric Alarm: EC2 High CPU Utilization (>= 80%)
resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  alarm_name          = "cloudlab-${var.environment}-ec2-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "This metric monitors EC2 average CPU utilization exceeding ${var.cpu_threshold}%"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-ec2-high-cpu-alarm"
    }
  )
}

# 5. Metric Alarm: ALB High HTTP 5xx Error Rate (> 10 Errors in 5 Minutes)
resource "aws_cloudwatch_metric_alarm" "alb_high_5xx" {
  alarm_name          = "cloudlab-${var.environment}-alb-high-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = var.alb_5xx_threshold
  alarm_description   = "This metric monitors high HTTP 5xx errors from backend application targets"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = var.alb_arn_suffix != null ? {
    LoadBalancer = var.alb_arn_suffix
  } : {}

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-alb-5xx-alarm"
    }
  )
}

# 6. Metric Alarm: RDS Low Free Storage Space (<= 5 GB)
resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  alarm_name          = "cloudlab-${var.environment}-rds-low-free-storage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_low_storage_threshold_bytes
  alarm_description   = "This metric monitors RDS free storage space dropping below 5 GB"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = var.db_instance_identifier != null ? {
    DBInstanceIdentifier = var.db_instance_identifier
  } : {}

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-rds-low-storage-alarm"
    }
  )
}
