resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  iam_instance_profile   = var.ec2_role_name
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "${var.prefix}-ec2"
  }
}

output "ec2_instance_id" {
  value = aws_instance.ec2.id
}

output "ec2_private_ip" {
  value = aws_instance.ec2.private_ip
} 
