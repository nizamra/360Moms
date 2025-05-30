# RDS Module Configuration
# This file defines the Amazon RDS instance configuration for the application's database

# Primary RDS Instance
# Creates a managed relational database instance with high availability
resource "aws_db_instance" "rds" {
  # Basic Instance Configuration
  identifier     = "${var.name_prefix}-rds" # Unique identifier for the RDS instance
  engine         = var.db_engine            # Database engine type (e.g., mysql, postgres)
  instance_class = var.db_instance_class    # Instance type determining compute and memory capacity

  # Storage Configuration
  allocated_storage     = var.db_storage      # Initial storage allocation in GB
  storage_type          = var.db_storage_type # Storage type (e.g., gp2, io1)
  max_allocated_storage = var.max_db_storage  # Maximum storage limit for autoscaling

  # Authentication and Access
  username                            = var.db_username        # Master username for database access
  password                            = var.db_password        # Master password for database access
  iam_database_authentication_enabled = var.iam_authentication # Enable IAM database authentication

  # Network Configuration
  db_subnet_group_name   = var.db_subnet_group_name   # Subnet group for database placement
  vpc_security_group_ids = [var.db_security_group_id] # Security group controlling access

  # High Availability and Backup
  multi_az            = true # Enable Multi-AZ deployment for high availability
  skip_final_snapshot = true # Skip final snapshot when destroying the instance

  # Resource Tags
  tags = {
    Name = "${var.name_prefix}-rds" # Resource name tag
  }
}
