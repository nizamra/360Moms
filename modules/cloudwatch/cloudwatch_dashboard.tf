locals {
  metric_widgets = [
    # ASG metrics
    {
      x         = 0
      y         = 0
      width     = 12
      height    = 6
      type      = "metric"
      namespace = lookup(var.alarm_namespace, "asg", "AWS/AutoScaling")
      metric    = lookup(var.alarm_metric, "cpu", "CPUUtilization")
      dim       = lookup(var.alarm_dim, "asg", "AutoScalingGroupName")
      id        = var.env_configs.asg_name
      title     = "ASG CPU Utilization"
      region    = var.aws_region
    },
    # RDS metrics
    {
      x         = 0
      y         = 6
      width     = 12
      height    = 6
      type      = "metric"
      namespace = lookup(var.alarm_namespace, "rds", "AWS/RDS")
      metric    = lookup(var.alarm_metric, "cpu", "CPUUtilization")
      dim       = lookup(var.alarm_dim, "rds", "DBInstanceIdentifier")
      id        = var.env_configs.rds_id
      title     = "RDS CPU Utilization"
      region    = var.aws_region
    },
    # Redis metrics
    {
      x         = 12
      y         = 0
      width     = 12
      height    = 6
      type      = "metric"
      namespace = lookup(var.alarm_namespace, "redis", "AWS/ElastiCache")
      metric    = lookup(var.alarm_metric, "cpu", "CPUUtilization")
      dim       = lookup(var.alarm_dim, "redis", "CacheClusterId")
      id        = var.env_configs.redis_id
      title     = "Redis CPU Utilization"
      region    = var.aws_region
    }
  ]
}

resource "aws_cloudwatch_dashboard" "combined" {
  dashboard_name = "${var.name_prefix}-combined-dashboard"

  dashboard_body = jsonencode({
    widgets = concat(
      [
        {
          type   = "text"
          x      = 0
          y      = 0
          width  = 24
          height = 1
          properties = {
            markdown = "# Combined CloudWatch Dashboard"
          }
        }
      ],
      [
        for i, w in local.metric_widgets : {
          type   = "metric"
          x      = (i % 2 == 0) ? 0 : 12
          y      = 1 + floor(i / 2) * 6
          width  = 12
          height = 6
          properties = {
            metrics = [[w.namespace, w.metric, w.dim, w.id, { label = w.title }]]
            period  = 300
            stat    = "Average"
            region  = w.region
            title   = w.title
          }
        }
      ]
    )
  })
}
