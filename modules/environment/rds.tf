# TODO: Add SSM Parameter for DB Password
# resource "aws_ssm_parameter" "db_password" {
#   name  = "/${var.prefix}/db_password"
#   type  = "SecureString"
#   value = var.db_password
# }

# # Use AWS Secrets Manager instead:
# resource "aws_secretsmanager_secret" "db_password" {
#   name = "${var.prefix}/db_password"
# }

# resource "aws_secretsmanager_secret_version" "db_password" {
#   secret_id     = aws_secretsmanager_secret.db_password.id
#   secret_string = random_password.db.result
# }

# RDS Subnet Group
resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.prefix}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.prefix}-rds-subnet-group"
  }
}

resource "aws_db_parameter_group" "mysql" {
  name   = "${var.prefix}-mysql80-params"
  family = "mysql8.0"

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  tags = {
    Name = "${var.prefix}-mysql-params"
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
  vpc_security_group_ids = [var.rds_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  parameter_group_name   = aws_db_parameter_group.mysql.name
  # TODO: Add KMS Key for RDS
  # storage_encrypted      = true
  # kms_key_id             = aws_kms_key.rds_key.arn

  tags = {
    Name = "${var.prefix}-rds"
  }
}