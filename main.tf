terraform {
  cloud {
    organization = "ClubSync"

    workspaces {
      name = "main"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

locals {
  testing_availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
}

module "iam" {
  source = "./terraform_modules/iam"

  public_key = var.public_key
}

module "networking" {
  source               = "./terraform_modules/networking"
  aws_region           = var.aws_region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.testing_availability_zones

}

module "database" {
  source = "./terraform_modules/database"

  vpc_id             = module.networking.vpc_info.vpc_id
  private_subnet_ids = module.networking.vpc_info.private_subnets[*].id

  games_db_user     = var.games_db_user
  games_db_password = var.games_db_password
  games_db_name     = var.games_db_name

  payments_db_user     = var.payments_db_user
  payments_db_password = var.payments_db_password
  payments_db_name     = var.payments_db_name

  tickets_db_user     = var.tickets_db_user
  tickets_db_password = var.tickets_db_password
  tickets_db_name     = var.tickets_db_name

  users_db_user     = var.users_db_user
  users_db_password = var.users_db_password
  users_db_name     = var.users_db_name

  instances_sg_id   = module.ec2.instances_sg_id
}

module "message_queue" {
  source = "./terraform_modules/message_queue"

  aws_region = var.aws_region

  vpc_id             = module.networking.vpc_info.vpc_id
  private_subnet_ids = module.networking.vpc_info.private_subnets[*].id

  mq_user     = var.mq_user
  mq_password = var.mq_password
}

module "ec2" {
  source = "./terraform_modules/ec2"

  vpc_id             = module.networking.vpc_info.vpc_id
  public_subnet_ids  = module.networking.vpc_info.public_subnets[*].id
  private_subnet_ids = module.networking.vpc_info.private_subnets[*].id

  key_name         = module.iam.key_name
  cert_private_key = var.cert_private_key
  cert_body        = var.cert_body

  ecs_instance_profile_name = module.iam.ecs_instance_profile_name
}

module "ecs" {
  source = "./terraform_modules/ecs"

  # infrastructure & security
  aws_region         = var.aws_region
  vpc_id             = module.networking.vpc_info.vpc_id
  public_subnet_ids  = module.networking.vpc_info.public_subnets[*].id
  private_subnet_ids = module.networking.vpc_info.private_subnets[*].id

  ecs_task_execution_role_arn  = module.iam.ecs_task_execution_role_arn
  ecs_asg_arn                  = module.ec2.ecs_asg_arn
  user_ui_tg_arn               = module.ec2.user_ui_tg_arn
  domain = module.ec2.lb_url
  games_api_tg_arn             = module.ec2.games_api_tg_arn
  tickets_api_tg_arn           = module.ec2.tickets_api_tg_arn
  payments_api_tg_arn          = module.ec2.payments_api_tg_arn
  users_api_tg_arn             = module.ec2.users_api_tg_arn
  instances_sg_id              = module.ec2.instances_sg_id

  # docker images
  user_ui_image_repo       = var.user_ui_image_repo
  user_ui_image_tag        = var.user_ui_image_tag
  games_api_image_repo     = var.games_api_image_repo
  games_api_image_tag      = var.games_api_image_tag
  tickets_api_image_repo   = var.tickets_api_image_repo
  tickets_api_image_tag    = var.tickets_api_image_tag
  users_api_image_repo     = var.users_api_image_repo
  users_api_image_tag      = var.users_api_image_tag
  payments_api_image_repo  = var.payments_api_image_repo
  payments_api_image_tag   = var.payments_api_image_tag
  emails_image_repo        = var.emails_image_repo
  emails_image_tag         = var.emails_image_tag
  
  # api env vars
  users_db_connection_string           = module.database.users_db_connection_string
  games_db_connection_string           = module.database.games_db_connection_string
  tickets_db_connection_string         = module.database.tickets_db_connection_string
  payments_db_connection_string        = module.database.payments_db_connection_string
  s3_bucket_name                       = module.database.s3_bucket_name
  boto3_access_key                     = module.database.access_key
  boto3_secret_key                     = module.database.secret_key
  mq_connection_string                 = module.message_queue.mq_connection_string

  # env var email
  service_id                          = var.service_id
  template_id                        = var.template_id
  public_key_email                  = var.public_key_email
  private_key_email                 = var.private_key_email

  # env var ui
  login_sign_up                 = var.login_sign_up

  # env var users
  cognito_user_pool_id              = var.cognito_user_pool_id
  cognito_user_client_id            = var.cognito_user_client_id
  cognito_user_client_secret       = var.cognito_user_client_secret
  cognito_token_endpoint          = var.cognito_token_endpoint

  # env var payments
  stripe_api_key                 = var.stripe_api_key
  stripe_webhook_secret = var.stripe_webhook_secret
  expire_time = var.expire_time
}