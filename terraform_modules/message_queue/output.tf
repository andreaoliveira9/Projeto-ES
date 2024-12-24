output "mq_connection_string" {
  value       = "amqps://${aws_mq_broker.mq.id}.mq.${aws_region.current.name}.amazonaws.com:5671"
  description = "Connection string for RabbitMQ"
}