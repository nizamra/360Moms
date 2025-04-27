output "ec2_role_name" {
  value       = aws_iam_role.ec2_role.name
  description = "The name of the EC2 role"
}