#----------------------GENERAL----------------------#
variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
}

variable "alert_email" {
  description = "Email address to send CloudWatch alerts to"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for CloudWatch resources"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

#----------------------staging----------------------#
variable "ec2_instance_id" {
  description = "EC2 instance type for the application server."
  type        = string
}

variable "rds_identifier" {
  description = "RDS instance class."
  type        = string
}

variable "redis_cluster_id" {
  description = "ElastiCache Redis cluster id."
  type        = string
}
