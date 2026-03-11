output "queue_url" {
  value = module.sqs.queue_url
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = module.database.db_endpoint
}

output "db_address" {
  description = "Database address"
  value       = module.database.db_address
}

output "db_port" {
  description = "Database port"
  value       = module.database.db_port
}

output "secrets_manager_arn" {
  description = "ARN of the Secrets Manager secret for database credentials"
  value       = module.database.secrets_manager_arn
  sensitive   = true
}