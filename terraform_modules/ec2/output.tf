output "ecs_asg_arn" {
  value = aws_autoscaling_group.asg.arn
}

output "user_ui_tg_arn" {
  value = aws_lb_target_group.ui_tg.arn
}

output "games_api_tg_arn" {
  value = aws_lb_target_group.games_tg.arn
}

output "tickets_api_tg_arn" {
  value = aws_lb_target_group.tickets_tg.arn
}

output "users_api_tg_arn" {
  value = aws_lb_target_group.users_tg.arn
}


output "payments_api_tg_arn" {
  value = aws_lb_target_group.payments_tg.arn
}


output "instances_sg_id" {
  value = aws_security_group.instances.id
}