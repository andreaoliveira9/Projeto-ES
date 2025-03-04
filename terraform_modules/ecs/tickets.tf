resource "aws_ecs_service" "tickets_api_service" {
  name            = "tickets-api-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.tickets_api_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.instances_sg_id]
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.tickets_api_tg_arn
    container_name   = "clubsync-tickets-api"
    container_port   = 8000
  }
}

resource "aws_ecs_task_definition" "tickets_api_task_definition" {
  family             = "tickets-api-task"
  network_mode       = "awsvpc"
  execution_role_arn = var.ecs_task_execution_role_arn
  cpu                = 256

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "clubsync-tickets-api"
      image     = format("%s:%s", var.tickets_api_image_repo, var.tickets_api_image_tag)
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/clubsync-tickets-api"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "MYSQL_URL"
          value = var.tickets_db_connection_string
        },
        {
          name  = "AWS_ACCESS_KEY_ID"
          value = var.aws_access_key_id_tickets
        },
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = var.aws_secret_access_key_tickets
        },
        {
          name = "USER_POOL_ID"
          value = var.cognito_user_pool_id
        },
        {
          name  = "AWS_REGION"
          value = var.aws_region
        },
        {
          name  = "RABBITMQ_URL"
          value = var.mq_connection_string
        },
        {
          name  = "STRIPE_API_KEY"
          value = var.stripe_api_key
        },
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "tickets_log_group" {
  name              = "/ecs/clubsync-tickets-api"
  retention_in_days = 7
}