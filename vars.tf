variable "public_key" {
  type        = string
  description = "The value of the public key"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "eu-west-3"
}

variable "environment" {
  description = "Deployment Environment"
  default     = "testing"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
  default     = ["10.0.1.0/27", "10.0.1.32/27"]
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "games_db_user" {
  type        = string
  description = "The username for the games database"
  default = "games_db_user"
}

variable "games_db_password" {
  type        = string
  description = "The password for the games database"
  default = "games_db_password"
}

variable "games_db_name" {
  type        = string
  description = "The name for the games database"
  default     = "games_db"
}

variable "payments_db_user" {
  type        = string
  description = "The username for the payments database"
  default = "payments_db_user"
}

variable "payments_db_password" {
  type        = string
  description = "The password for the payments database"
  default = "payments_db_password"
}

variable "payments_db_name" {
  type        = string
  description = "The name for the payments database"
  default     = "payments_db"
}

variable "tickets_db_user" {
  type        = string
  description = "The username for the tickets database"
  default = "tickets_db_user"
}

variable "tickets_db_password" {
  type        = string
  description = "The password for the tickets database"
  default = "tickets_db_password"
}

variable "tickets_db_name" {
  type        = string
  description = "The name for the tickets database"
  default     = "tickets_db"
}

variable "users_db_user" {
  type        = string
  description = "The username for the users database"
  default = "users_db_user"
}

variable "users_db_password" {
  type        = string
  description = "The password for the users database"
  default = "users_db_password"
}

variable "users_db_name" {
  type        = string
  description = "The name for the users database"
  default     = "users_db"
}

variable "mq_user" {
  type        = string
  description = "The username for the message queue"
  default = "mq_user"
}

variable "mq_password" {
  type        = string
  description = "The password for the message queue"
  default = "mq_password12"
}

variable "cert_body" {
  description = "The body of the SSL certificate in PEM format"
  type        = string
  sensitive   = true
}

variable "cert_private_key" {
  description = "The private key of the SSL certificate in PEM format"
  type        = string
  sensitive   = true
}

variable "user_ui_image_repo" {
  type        = string
  description = "The image for the user-ui container"
  default     = "509399594636.dkr.ecr.eu-west-3.amazonaws.com/clubsync/web-ui"
}

variable "user_ui_image_tag" {
  type = string
  default = "latest"
}

variable "games_api_image_repo" {
  type        = string
  description = "The image for the games-api container"
  default     = "509399594636.dkr.ecr.eu-west-3.amazonaws.com/clubsync/game-microservice"
}

variable "games_api_image_tag" {
  type = string
  default = "latest"
}

variable "tickets_api_image_repo" {
  type        = string
  description = "The image for the tickets-api container"
  default     = "509399594636.dkr.ecr.eu-west-3.amazonaws.com/clubsync/ticket-microservice"
}

variable "tickets_api_image_tag" {
  type = string
  default = "latest"
}

variable "users_api_image_repo" {
  type        = string
  description = "The image for the users-api container"
  default     = "509399594636.dkr.ecr.eu-west-3.amazonaws.com/clubsync/user-microservice"
}

variable "users_api_image_tag" {
  type = string
  default = "latest"
}

variable "payments_api_image_repo" {
  type        = string
  description = "The image for the payments-api container"
  default     = "509399594636.dkr.ecr.eu-west-3.amazonaws.com/clubsync/payments-microservice"
}

variable "payments_api_image_tag" {
  type = string
  default = "latest"
}

variable "emails_image_repo" {
  type        = string
  description = "The image for the user-ui container"
  default     = "509399594636.dkr.ecr.eu-west-3.amazonaws.com/clubsync/email-microservice"
}

variable "emails_image_tag" {
  type = string
  default = "latest"
}

# Email service variables
variable "service_id" {
  type        = string
  description = "The service id for the email service"
  default     = "service_id"
}

variable "template_id" {
  type        = string
  description = "The template id for the email service"
  default     = "template_id"
}

variable "public_key_email" {
  type        = string
  description = "The value of the public key"
}

variable "private_key_email" {
  type        = string
  description = "The value of the private key"
}

# UI service variables
variable "login_sign_up" {
  type        = string
  description = "The value of the login sign up url"
}

# Users service variables
variable "cognito_user_pool_id" {
  type        = string
  description = "The value of the cognito user pool id"
}

variable "cognito_user_client_id" {
  type        = string
  description = "The value of the cognito user client id"
}

variable "cognito_user_client_secret" {
  type        = string
  description = "The value of the cognito user client secret"
}

variable "cognito_token_endpoint" {
  type        = string
  description = "The value of the cognito token endpoint"
}

# Payments service variables
variable "stripe_api_key" {
  type        = string
  description = "The value of the stripe api key"
}

variable "stripe_webhook_secret" {
  type        = string
  description = "The value of the stripe webhook secret"
}

variable "expire_time" {
  type        = string
  description = "The value of the expire time"
}