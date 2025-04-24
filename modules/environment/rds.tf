# RDS Subnet Group
resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.prefix}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.prefix}-rds-subnet-group"
  }
}

# RDS Database Instance
resource "aws_db_instance" "db_instance" {
  identifier             = "${var.prefix}-rds"
  engine                 = var.db_engine
  engine_version         = "8.0.35"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_storage
  storage_type           = var.db_storage_type
  max_allocated_storage  = var.max_db_storage
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name

  tags = {
    Name = "${var.prefix}-rds"
  }
}
