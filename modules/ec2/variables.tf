# EC2 Module Variables
# This file defines all input variables required for the EC2 module configuration

#----------------------General Configuration----------------------#
# AWS region for resource deployment
variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string # Example: "me-south-1"
}

# Resource naming prefix
variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string # Used to create unique identifiers for resources
}

#----------------------Instance Configuration----------------------#
# EC2 instance specifications
variable "instance_type" {
  description = "EC2 instance type"
  type        = string # Example: "t3.micro", "t3.small"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string # Amazon Machine Image ID for the instance OS
}

#----------------------Network Configuration----------------------#
# Network placement and security
variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string) # Subnets where EC2 can be deployed
}

variable "security_group_id" {
  description = "Security group ID for EC2 instance"
  type        = string # Controls inbound/outbound traffic rules
}
