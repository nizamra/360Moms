# EC2 Instance with Docker and Nginx
resource "aws_instance" "app" {
  ami                    = "ami-02f2b27f6f5f3a231" # Ubuntu 22.04 LTS (me-south-1)
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("${path.module}/user_data.sh", {
    prefix = var.prefix
  })

  tags = {
    Name = "${var.prefix}-ec2-app"
  }
}

# IAM Role for EC2 CloudWatch access
resource "aws_iam_role" "ec2_role" {
  name                  = "${var.prefix}-ec2-role"
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
