# Variables Configuration File
# This file defines all the variables used across the Terraform configuration
# Variables are organized into logical sections for better maintainability

#----------------------GENERAL----------------------#
# Core configuration variables that apply to the entire infrastructure
variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "github_repo" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "creator_name" {
  description = "The name of the creator"
  type        = string
}

#----------------------STAGING----------------------#
# Variables specific to the staging environment and instance configurations
variable "ami_id" {
  description = "AMI to use for the EC2 instance (must support your OS)."
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "db_storage_type" {
  description = "the type of storage for the RDS instance."
  type        = string
}

variable "db_password" {
  description = "Password for the RDS instance."
  type        = string
  sensitive   = true # Ensures the password is never shown in logs or output
}

variable "redis_node_type" {
  description = "ElastiCache Redis node type."
  type        = string
}

#----------------------NETWORK----------------------#
# Network configuration variables for VPC and subnet setup
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
}

#----------------------DATABASE----------------------#
# Database engine and configuration variables
variable "db_engine" {
  description = "Database engine for the RDS instance (e.g., mysql, postgres)."
  type        = string
}

#----------------------CLOUDWATCH----------------------#
# Monitoring and alerting configuration variables
variable "group_paths" {
  description = "Paths to the log groups to monitor"
  type        = map(string)
}

variable "retention_in_days" {
  description = "Number of days to retain logs"
  type        = number
}

variable "alarm_namespace" {
  description = "Namespace for CloudWatch alarms"
  type        = map(string)
}

variable "alarm_metric" {
  description = "Metrics for CloudWatch alarms"
  type        = map(string)
}

variable "alarm_threshold" {
  description = "Thresholds for CloudWatch alarms"
  type        = map(any) # Flexible type to support different threshold formats
}

variable "alarm_dim" {
  description = "Dimensions for CloudWatch alarms"
  type        = map(string)
}

variable "alarm_attr" {
  description = "Attributes for CloudWatch alarms"
  type        = map(string)
}

variable "alarm_common_settings" {
  description = "Common settings for CloudWatch alarms"
  type        = map(any) # Flexible type to support various settings
}

variable "alarm_alert_email" {
  description = "Email address for CloudWatch alerts"
  type        = string
}

#----------------------ENVIRONMENT SPECIFIC----------------------#
# Variables that differ between staging and production environments

# EC2 Instance Types
variable "stage_instance_type" {
  description = "EC2 instance type for staging environment"
  type        = string
}

variable "prod_instance_type" {
  description = "EC2 instance type for production environment"
  type        = string
}

# Database Storage Configuration
variable "stage_db_storage" {
  description = "Database storage for staging environment"
  type        = string
}

variable "prod_db_storage" {
  description = "Database storage for production environment"
  type        = string
}

variable "stage_max_db_storage" {
  description = "Maximum database storage for staging environment"
  type        = string
}

variable "prod_max_db_storage" {
  description = "Maximum database storage for production environment"
  type        = string
}

# Database Access Configuration
variable "stage_db_username" {
  description = "Database username for staging environment"
  type        = string
}

variable "prod_db_username" {
  description = "Database username for production environment"
  type        = string
}

# IAM Authentication Settings
variable "stage_iam_authentication" {
  description = "IAM authentication for staging environment"
  type        = string
}

variable "prod_iam_authentication" {
  description = "IAM authentication for production environment"
  type        = string
}

# Cache Configuration
variable "num_cache_nodes" {
  description = "Number of cache nodes in the cluster"
  type        = number
}
