# EC2 Instance with Docker and Nginx
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name = "${var.environment}-ec2-app"

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io nginx
    systemctl start docker
    systemctl enable docker
    # (Insert your Nginx configuration commands or file copy commands here)
  EOF

  tags = {
    Name = "${var.environment}-ec2-app"
  }
}