# EC2 Module Configuration
# This file defines the Amazon EC2 instance configuration for the application server

# Primary EC2 Instance
# Creates a virtual machine instance to run the application
resource "aws_instance" "ec2" {
  # Basic Instance Configuration
  ami           = var.ami_id        # Amazon Machine Image ID defining the base OS
  instance_type = var.instance_type # Instance size determining compute resources

  # Network Configuration
  subnet_id              = var.private_subnet_ids[0] # Place instance in first private subnet
  vpc_security_group_ids = [var.security_group_id]   # Security group controlling network access

  # IAM Configuration
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # IAM role for EC2 permissions

  # Instance Initialization
  # Base64 encoded user data script for instance setup
  user_data = base64encode(templatefile("${path.module}/user_data.tmpl", {
    log_group_prefix = var.name_prefix, # Prefix for CloudWatch log groups
    db_user          = var.db_username, # Database username for connection
    db_port          = 3306,            # MySQL default port
    region           = var.aws_region   # AWS region for resource access
  }))

  # Resource Tags
  tags = {
    Name = "${var.name_prefix}-ec2" # Instance name tag
  }
}
