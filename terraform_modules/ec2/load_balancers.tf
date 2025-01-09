resource "aws_security_group" "lb" {
  name        = "lb-sg"
  description = "Allow HTTP access instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_acm_certificate" "imported_cert" {
  private_key      = var.cert_private_key
  certificate_body = var.cert_body

  tags = {
    Name = "ImportedCertificate"
  }
}

resource "aws_lb" "lb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  certificate_arn = aws_acm_certificate.imported_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ui_tg.arn
  }
}

resource "aws_lb_listener_rule" "games_rule_https" {
  listener_arn = aws_lb_listener.listener_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.games_tg.arn
  }

  condition {
    path_pattern {
      values = ["/games/*"]
    }
  }
}

resource "aws_lb_listener_rule" "payments_rule_https" {
  listener_arn = aws_lb_listener.listener_https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.payments_tg.arn
  }

  condition {
    path_pattern {
      values = ["/payments/*"]
    }
  }
}

resource "aws_lb_listener_rule" "tickets_rule_https" {
  listener_arn = aws_lb_listener.listener_https.arn
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tickets_tg.arn
  }

  condition {
    path_pattern {
      values = ["/tickets/*"]
    }
  }
}

resource "aws_lb_listener_rule" "users_rule_https" {
  listener_arn = aws_lb_listener.listener_https.arn
  priority     = 400

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users_tg.arn
  }

  condition {
    path_pattern {
      values = ["/users/*"]
    }
  }
}

resource "aws_lb_target_group" "games_tg" {
  name        = "games-target-group"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/games/v1/health"
    matcher  = "200"
    interval = 30
    timeout  = 5
  }
}

resource "aws_lb_target_group" "payments_tg" {
  name        = "payments-target-group"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/payments/v1/health"
    matcher  = "200"
    interval = 30
    timeout  = 5
  }
}

resource "aws_lb_target_group" "tickets_tg" {
  name        = "tickets-target-group"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/tickets/v1/health"
    matcher  = "200"
    interval = 30
    timeout  = 5
  }
}

resource "aws_lb_target_group" "users_tg" {
  name        = "users-target-group"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/users/v1/health"
    matcher  = "200"
    interval = 30
    timeout  = 5
  }
}

resource "aws_lb_target_group" "ui_tg" {
  name        = "ui-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
  }
}