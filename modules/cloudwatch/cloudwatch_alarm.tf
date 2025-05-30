# CloudWatch Alarms Configuration
# This file defines all CloudWatch alarms and their notification settings

#----------------------SNS Topic Configuration----------------------#
# Create SNS topic for alarm notifications
resource "aws_sns_topic" "mail_alerts" {
  name = "${var.name_prefix}-mail-alerts" # Topic name with environment prefix
}

# Email subscription for alarm notifications
resource "aws_sns_topic_subscription" "email" {
  count     = var.alarm_alert_email != "" ? 1 : 0 # Only create if email is provided
  topic_arn = aws_sns_topic.mail_alerts.arn       # Link to SNS topic
  protocol  = "email"                             # Use email protocol
  endpoint  = var.alarm_alert_email               # Email address for notifications
}

#----------------------EC2 Monitoring----------------------#
# CPU utilization alarms for EC2 instances
resource "aws_cloudwatch_metric_alarm" "ec2_alarm" {
  count = var.create_ec2_alarms ? 1 : 0 # Only create if EC2 monitoring is enabled

  # Alarm Identification
  alarm_name        = "${var.name_prefix}-ec2-cpu"
  alarm_description = "Alarm for EC2 CPU"

  # Metric Configuration
  metric_name = lookup(var.alarm_metric, "cpu", "CPUUtilization") # CPU usage metric
  namespace   = lookup(var.alarm_namespace, "ec2", "AWS/EC2")     # EC2 metric namespace
  dimensions = {
    InstanceId = var.ec2_instance_id # Target specific EC2 instance
  }

  # Alarm Conditions
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1                                      # Number of periods to evaluate
  period              = 300                                    # 5 minutes
  statistic           = "Average"                              # Use average CPU utilization
  threshold           = lookup(var.alarm_threshold, "cpu", 80) # CPU threshold percentage

  # Alert Action
  alarm_actions = [aws_sns_topic.mail_alerts.arn] # Send to SNS topic
}

#----------------------RDS Monitoring----------------------#
# CPU utilization alarms for RDS instances
resource "aws_cloudwatch_metric_alarm" "rds_alarm" {
  count = var.create_rds_alarms ? 1 : 0 # Only create if RDS monitoring is enabled

  # Alarm Identification
  alarm_name        = "${var.name_prefix}-rds-cpu"
  alarm_description = "Alarm for RDS CPU"

  # Metric Configuration
  metric_name = lookup(var.alarm_metric, "cpu", "CPUUtilization") # CPU usage metric
  namespace   = lookup(var.alarm_namespace, "rds", "AWS/RDS")     # RDS metric namespace
  dimensions = {
    DBInstanceIdentifier = var.rds_identifier # Target specific RDS instance
  }

  # Alarm Conditions
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1                                      # Number of periods to evaluate
  period              = 300                                    # 5 minutes
  statistic           = "Average"                              # Use average CPU utilization
  threshold           = lookup(var.alarm_threshold, "cpu", 80) # CPU threshold percentage

  # Alert Action
  alarm_actions = [aws_sns_topic.mail_alerts.arn] # Send to SNS topic
}

#----------------------Redis Monitoring----------------------#
# CPU utilization alarms for Redis clusters
resource "aws_cloudwatch_metric_alarm" "redis_alarm" {
  count = var.create_redis_alarms ? 1 : 0 # Only create if Redis monitoring is enabled

  # Alarm Identification
  alarm_name        = "${var.name_prefix}-redis-cpu"
  alarm_description = "Alarm for Redis CPU"

  # Metric Configuration
  metric_name = lookup(var.alarm_metric, "cpu", "CPUUtilization")       # CPU usage metric
  namespace   = lookup(var.alarm_namespace, "redis", "AWS/ElastiCache") # Redis metric namespace
  dimensions = {
    CacheClusterId = var.redis_cluster_id # Target specific Redis cluster
  }

  # Alarm Conditions
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1                                      # Number of periods to evaluate
  period              = 300                                    # 5 minutes
  statistic           = "Average"                              # Use average CPU utilization
  threshold           = lookup(var.alarm_threshold, "cpu", 80) # CPU threshold percentage

  # Alert Action
  alarm_actions = [aws_sns_topic.mail_alerts.arn] # Send to SNS topic
}

#----------------------Log Metric Alarms----------------------#
# Alarms based on log metrics (errors, exceptions, etc.)
resource "aws_cloudwatch_metric_alarm" "log_metric_alarm" {
  for_each = local.log_alarm_specs # Create alarms for each log metric

  # Alarm Identification
  alarm_name        = each.value.alarm_name
  alarm_description = "Triggered when ${each.value.metric_name} exceeds threshold"

  # Metric Configuration
  metric_name = each.value.metric_name      # Error count metric
  namespace   = var.alarm_namespace["logs"] # Log metrics namespace

  # Alarm Conditions
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1                    # Number of periods to evaluate
  period              = 300                  # 5 minutes
  statistic           = "Average"            # Use average error count
  threshold           = each.value.threshold # Error threshold

  # Alert Action
  alarm_actions = [aws_sns_topic.mail_alerts.arn] # Send to SNS topic
}
