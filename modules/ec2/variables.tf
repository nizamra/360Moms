#----------------------GENERAL----------------------#
variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for EC2 instance"
  type        = string
}

variable "db_endpoint" {
  description = "RDS instance endpoint"
  type        = string
}

variable "redis_endpoint" {
  description = "Redis cluster endpoint"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_resource_id" {
  description = "Database resource ID"
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}
