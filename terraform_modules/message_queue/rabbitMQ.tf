resource "aws_mq_broker" "mq" {
  broker_name                = "mq"
  engine_type                = "RabbitMQ"
  engine_version             = "3.13"
  host_instance_type         = "mq.m5.large"
  security_groups            = [aws_security_group.mq_sg.id]
  deployment_mode            = "CLUSTER_MULTI_AZ"
  subnet_ids                 = var.private_subnet_ids
  publicly_accessible        = false
  auto_minor_version_upgrade = true

  user {
    username = var.mq_user
    password = var.mq_password
  }
}

resource "aws_security_group" "mq_sg" {
  name        = "mq_sg"
  description = "Security Group for MQ Instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5671
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}