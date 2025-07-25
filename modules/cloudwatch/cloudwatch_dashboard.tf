# CloudWatch Dashboard Configuration
# This file defines the layout and content of the CloudWatch monitoring dashboard

#----------------------Dashboard Widget Configuration----------------------#
locals {
  # Define metric widgets for each monitored service
  metric_widgets = [
    #----------------------EC2 Monitoring Widget----------------------#
    # CPU utilization metrics for EC2 instances
    {
      x         = 0                                                 # Horizontal position
      y         = 0                                                 # Vertical position
      width     = 12                                                # Widget width (half screen)
      height    = 6                                                 # Widget height
      type      = "metric"                                          # Widget type for metrics
      namespace = lookup(var.alarm_namespace, "ec2", "AWS/EC2")     # EC2 metrics namespace
      metric    = lookup(var.alarm_metric, "cpu", "CPUUtilization") # CPU metric
      dim       = "InstanceId"                                      # Dimension for EC2
      id        = var.ec2_instance_id                               # Target instance
      title     = "EC2 CPU Utilization"                             # Widget title
      region    = var.aws_region                                    # AWS region
    },
    #----------------------RDS Monitoring Widget----------------------#
    # CPU utilization metrics for RDS instances
    {
      x         = 0                                                 # Horizontal position
      y         = 6                                                 # Vertical position
      width     = 12                                                # Widget width (half screen)
      height    = 6                                                 # Widget height
      type      = "metric"                                          # Widget type for metrics
      namespace = lookup(var.alarm_namespace, "rds", "AWS/RDS")     # RDS metrics namespace
      metric    = lookup(var.alarm_metric, "cpu", "CPUUtilization") # CPU metric
      dim       = "DBInstanceIdentifier"                            # Dimension for RDS
      id        = var.rds_identifier                                # Target database
      title     = "RDS CPU Utilization"                             # Widget title
      region    = var.aws_region                                    # AWS region
    },
    #----------------------Redis Monitoring Widget----------------------#
    # CPU utilization metrics for Redis clusters
    {
      x         = 12                                                      # Horizontal position
      y         = 0                                                       # Vertical position
      width     = 12                                                      # Widget width (half screen)
      height    = 6                                                       # Widget height
      type      = "metric"                                                # Widget type for metrics
      namespace = lookup(var.alarm_namespace, "redis", "AWS/ElastiCache") # Redis metrics namespace
      metric    = lookup(var.alarm_metric, "cpu", "CPUUtilization")       # CPU metric
      dim       = "CacheClusterId"                                        # Dimension for Redis
      id        = var.redis_cluster_id                                    # Target cluster
      title     = "Redis CPU Utilization"                                 # Widget title
      region    = var.aws_region                                          # AWS region
    }
  ]
}

#----------------------Dashboard Resource----------------------#
# Create the CloudWatch dashboard combining all widgets
resource "aws_cloudwatch_dashboard" "combined" {
  dashboard_name = "${var.name_prefix}-combined-dashboard" # Unique dashboard name

  # Dashboard JSON configuration
  dashboard_body = jsonencode({
    widgets = concat(
      # Dashboard Title Widget
      [
        {
          type   = "text"
          x      = 0  # Start at left
          y      = 0  # Start at top
          width  = 24 # Full width
          height = 1  # Minimal height
          properties = {
            markdown = "# Combined CloudWatch Dashboard" # Dashboard title
          }
        }
      ],
      # Metric Widgets
      [
        # Generate widget configurations dynamically
        for i, w in local.metric_widgets : {
          type   = "metric"
          x      = (i % 2 == 0) ? 0 : 12 # Alternate between left and right
          y      = 1 + floor(i / 2) * 6  # Stack vertically with title offset
          width  = 12                    # Half width
          height = 6                     # Standard height
          properties = {
            metrics = [[w.namespace, w.metric, w.dim, w.id, { label = w.title }]] # Metric configuration
            period  = 300                                                         # 5-minute periods
            stat    = "Average"                                                   # Use average statistic
            region  = w.region                                                    # AWS region
            title   = w.title                                                     # Widget title
          }
        }
      ]
    )
  })
}
