# Network Module Variables
# This file defines all input variables required for the network module configuration

#----------------------VPC Configuration Variables----------------------#
# Primary CIDR block for the VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16" # Default CIDR provides 65,536 IP addresses
}

#----------------------Subnet Configuration Variables----------------------#
# Public subnet CIDR blocks
variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string) # Example: ["10.0.1.0/24", "10.0.2.0/24"]
}

# Private subnet CIDR blocks
variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string) # Example: ["10.0.10.0/24", "10.0.11.0/24"]
}

#----------------------Availability Zone Configuration----------------------#
# AWS Availability Zones for high availability
variable "availability_zones" {
  description = "List of AZs to use for the subnets."
  type        = list(string) # Example: ["me-south-1a", "me-south-1b"]
}

#----------------------Resource Naming----------------------#
# Prefix for resource names to ensure uniqueness
variable "name_prefix" {
  description = "Name prefix for the resources."
  type        = string # Used to create unique identifiers for resources
}
