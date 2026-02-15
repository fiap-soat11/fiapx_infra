output "db_endpoint" {
  description = "Database endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "database_endpoint" {
  description = "Database endpoint"
  value       = module.database.db_endpoint
}