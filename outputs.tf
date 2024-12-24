output "vpc_info" {
  value = module.networking.vpc_info
}

output "games_db_connection_string" {
  value = module.database.games_db_connection_string
  sensitive = true
}

output "payments_db_connection_string" {
  value = module.database.payments_db_connection_string
  sensitive = true
}

output "tickets_db_connection_string" {
  value = module.database.tickets_db_connection_string
  sensitive = true
}

output "users_db_connection_string" {
  value = module.database.users_db_connection_string
  sensitive = true
}

output "s3_bucket_name" {
  value = module.database.s3_bucket_name
}