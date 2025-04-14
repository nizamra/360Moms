# CloudWatch Alarm for EC2 Status Check
resource "aws_cloudwatch_metric_alarm" "ec2_status" {
  alarm_name          = "${var.environment}-ec2-status-check-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Alert if EC2 instance status check fails"

  dimensions = {
    InstanceId = aws_instance.app.id
  }
}