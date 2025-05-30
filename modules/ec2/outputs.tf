# outputs.tf (updated)
output "ec2_instance_id" {
  value       = aws_instance.ec2.id
  description = "The ID of the EC2 instance"
}

output "ec2_private_ip" {
  value       = aws_instance.ec2.private_ip
  description = "The private IP of the EC2 instance"
}

output "ec2_role_name" {
  value       = aws_iam_role.ec2_role.name
  description = "The name of the EC2 role"
}
