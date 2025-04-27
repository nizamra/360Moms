#----------------------GENERAL----------------------#
variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "me-south-1"
}

variable "environment" {
  description = "Deployment environment name (staging, production)"
  type        = string
  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Invalid environment. Valid values: staging, production"
  }
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

#----------------------staging----------------------#
variable "stag_instance_type" {
  description = "EC2 instance type for the application server."
  type        = string
}

variable "stag_ami_id" {
  description = "AMI to use for the EC2 instance (must support your OS)."
  type        = string
}

variable "stag_db_instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "stag_db_storage" {
  description = "Allocated storage for RDS (in GB)."
  type        = number
}

variable "stag_db_storage_type" {
  description = "the type of storage for the RDS instance."
  type        = string
}

variable "stag_db_username" {
  description = "Username for the RDS instance."
  type        = string
}

variable "stag_max_db_storage" {
  description = "the maximum allocated storage for the RDS instance."
  type        = number
}

variable "stag_db_password" {
  description = "Password for the RDS instance."
  type        = string
  sensitive   = true
}

variable "stag_redis_node_type" {
  description = "ElastiCache Redis node type."
  type        = string
  default     = "cache.t3.micro"
}

#----------------------production----------------------#
variable "prod_instance_type" {
  description = "EC2 instance type for the application server."
  type        = string
  default     = "t2.micro"
}

variable "prod_ami_id" {
  description = "AMI to use for the EC2 instance (must support your OS)."
  type        = string
}

variable "prod_db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "prod_db_storage" {
  description = "Allocated storage for RDS (in GB)."
  type        = number
  default     = 20
}

variable "prod_db_storage_type" {
  description = "the type of storage for the RDS instance."
  type        = string
}

variable "prod_max_db_storage" {
  description = "the maximum allocated storage for the RDS instance."
  type        = number
}

variable "prod_db_username" {
  description = "Username for the RDS instance."
  type        = string
}

variable "prod_db_password" {
  description = "Password for the RDS instance."
  type        = string
  sensitive   = true
}

variable "prod_redis_node_type" {
  description = "ElastiCache Redis node type."
  type        = string
  default     = "cache.t3.micro"
}

#----------------------NETWORK----------------------#
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "List of AZs to use for the subnets."
  type        = list(string)
}

#----------------------DATABASE----------------------#
variable "db_engine" {
  description = "Database engine for the RDS instance (e.g., mysql, postgres)."
  type        = string
  default     = "mysql"
}

variable "db_parameter_group" {
  description = "Parameter group for the RDS instance."
  type        = string
  default     = "default.mysql8.0"
}
