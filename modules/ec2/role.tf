# IAM Role Configuration
# This file defines the IAM roles and policies for the EC2 instance

#----------------------Account Information----------------------#
# Get current AWS account information for policy creation
data "aws_caller_identity" "current" {}

#----------------------EC2 IAM Role----------------------#
# Primary IAM role that will be assigned to the EC2 instance
resource "aws_iam_role" "ec2_role" {
  name                  = "${var.name_prefix}-ec2-role"
  force_detach_policies = true # Ensures clean role deletion

  # Trust policy allowing EC2 service to assume this role
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

  # Resource Tags
  tags = {
    Name = "${var.name_prefix}-ec2-role"
  }
}

#----------------------Policy Attachments----------------------#
# Attach AWS managed CloudWatch Agent policy
# Allows instance to send metrics and logs to CloudWatch
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach AWS Systems Manager policy
# Enables instance management through SSM
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#----------------------Custom RDS Access Policy----------------------#
# Create custom policy for RDS IAM authentication
resource "aws_iam_policy" "rds_connect" {
  name = "${var.name_prefix}-rds-connect"

  # Policy document from template with dynamic values
  policy = templatefile("${path.module}/rds_connect_policy.json", {
    region         = var.aws_region,                              # AWS region for RDS
    account_id     = data.aws_caller_identity.current.account_id, # Current AWS account
    db_resource_id = var.db_resource_id,                          # RDS instance identifier
    db_username    = var.db_username,                             # Database username
  })
}

# Attach RDS connection policy to EC2 role
resource "aws_iam_role_policy_attachment" "rds_connect_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.rds_connect.arn
}

#----------------------Instance Profile----------------------#
# Create instance profile to attach IAM role to EC2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name_prefix}-ec2-profile" # Profile name matching EC2 instance
  role = aws_iam_role.ec2_role.name       # Associate with the EC2 role
}
