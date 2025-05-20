resource "aws_sns_topic" "mail_alerts" {
  name = "${var.name_prefix}-mail-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alarm_alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.mail_alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_alert_email
}

# Specific alarms for ASG
resource "aws_cloudwatch_metric_alarm" "asg_alarm" {
  count = var.create_asg_alarms ? 1 : 0

  alarm_name          = "${var.name_prefix}-asg-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = lookup(var.alarm_metric, "cpu", "CPUUtilization")
  namespace           = lookup(var.alarm_namespace, "asg", "AWS/AutoScaling")
  period              = 300
  statistic           = "Sum"
  threshold           = lookup(var.alarm_threshold, "cpu", 80)
  alarm_description   = "Alarm for ASG CPU"
  alarm_actions       = [aws_sns_topic.mail_alerts.arn]

  dimensions = {
    AutoScalingGroupName = var.env_configs.asg_name
  }
}

# Specific alarms for RDS
resource "aws_cloudwatch_metric_alarm" "rds_alarm" {
  count = var.create_rds_alarms ? 1 : 0

  alarm_name          = "${var.name_prefix}-rds-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = lookup(var.alarm_metric, "cpu", "CPUUtilization")
  namespace           = lookup(var.alarm_namespace, "rds", "AWS/RDS")
  period              = 300
  statistic           = "Sum"
  threshold           = lookup(var.alarm_threshold, "cpu", 80)
  alarm_description   = "Alarm for RDS CPU"
  alarm_actions       = [aws_sns_topic.mail_alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.env_configs.rds_id
  }
}

# Specific alarms for Redis
resource "aws_cloudwatch_metric_alarm" "redis_alarm" {
  count = var.create_redis_alarms ? 1 : 0

  alarm_name          = "${var.name_prefix}-redis-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = lookup(var.alarm_metric, "cpu", "CPUUtilization")
  namespace           = lookup(var.alarm_namespace, "redis", "AWS/ElastiCache")
  period              = 300
  statistic           = "Sum"
  threshold           = lookup(var.alarm_threshold, "cpu", 80)
  alarm_description   = "Alarm for Redis CPU"
  alarm_actions       = [aws_sns_topic.mail_alerts.arn]

  dimensions = {
    CacheClusterId = var.env_configs.redis_id
  }
}

resource "aws_cloudwatch_metric_alarm" "log_metric_alarm" {
  for_each = local.log_alarm_specs

  alarm_name  = each.value.alarm_name
  metric_name = each.value.metric_name
  namespace   = var.alarm_namespace["logs"]

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Sum"
  threshold           = each.value.threshold

  alarm_description = "Triggered when ${each.value.metric_name} exceeds threshold"
  alarm_actions     = [aws_sns_topic.mail_alerts.arn]
}
