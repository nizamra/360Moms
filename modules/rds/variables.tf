# RDS Module Variables
# This file defines all input variables required for the RDS module configuration

#----------------------Resource Naming----------------------#
# Prefix used for naming RDS resources
variable "name_prefix" {
  description = "Prefix for resources"
  type        = string # Example: "prod" or "staging"
}

#----------------------Database Engine Configuration----------------------#
# Database engine specifications
variable "db_engine" {
  description = "The database engine type"
  type        = string # Example: "mysql" or "postgres"
}

variable "db_instance_class" {
  description = "The database instance class"
  type        = string # Example: "db.t3.micro" or "db.r5.large"
}

#----------------------Storage Configuration----------------------#
# Storage allocation and type settings
variable "db_storage" {
  description = "The allocated database storage in GB"
  type        = number # Initial storage size in gigabytes
}

variable "db_storage_type" {
  description = "The storage type for the database (e.g., gp2, io1)"
  type        = string # Determines IOPS and performance characteristics
}

variable "max_db_storage" {
  description = "The maximum storage limit for autoscaling"
  type        = number # Maximum storage size in gigabytes
}

#----------------------Authentication Configuration----------------------#
# Database access credentials
variable "db_username" {
  description = "The database admin username"
  type        = string # Master username for database access
}

variable "db_password" {
  description = "The database admin password"
  type        = string # Master password for database access
  # Note: This should be handled securely, preferably using AWS Secrets Manager
}

#----------------------Network Configuration----------------------#
# Network security and placement settings
variable "db_security_group_id" {
  description = "The ID of the security group for RDS"
  type        = string # Controls network access to the database
}

variable "db_subnet_group_name" {
  description = "The name of the RDS subnet group"
  type        = string # Determines subnet placement of the database
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string) # Subnets where RDS can be deployed
}

#----------------------Security Configuration----------------------#
# Additional security features
variable "iam_authentication" {
  description = "Enable IAM authentication for RDS"
  type        = bool # When true, enables IAM database authentication
}
