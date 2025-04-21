# EC2 Instance with Docker and Nginx
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
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
                "log_group_name": "/aws/ec2/${var.prefix}-nginx",
                "log_stream_name": "{instance_id}-nginx-error"
              },
              {
                "file_path": "/var/log/nginx/access.log",
                "log_group_name": "/aws/ec2/${var.prefix}-nginx",
                "log_stream_name": "{instance_id}-nginx-access"
              },
              {
                "file_path": "/var/log/syslog",
                "log_group_name": "/aws/ec2/${var.prefix}-system",
                "log_stream_name": "{instance_id}-syslog"
              },
              {
                "file_path": "/var/log/application.log",
                "log_group_name": "/aws/ec2/${var.prefix}-application",
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
  EOF

  tags = {
    Name = "${var.prefix}-ec2-app"
  }
}

# IAM Role for EC2 CloudWatch access
resource "aws_iam_role" "ec2_role" {
  name = "${var.prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the CloudWatch Agent policy to the role
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Create an instance profile for the EC2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.prefix}-ec2-profile"
  role = aws_iam_role.ec2_role.name
  tags = {}
}
