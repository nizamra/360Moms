data "aws_caller_identity" "current" {}

# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name                  = "${var.name_prefix}-ec2-role"
  force_detach_policies = true

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

  tags = {
    Name = "${var.name_prefix}-ec2-role"
  }
}

# Attach the CloudWatch Agent policy to the role
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach the SSM policy to the role
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "rds_connect" {
  name = "${var.name_prefix}-rds-connect"

  policy = templatefile("${path.module}/rds_connect_policy.json", {
    region         = var.aws_region,
    account_id     = data.aws_caller_identity.current.account_id,
    db_resource_id = var.db_resource_id,
    db_username    = var.db_username,
  })
}

resource "aws_iam_role_policy_attachment" "rds_connect_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.rds_connect.arn
}


# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
