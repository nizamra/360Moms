#----------------------GENERAL----------------------#
variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "me-south-1"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
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
variable "instance_type" {
  description = "EC2 instance type for the application server."
  type        = string
}

variable "ami_id" {
  description = "AMI to use for the EC2 instance (must support your OS)."
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "db_storage" {
  description = "Allocated storage for RDS (in GB)."
  type        = number
}

variable "db_storage_type" {
  description = "the type of storage for the RDS instance."
  type        = string
}

variable "db_username" {
  description = "Username for the RDS instance."
  type        = string
}

variable "max_db_storage" {
  description = "the maximum allocated storage for the RDS instance."
  type        = number
}

variable "db_password" {
  description = "Password for the RDS instance."
  type        = string
  sensitive   = true
}

variable "redis_node_type" {
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

#----------------------AUTOSCALING----------------------#
variable "autoscaling_desired_capacity" {
  description = "The desired capacity for the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "autoscaling_max_size" {
  description = "The maximum size of the Auto Scaling Group"
  type        = number
  default     = 4
}

variable "autoscaling_min_size" {
  description = "The minimum size of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "autoscaling_health_check_type" {
  description = "The health check type for the Auto Scaling Group (EC2 or ELB)"
  type        = string
  default     = "ELB"
}

variable "autoscaling_health_check_grace_period" {
  description = "The grace period (in seconds) for health checks"
  type        = number
  default     = 300
}

#----------------------IAM----------------------#
variable "iam_authentication" {
  description = "Enable IAM authentication for RDS"
  type        = bool
}

#----------------------REDIS----------------------#
variable "redis_cache_clusters" {
  description = "The number of cache clusters for Redis"
  type        = number
}


