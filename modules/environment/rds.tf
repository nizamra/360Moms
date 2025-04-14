# RDS Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.environment}-rds-subnet-group"
  }
}

# RDS Database Instance
resource "aws_db_instance" "this" {
  identifier              = "${var.environment}-rds"
  engine                  = var.db_engine
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_storage
  storage_type            = "gp2"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.ec2.id]
  db_subnet_group_name    = aws_db_subnet_group.this.name

  tags = {
    Name = "${var.environment}-rds"
  }
}