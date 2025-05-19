output "db_resource_id" {
  value = aws_db_instance.rds.resource_id
}

output "db_identifier" {
  value = aws_db_instance.rds.identifier
}

output "db_endpoint" {
  value = aws_db_instance.rds.endpoint
}
