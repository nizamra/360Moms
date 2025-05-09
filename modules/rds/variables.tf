variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "db_engine" {
  description = "Database engine type"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_storage" {
  description = "Initial storage size in GB"
  type        = number
}

variable "db_storage_type" {
  description = "Storage type for RDS"
  type        = string
}

variable "max_db_storage" {
  description = "Maximum storage size in GB"
  type        = number
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "rds_security_group_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
} 
