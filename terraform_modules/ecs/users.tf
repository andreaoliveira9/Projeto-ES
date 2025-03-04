resource "aws_ecs_service" "users_api_service" {
  name            = "users-api-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.users_api_task_definition.arn
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
    target_group_arn = var.users_api_tg_arn
    container_name   = "clubsync-users-api"
    container_port   = 8000
  }
}

resource "aws_ecs_task_definition" "users_api_task_definition" {
  family             = "users-api-task"
  network_mode       = "awsvpc"
  execution_role_arn = var.ecs_task_execution_role_arn
  cpu                = 256

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "clubsync-users-api"
      image     = format("%s:%s", var.users_api_image_repo, var.users_api_image_tag)
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
          awslogs-group         = "/ecs/clubsync-users-api"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "MYSQL_URL"
          value = var.users_db_connection_string
        },
        {
          name  = "AWS_REGION"
          value = var.aws_region
        },
        {
          name  = "USER_POOL_ID"
          value = var.cognito_user_pool_id
        },
        {
          name  = "COGNITO_USER_CLIENT_ID"
          value = var.cognito_user_client_id
        },
        {
          name  = "COGNITO_USER_CLIENT_SECRET"
          value = var.cognito_user_client_secret
        },
        {
          name  = "COGNITO_TOKEN_ENDPOINT"
          value = var.cognito_token_endpoint
        },
        {
          name  = "REDIRECT_URI"
          value = "${var.domain}/oauth2/idpresponse"
        },
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "users_api_log_group" {
  name              = "/ecs/clubsync-users-api"
  retention_in_days = 7
}