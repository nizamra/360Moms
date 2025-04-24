#!/bin/bash
apt-get update -y
apt-get install -y docker.io nginx

# Install and configure CloudWatch agent
apt-get install -y amazon-cloudwatch-agent

# Configure CloudWatch agent
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'CWAGENTCONFIG'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/nginx/error.log",
            "log_group_name": "/aws/ec2/${prefix}-nginx",
            "log_stream_name": "{instance_id}-nginx-error"
          },
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "/aws/ec2/${prefix}-nginx",
            "log_stream_name": "{instance_id}-nginx-access"
          },
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "/aws/ec2/${prefix}-system",
            "log_stream_name": "{instance_id}-syslog"
          },
          {
            "file_path": "/var/log/application.log",
            "log_group_name": "/aws/ec2/${prefix}-application",
            "log_stream_name": "{instance_id}-application"
          }
        ]
      }
    }
  },
  "metrics": {
    "metrics_collected": {
      "cpu": {
        "resources": [
          "*"
        ],
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "totalcpu": true
      },
      "mem": {
        "measurement": [
          "mem_used_percent",
          "mem_available_percent"
        ]
      },
      "disk": {
        "resources": [
          "/"
        ],
        "measurement": [
          "disk_used_percent",
          "disk_available"
        ]
      }
    },
    "append_dimensions": {
      "InstanceId": "$${aws:InstanceId}"
    }
  }
}
CWAGENTCONFIG

# Start CloudWatch agent
systemctl start amazon-cloudwatch-agent
systemctl enable amazon-cloudwatch-agent

# Start Docker and Nginx
systemctl start docker
systemctl enable docker
systemctl start nginx
systemctl enable nginx

# Create a sample application log file
touch /var/log/application.log
chmod 644 /var/log/application.log 