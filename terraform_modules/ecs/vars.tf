# vpc
variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "instances_sg_id" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}
# auto scaling group
variable "ecs_asg_arn" {
  type = string
}

# target groups
variable "user_ui_tg_arn" {
  type = string
}

variable "games_api_tg_arn" {
  type = string
}

variable "users_api_tg_arn" {
  type = string
}

variable "tickets_api_tg_arn" {
  type = string
}

variable "payments_api_tg_arn" {
  type = string
}

# repos
variable "user_ui_image_repo" {
  type = string
}

variable "user_ui_image_tag" {
  type = string
}

variable "games_api_image_repo" {
  type = string
}

variable "games_api_image_tag" {
  type = string
}

variable "users_api_image_repo" {
  type = string
}

variable "users_api_image_tag" {
  type = string
}

variable "tickets_api_image_repo" {
  type = string
}

variable "tickets_api_image_tag" {
  type = string
}

variable "payments_api_image_repo" {
  type = string
}

variable "payments_api_image_tag" {
  type = string
}

variable "emails_image_repo" {
  type = string
}

variable "emails_image_tag" {
  type = string
}

# databases
variable "users_db_connection_string" {
  type = string
}

variable "games_db_connection_string" {
  type = string
}

variable "tickets_db_connection_string" {
  type = string
}

variable "payments_db_connection_string" {
  type = string
}

# env var apis
variable "s3_bucket_name" {
  type = string
}

variable "boto3_access_key" {
  type = string
}

variable "boto3_secret_key" {
  type = string
}

# env var ui
