variable "aws_region" {
  type        = string
  description = "The AWS region"
  
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The IDs of the private subnets"
}

variable "mq_user" {
  type        = string
  description = "The username for the RabbitMQ broker"
}

variable "mq_password" {
  type        = string
  description = "The password for the RabbitMQ broker"
}

variable "instances_sg_id" {
  type = string
}