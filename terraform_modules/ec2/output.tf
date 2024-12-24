output "games_target_group_arn" {
  description = "ARN of the Games Target Group"
  value       = aws_lb_target_group.games_tg.arn
}

output "payments_target_group_arn" {
  description = "ARN of the Payments Target Group"
  value       = aws_lb_target_group.payments_tg.arn
}

output "tickets_target_group_arn" {
  description = "ARN of the Tickets Target Group"
  value       = aws_lb_target_group.tickets_tg.arn
}

output "users_target_group_arn" {
  description = "ARN of the Users Target Group"
  value       = aws_lb_target_group.users_tg.arn
}

output "ui_listener_https_arn" {
  description = "ARN of the HTTPS Listener for UI"
  value       = aws_lb_listener.listener_https.arn
}

output "apis_listener_http_arn" {
  description = "ARN of the HTTP Listener for APIs"
  value       = aws_lb_listener.listener_http.arn
}