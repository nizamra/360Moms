# RDS Module Outputs
# This file defines all output values that are exported from the RDS module

#----------------------Database Resource Identifiers----------------------#
# Unique resource ID of the RDS instance
output "db_resource_id" {
  value       = aws_db_instance.rds.resource_id
  description = "The unique resource ID assigned to the RDS instance" # Used for IAM policy conditions
}

# Identifier of the RDS instance
output "db_identifier" {
  value       = aws_db_instance.rds.identifier
  description = "The identifier of the RDS instance" # Used for referencing the database
}

#----------------------Connection Information----------------------#
# Endpoint for connecting to the database
output "db_endpoint" {
  value       = aws_db_instance.rds.endpoint
  description = "The connection endpoint for the RDS instance" # Contains hostname and port
}
