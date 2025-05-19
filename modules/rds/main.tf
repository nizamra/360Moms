resource "aws_db_instance" "rds" {
  identifier             = "${var.prefix}-rds"
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_storage
  storage_type           = var.db_storage_type
  max_allocated_storage  = var.max_db_storage
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = var.rds_subnet_group_name
  vpc_security_group_ids = [var.rds_security_group_id]
  skip_final_snapshot    = true

  tags = {
    Name = "${var.prefix}-rds"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "rds_identifier" {
  value = aws_db_instance.rds.identifier
}
