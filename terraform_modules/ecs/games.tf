resource "aws_ecs_service" "games_api_service" {
  name            = "games-api-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.games_api_task_definition.arn
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
    target_group_arn = var.games_api_tg_arn
    container_name   = "clubsync-games-api"
    container_port   = 8000
  }
}

resource "aws_ecs_task_definition" "games_api_task_definition" {
  family             = "games-api-task"
  network_mode       = "awsvpc"
  execution_role_arn = var.ecs_task_execution_role_arn
  cpu                = 256

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "clubsync-games-api"
      image     = format("%s:%s", var.games_api_image_repo, var.games_api_image_tag)
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
          awslogs-group         = "/ecs/clubsync-games-api"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "MYSQL_URL"
          value = var.games_db_connection_string
        },
        {
          name  = "AWS_S3_BUCKET"
          value = var.s3_bucket_name
        },
        {
          name  = "AWS_ACCESS_KEY_ID"
          value = var.boto3_access_key
        },
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = var.boto3_secret_key
        },
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "games_api_log_group" {
  name              = "/ecs/clubsync-games-api"
  retention_in_days = 7
}