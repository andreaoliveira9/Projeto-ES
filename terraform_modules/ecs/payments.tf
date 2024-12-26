resource "aws_ecs_service" "payments_api_service" {
  name            = "payments-api-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.payments_api_task_definition.arn
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
    target_group_arn = var.payments_api_tg_arn
    container_name   = "clubsync-payments-api"
    container_port   = 8000
  }
}

resource "aws_ecs_task_definition" "payments_api_task_definition" {
  family             = "payments-api-task"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::334642795591:role/ecsTaskExecutionRole"
  cpu                = 256

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "clubsync-payments-api"
      image     = format("%s:%s", var.payments_api_image_repo, var.payments_api_image_tag)
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
          awslogs-group         = "/ecs/clubsync-payments-api"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      /* environment = [
        {
          name  = "DATABASE_URL"
          value = var.drop_off_points_db_connection_string
        },
      ] */
    }
  ])
}

resource "aws_cloudwatch_log_group" "payments_log_group" {
  name              = "/ecs/clubsync-payments-api"
  retention_in_days = 7
}