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
}

module "message_queue" {
  source = "./terraform_modules/message_queue"

  aws_region = var.aws_region

  vpc_id             = module.networking.vpc_info.vpc_id
  private_subnet_ids = module.networking.vpc_info.private_subnets[*].id

  mq_user     = var.mq_user
  mq_password = var.mq_password
}