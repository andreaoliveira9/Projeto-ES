resource "aws_security_group" "ui_lb" {
  name        = "ui-lb-sg"
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

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.ui_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  certificate_arn = aws_acm_certificate.imported_cert.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found."
      status_code  = "404"
    }
  }
}

resource "aws_lb" "ui_lb" {
  name               = "ui-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ui_lb.id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener_rule" "ui_rule_https" {
  listener_arn = aws_lb_listener.listener_https.arn
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ui_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_target_group" "ui_tg" {
  name        = "ui-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.apis_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found."
      status_code  = "404"
    }
  }
}

resource "aws_security_group" "apis_lb" {
  name        = "api-lb-sg"
  description = "Allow HTTP access instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_lb" "apis_lb" {
  name               = "apis-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.apis_lb.id]
  subnets            = var.private_subnet_ids
}

resource "aws_lb_listener_rule" "games_rule_http" {
  listener_arn = aws_lb_listener.listener_http.arn
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

resource "aws_lb_listener_rule" "payments_rule_http" {
  listener_arn = aws_lb_listener.listener_http.arn
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

resource "aws_lb_listener_rule" "tickets_rule_http" {
  listener_arn = aws_lb_listener.listener_http.arn
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

resource "aws_lb_listener_rule" "users_rule_http" {
  listener_arn = aws_lb_listener.listener_http.arn
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
    path     = "/games/v1"
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
    path     = "/health"
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
    path     = "/health"
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
    path     = "/users/v1"
    matcher  = "200"
    interval = 30
    timeout  = 5
  }
}