resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(templatefile("${path.module}/user_data.tmpl", {
    log_group_prefix = var.name_prefix,
    db_user          = var.db_username,
    db_port          = 3306,
    region           = var.aws_region
  }))

  tags = {
    Name = "${var.name_prefix}-ec2"
  }
}
