# Launch Template for EC2 instances
resource "aws_launch_template" "app" {
  name_prefix            = "${var.prefix}-template-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    prefix         = var.prefix
    rds_endpoint   = var.rds_endpoint
    redis_endpoint = var.redis_endpoint
    db_username    = var.db_username
    db_password    = var.db_password
  }))
}

# Auto Scaling Group to maintain two instances
resource "aws_autoscaling_group" "app" {
  name                = "${var.prefix}-asg"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 2
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-ec2-app"
    propagate_at_launch = true
  }
}
