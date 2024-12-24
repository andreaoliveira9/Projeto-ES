
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The IDs of the private subnets"
}

variable "games_db_password" {
  type        = string
  description = "Password for the Games Database"
  sensitive   = true
}

variable "games_db_user" {
  type        = string
  description = "Username for the Games Database"
  sensitive   = true
}

variable "games_db_name" {
  type        = string
  description = "Name for the Games Database"
}

variable "payments_db_password" {
  type        = string
  description = "Password for the Games Database"
  sensitive   = true
}

variable "payments_db_user" {
  type        = string
  description = "Username for the Games Database"
  sensitive   = true
}

variable "payments_db_name" {
  type        = string
  description = "Name for the Games Database"
}

variable "tickets_db_password" {
  type        = string
  description = "Password for the Tickets Database"
  sensitive   = true
}

variable "tickets_db_user" {
  type        = string
  description = "Username for the Tickets Database"
  sensitive   = true
}

variable "tickets_db_name" {
  type        = string
  description = "Name for the Tickets Database"
}

variable "users_db_password" {
  type        = string
  description = "Password for the Users Database"
  sensitive   = true
}

variable "users_db_user" {
  type        = string
  description = "Username for the Users Database"
  sensitive   = true
}

variable "users_db_name" {
  type        = string
  description = "Name for the Users Database"
}