resource "aws_db_instance" "rds" {
  identifier                          = "${var.name_prefix}-rds"
  engine                              = var.db_engine
  instance_class                      = var.db_instance_class
  allocated_storage                   = var.db_storage
  storage_type                        = var.db_storage_type
  max_allocated_storage               = var.max_db_storage
  username                            = var.db_username
  password                            = var.db_password
  db_subnet_group_name                = var.db_subnet_group_name
  vpc_security_group_ids              = [var.db_security_group_id]
  skip_final_snapshot                 = false
  backup_retention_period             = 7
  multi_az                            = true
  iam_database_authentication_enabled = var.iam_authentication

  tags = {
    Name = "${var.name_prefix}-rds"
  }
}
