# Main CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "combined-dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "# Combined Environment Dashboard"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 1,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "CPUUtilization", "InstanceId", "${var.ec2_instance_id}", { "label": "staging EC2 CPU" } ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "EC2 CPU Utilization"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 1,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "CWAgent", "mem_used_percent", "InstanceId", "${var.ec2_instance_id}", { "label": "staging EC2 Memory" } ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "EC2 Memory Utilization"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 7,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "CWAgent", "disk_used_percent", "InstanceId", "${var.ec2_instance_id}", "path", "/", { "label": "staging EC2 Disk" } ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "EC2 Disk Utilization"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 7,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.rds_identifier}", { "label": "staging RDS CPU" } ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "RDS CPU Utilization"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 13,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${var.rds_identifier}", { "label": "staging RDS Memory" } ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "RDS Freeable Memory"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 13,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ElastiCache", "CPUUtilization", "CacheClusterId", "${var.redis_cluster_id}", { "label": "staging Redis CPU" } ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Redis CPU Utilization"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 19,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ElastiCache", "FreeableMemory", "CacheClusterId", "${var.redis_cluster_id}", { "label": "staging Redis Memory" } ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Redis Freeable Memory"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 19,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "staging-Metrics", "ApplicationErrorCount", { "label": "staging Errors" } ],
          [ "production-Metrics", "ApplicationErrorCount", { "label": "production Errors" } ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "${var.aws_region}",
        "title": "Application Error Count"
      }
    }
  ]
}
EOF
}

# staging EC2 Dashboard
resource "aws_cloudwatch_dashboard" "ec2" {
  dashboard_name = "staging-ec2-dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "# staging EC2 Dashboard"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "CPUUtilization", "InstanceId", "${var.ec2_instance_id}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "CPU Utilization"
      }
    },
    {
      "type": "metric",
      "x": 8,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "CWAgent", "mem_used_percent", "InstanceId", "${var.ec2_instance_id}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Memory Utilization"
      }
    },
    {
      "type": "metric",
      "x": 16,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "CWAgent", "disk_used_percent", "InstanceId", "${var.ec2_instance_id}", "path", "/" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Disk Utilization"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "NetworkIn", "InstanceId", "${var.ec2_instance_id}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Network In"
      }
    },
    {
      "type": "metric",
      "x": 8,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "NetworkOut", "InstanceId", "${var.ec2_instance_id}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Network Out"
      }
    },
    {
      "type": "metric",
      "x": 16,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "StatusCheckFailed_Instance", "InstanceId", "${var.ec2_instance_id}" ],
          [ "AWS/EC2", "StatusCheckFailed_System", "InstanceId", "${var.ec2_instance_id}" ]
        ],
        "period": 300,
        "stat": "Maximum",
        "region": "${var.aws_region}",
        "title": "Status Checks"
      }
    }
  ]
}
EOF
}

# staging RDS Dashboard
resource "aws_cloudwatch_dashboard" "rds" {
  dashboard_name = "staging-rds-dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "# staging RDS Dashboard"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.rds_identifier}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "CPU Utilization"
      }
    },
    {
      "type": "metric",
      "x": 8,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${var.rds_identifier}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Freeable Memory"
      }
    },
    {
      "type": "metric",
      "x": 16,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "${var.rds_identifier}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Free Storage Space"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${var.rds_identifier}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Database Connections"
      }
    },
    {
      "type": "metric",
      "x": 8,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", "${var.rds_identifier}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Read IOPS"
      }
    },
    {
      "type": "metric",
      "x": 16,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "WriteIOPS", "DBInstanceIdentifier", "${var.rds_identifier}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Write IOPS"
      }
    }
  ]
}
EOF
}

# staging Redis Dashboard
resource "aws_cloudwatch_dashboard" "redis" {
  dashboard_name = "staging-redis-dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "# staging Redis Dashboard"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ElastiCache", "CPUUtilization", "CacheClusterId", "${var.redis_cluster_id}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "CPU Utilization"
      }
    },
    {
      "type": "metric",
      "x": 8,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ElastiCache", "FreeableMemory", "CacheClusterId", "${var.redis_cluster_id}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Freeable Memory"
      }
    },
    {
      "type": "metric",
      "x": 16,
      "y": 1,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ElastiCache", "CacheHitRate", "CacheClusterId", "${var.redis_cluster_id}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Cache Hit Rate"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ElastiCache", "CurrConnections", "CacheClusterId", "${var.redis_cluster_id}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Current Connections"
      }
    },
    {
      "type": "metric",
      "x": 8,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ElastiCache", "GetTypeCmds", "CacheClusterId", "${var.redis_cluster_id}" ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "${var.aws_region}",
        "title": "Get Commands"
      }
    },
    {
      "type": "metric",
      "x": 16,
      "y": 7,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ElastiCache", "SetTypeCmds", "CacheClusterId", "${var.redis_cluster_id}" ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "${var.aws_region}",
        "title": "Set Commands"
      }
    }
  ]
}
EOF
}