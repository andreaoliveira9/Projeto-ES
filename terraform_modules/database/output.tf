output "games_db_connection_string" {
  value = "mysql+mysqlconnector://${var.games_db_user}:${var.games_db_password}@${aws_db_instance.games_db.address}/${var.games_db_name}"
  description = "Connection string for Games DB"
}

output "payments_db_connection_string" {
  value = "mysql+mysqlconnector://${var.payments_db_user}:${var.payments_db_password}@${aws_db_instance.payments_db.address}/${var.payments_db_name}"
  description = "Connection string for Payments DB"
}

output "tickets_db_connection_string" {
  value = "mysql+mysqlconnector://${var.tickets_db_user}:${var.tickets_db_password}@${aws_db_instance.tickets_db.address}/${var.tickets_db_name}"
  description = "Connection string for Tickets DB"
}

output "users_db_connection_string" {
  value = "mysql+mysqlconnector://${var.users_db_user}:${var.users_db_password}@${aws_db_instance.users_db.address}/${var.users_db_name}"
  description = "Connection string for Users DB"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.image_bucket.bucket
  description = "Name of the S3 bucket for images"
}

output "access_key" {
  value = aws_iam_access_key.boto3_user_key.id
}

output "secret_key" {
  value = aws_iam_access_key.boto3_user_key.secret
}