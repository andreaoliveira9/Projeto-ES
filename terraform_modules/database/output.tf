output "games_db_connection_string" {
  value = "mysql+pymysql://${var.games_db_user}:${var.games_db_password}@${aws_db_instance.games_db.address}:3306/${var.games_db_name}"
  description = "Connection string for Games DB"
}

output "payments_db_connection_string" {
  value = "mysql+pymysql://${var.payments_db_user}:${var.payments_db_password}@${aws_db_instance.payments_db.address}:3306/${var.payments_db_name}"
  description = "Connection string for Payments DB"
}

output "tickets_db_connection_string" {
  value = "mysql+pymysql://${var.tickets_db_user}:${var.tickets_db_password}@${aws_db_instance.tickets_db.address}:3306/${var.tickets_db_name}"
  description = "Connection string for Tickets DB"
}

output "users_db_connection_string" {
  value = "mysql+pymysql://${var.users_db_user}:${var.users_db_password}@${aws_db_instance.users_db.address}:3306/${var.users_db_name}"
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