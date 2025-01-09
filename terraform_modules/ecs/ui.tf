resource "aws_ecs_service" "user_ui_service" {
  name            = "user-ui-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.user_ui_task_definition.arn
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
    target_group_arn = var.user_ui_tg_arn
    container_name   = "clubsync-user-ui"
    container_port   = 8080
  }
}

resource "aws_ecs_task_definition" "user_ui_task_definition" {
  family             = "user-ui-task"
  network_mode       = "awsvpc"
  execution_role_arn = var.ecs_task_execution_role_arn
  cpu                = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "clubsync-user-ui"
      image     = format("%s:%s", var.user_ui_image_repo, var.user_ui_image_tag)
      cpu       = 512
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/clubsync-user-ui"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [
        {
          name  = "VITE_LOGIN_SIGN_UP"
          value = var.login_sign_up
        },
        {
          name = "DOMAIN"
          value = var.domain
        }
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "user_ui_log_group" {
  name              = "/ecs/clubsync-user-ui"
  retention_in_days = 7
}