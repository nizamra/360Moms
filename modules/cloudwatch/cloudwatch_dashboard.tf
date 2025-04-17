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
          [ "AWS/EC2", "CPUUtilization", "InstanceId", "${var.stag_ec2_instance_id}", { "label": "STAGING EC2 CPU" } ],
          [ "AWS/EC2", "CPUUtilization", "InstanceId", "${var.prod_ec2_instance_id}", { "label": "PRODUCTION EC2 CPU" } ]
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
          [ "CWAgent", "mem_used_percent", "InstanceId", "${var.stag_ec2_instance_id}", { "label": "STAGING EC2 Memory" } ],
          [ "CWAgent", "mem_used_percent", "InstanceId", "${var.prod_ec2_instance_id}", { "label": "PRODUCTION EC2 Memory" } ]
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
          [ "CWAgent", "disk_used_percent", "InstanceId", "${var.stag_ec2_instance_id}", "path", "/", { "label": "STAGING EC2 Disk" } ],
          [ "CWAgent", "disk_used_percent", "InstanceId", "${var.prod_ec2_instance_id}", "path", "/", { "label": "PRODUCTION EC2 Disk" } ]
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
          [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.stag_rds_identifier}", { "label": "STAGING RDS CPU" } ],
          [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.prod_rds_identifier}", { "label": "PRODUCTION RDS CPU" } ]
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
          [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${var.stag_rds_identifier}", { "label": "STAGING RDS Memory" } ],
          [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${var.prod_rds_identifier}", { "label": "PRODUCTION RDS Memory" } ]
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
          [ "AWS/ElastiCache", "CPUUtilization", "CacheClusterId", "${var.stag_redis_cluster_id}", { "label": "STAGING Redis CPU" } ],
          [ "AWS/ElastiCache", "CPUUtilization", "CacheClusterId", "${var.prod_redis_cluster_id}", { "label": "PRODUCTION Redis CPU" } ]
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
          [ "AWS/ElastiCache", "FreeableMemory", "CacheClusterId", "${var.stag_redis_cluster_id}", { "label": "STAGING Redis Memory" } ],
          [ "AWS/ElastiCache", "FreeableMemory", "CacheClusterId", "${var.prod_redis_cluster_id}", { "label": "PRODUCTION Redis Memory" } ]
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
          [ "STAGING-Metrics", "ApplicationErrorCount", { "label": "STAGING Errors" } ],
          [ "PRODUCTION-Metrics", "ApplicationErrorCount", { "label": "PRODUCTION Errors" } ]
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

# STAGING EC2 Dashboard
resource "aws_cloudwatch_dashboard" "stag_ec2" {
  dashboard_name = "STAGING-ec2-dashboard"

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
        "markdown": "# STAGING EC2 Dashboard"
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
          [ "AWS/EC2", "CPUUtilization", "InstanceId", "${var.stag_ec2_instance_id}" ]
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
          [ "CWAgent", "mem_used_percent", "InstanceId", "${var.stag_ec2_instance_id}" ]
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
          [ "CWAgent", "disk_used_percent", "InstanceId", "${var.stag_ec2_instance_id}", "path", "/" ]
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
          [ "AWS/EC2", "NetworkIn", "InstanceId", "${var.stag_ec2_instance_id}" ]
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
          [ "AWS/EC2", "NetworkOut", "InstanceId", "${var.stag_ec2_instance_id}" ]
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
          [ "AWS/EC2", "StatusCheckFailed_Instance", "InstanceId", "${var.stag_ec2_instance_id}" ],
          [ "AWS/EC2", "StatusCheckFailed_System", "InstanceId", "${var.stag_ec2_instance_id}" ]
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

# PRODUCTION EC2 Dashboard
resource "aws_cloudwatch_dashboard" "prod_ec2" {
  dashboard_name = "PRODUCTION-ec2-dashboard"

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
        "markdown": "# PRODUCTION EC2 Dashboard"
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
          [ "AWS/EC2", "CPUUtilization", "InstanceId", "${var.prod_ec2_instance_id}" ]
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
          [ "CWAgent", "mem_used_percent", "InstanceId", "${var.prod_ec2_instance_id}" ]
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
          [ "CWAgent", "disk_used_percent", "InstanceId", "${var.prod_ec2_instance_id}", "path", "/" ]
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
          [ "AWS/EC2", "NetworkIn", "InstanceId", "${var.prod_ec2_instance_id}" ]
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
          [ "AWS/EC2", "NetworkOut", "InstanceId", "${var.prod_ec2_instance_id}" ]
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
          [ "AWS/EC2", "StatusCheckFailed_Instance", "InstanceId", "${var.prod_ec2_instance_id}" ],
          [ "AWS/EC2", "StatusCheckFailed_System", "InstanceId", "${var.prod_ec2_instance_id}" ]
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

# STAGING RDS Dashboard
resource "aws_cloudwatch_dashboard" "stag_rds" {
  dashboard_name = "STAGING-rds-dashboard"

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
        "markdown": "# STAGING RDS Dashboard"
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
          [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.stag_rds_identifier}" ]
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
          [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${var.stag_rds_identifier}" ]
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
          [ "AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "${var.stag_rds_identifier}" ]
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
          [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${var.stag_rds_identifier}" ]
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
          [ "AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", "${var.stag_rds_identifier}" ]
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
          [ "AWS/RDS", "WriteIOPS", "DBInstanceIdentifier", "${var.stag_rds_identifier}" ]
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

# PRODUCTION RDS Dashboard
resource "aws_cloudwatch_dashboard" "prod_rds" {
  dashboard_name = "PRODUCTION-rds-dashboard"

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
        "markdown": "# PRODUCTION RDS Dashboard"
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
          [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.prod_rds_identifier}" ]
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
          [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${var.prod_rds_identifier}" ]
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
          [ "AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "${var.prod_rds_identifier}" ]
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
          [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${var.prod_rds_identifier}" ]
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
          [ "AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", "${var.prod_rds_identifier}" ]
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
          [ "AWS/RDS", "WriteIOPS", "DBInstanceIdentifier", "${var.prod_rds_identifier}" ]
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

# STAGING Redis Dashboard
resource "aws_cloudwatch_dashboard" "stag_redis" {
  dashboard_name = "STAGING-redis-dashboard"

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
        "markdown": "# STAGING Redis Dashboard"
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
          [ "AWS/ElastiCache", "CPUUtilization", "CacheClusterId", "${var.stag_redis_cluster_id}" ]
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
          [ "AWS/ElastiCache", "FreeableMemory", "CacheClusterId", "${var.stag_redis_cluster_id}" ]
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
          [ "AWS/ElastiCache", "CacheHitRate", "CacheClusterId", "${var.stag_redis_cluster_id}" ]
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
          [ "AWS/ElastiCache", "CurrConnections", "CacheClusterId", "${var.stag_redis_cluster_id}" ]
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
          [ "AWS/ElastiCache", "GetTypeCmds", "CacheClusterId", "${var.stag_redis_cluster_id}" ]
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
          [ "AWS/ElastiCache", "SetTypeCmds", "CacheClusterId", "${var.stag_redis_cluster_id}" ]
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

# PRODUCTION Redis Dashboard
resource "aws_cloudwatch_dashboard" "prod_redis" {
  dashboard_name = "PRODUCTION-redis-dashboard"

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
        "markdown": "# PRODUCTION Redis Dashboard"
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
          [ "AWS/ElastiCache", "CPUUtilization", "CacheClusterId", "${var.prod_redis_cluster_id}" ]
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
          [ "AWS/ElastiCache", "FreeableMemory", "CacheClusterId", "${var.prod_redis_cluster_id}" ]
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
          [ "AWS/ElastiCache", "CacheHitRate", "CacheClusterId", "${var.prod_redis_cluster_id}" ]
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
          [ "AWS/ElastiCache", "CurrConnections", "CacheClusterId", "${var.prod_redis_cluster_id}" ]
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
          [ "AWS/ElastiCache", "GetTypeCmds", "CacheClusterId", "${var.prod_redis_cluster_id}" ]
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
          [ "AWS/ElastiCache", "SetTypeCmds", "CacheClusterId", "${var.prod_redis_cluster_id}" ]
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
