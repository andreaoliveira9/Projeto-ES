output "mq_connection_string" {
  value       = "amqps://${aws_mq_broker.mq.id}.mq.${var.aws_region.name}.amazonaws.com:5671"
  description = "Connection string for RabbitMQ"
}