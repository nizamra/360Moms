locals {
  metric_widgets = [
    # EC2 metrics
    {
      x         = 0
      y         = 0
      width     = 12
      height    = 6
      type      = "metric"
      namespace = lookup(var.alarm_namespace, "ec2", "AWS/EC2")
      metric    = lookup(var.alarm_metric, "cpu", "CPUUtilization")
      dim       = "InstanceId"
      id        = var.ec2_instance_id
      title     = "EC2 CPU Utilization"
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
      dim       = "DBInstanceIdentifier"
      id        = var.rds_identifier
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
      dim       = "CacheClusterId"
      id        = var.redis_cluster_id
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
