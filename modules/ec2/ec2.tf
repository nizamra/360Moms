# Launch Template for EC2 instances
resource "aws_launch_template" "app" {
  name_prefix            = "${var.prefix}-launch-template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(templatefile("${path.module}/user_data.tmpl", {
    log_group_prefix = var.prefix,
    db_user          = var.db_username,
    db_port          = 3306
    region           = var.aws_region
  }))
}

# Auto Scaling Group to maintain two instances
resource "aws_autoscaling_group" "app" {
  name                      = "${var.prefix}-asg"
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [var.target_group_arn]
  desired_capacity          = var.autoscaling_desired_capacity
  max_size                  = var.autoscaling_max_size
  min_size                  = var.autoscaling_min_size
  health_check_type         = var.autoscaling_health_check_type
  health_check_grace_period = var.autoscaling_health_check_grace_period

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
