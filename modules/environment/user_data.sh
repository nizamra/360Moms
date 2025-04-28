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

cat > /etc/environment <<EOF
RDS_ENDPOINT=${rds_endpoint}
REDIS_ENDPOINT=${redis_endpoint}
EOF

# Install MySQL client and Redis tools
apt-get install -y mysql-client redis-tools

# Create connectivity test script
cat > /usr/local/bin/test_connectivity.sh <<'EOF'
#!/bin/bash

echo "=== EC2 Connectivity Test $(date) ===" >> /var/log/application.log

# Test MySQL connectivity
echo "Testing MySQL connectivity to ${rds_endpoint}..." >> /var/log/application.log
if mysqladmin ping -h ${rds_endpoint} -u ${db_username} -p${db_password} &>/dev/null; then
  echo "SUCCESS: MySQL connection established" >> /var/log/application.log
else
  echo "FAILED: Cannot connect to MySQL database" >> /var/log/application.log
fi

# Test Redis connectivity
echo "Testing Redis connectivity to ${redis_endpoint}..." >> /var/log/application.log
if redis-cli -h ${redis_endpoint} ping | grep -q 'PONG'; then
  echo "SUCCESS: Redis connection established" >> /var/log/application.log
else
  echo "FAILED: Cannot connect to Redis" >> /var/log/application.log
fi
EOF

chmod +x /usr/local/bin/test_connectivity.sh

# Run the test on startup
/usr/local/bin/test_connectivity.sh

# Add a cron job to test connectivity every 5 minutes
echo "*/5 * * * * root /usr/local/bin/test_connectivity.sh" > /etc/cron.d/connectivity_test