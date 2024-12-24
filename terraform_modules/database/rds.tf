resource "aws_db_subnet_group" "games_db_subnet_group" {
  name       = "games_db_subnet_group"
  subnet_ids = [var.private_subnet_ids[0], var.private_subnet_ids[1]]

  tags = {
    Name = "Games DB Subnet Group"
  }
}

resource "aws_db_subnet_group" "payments_db_subnet_group" {
  name       = "payments_db_subnet_group"
  subnet_ids = [var.private_subnet_ids[0], var.private_subnet_ids[1]]

  tags = {
    Name = "Payments DB Subnet Group"
  }
}

resource "aws_db_subnet_group" "tickets_db_subnet_group" {
  name       = "tickets_db_subnet_group"
  subnet_ids = [var.private_subnet_ids[0], var.private_subnet_ids[1]]

  tags = {
    Name = "Tickets DB Subnet Group"
  }
}

resource "aws_db_subnet_group" "users_db_subnet_group" {
  name       = "users_db_subnet_group"
  subnet_ids = [var.private_subnet_ids[0], var.private_subnet_ids[1]]

  tags = {
    Name = "Users DB Subnet Group"
  }
}

resource "aws_db_instance" "games_db" {
  db_name              = var.games_db_name
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.games_db_user
  password             = var.games_db_password
  db_subnet_group_name = aws_db_subnet_group.games_db_subnet_group.name
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = false
  identifier           = "games-db"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  monitoring_interval = 60

  tags = {
    Name = "Games MYSQL Database"
  }
}

resource "aws_db_instance" "payments_db" {
  db_name              = var.payments_db_name
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.payments_db_user
  password             = var.payments_db_password
  db_subnet_group_name = aws_db_subnet_group.payments_db_subnet_group.name
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = false
  identifier           = "payments-db"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  monitoring_interval = 60

  tags = {
    Name = "Payments MYSQL Database"
  }
}

resource "aws_db_instance" "tickets_db" {
  db_name              = var.tickets_db_name
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.tickets_db_user
  password             = var.tickets_db_password
  db_subnet_group_name = aws_db_subnet_group.tickets_db_subnet_group.name
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = false
  identifier           = "tickets-db"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  monitoring_interval = 60

  tags = {
    Name = "Tickets MYSQL Database"
  }
}

resource "aws_db_instance" "users_db" {
  db_name              = var.users_db_name
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.users_db_user
  password             = var.users_db_password
  db_subnet_group_name = aws_db_subnet_group.users_db_subnet_group.name
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = false
  identifier           = "users-db"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  monitoring_interval = 60

  tags = {
    Name = "Users MYSQL Database"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security Group for RDS Instances"
  vpc_id      = var.vpc_id

  # allow inbound traffic on port 3306 (mysql) from the private instances
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }
}