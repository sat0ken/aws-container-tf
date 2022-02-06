resource "aws_ecs_cluster" "mycluster" {
  name = var.clutser_name
  tags = merge(var.tags, { Name : var.clutser_name })
}

resource "aws_ecs_task_definition" "task" {
  family             = "${var.container_name}-task-define"
  execution_role_arn = var.execution_role_arn
  network_mode       = "awsvpc"

  container_definitions = templatefile("${path.module}/task.tmpl", {
    name   = var.container_name
    image  = var.container_image
    port   = var.container_port
    region = var.region
    container_env = jsonencode([
      for env in var.container_env : {
        name  = env.name
        value = env.value
      }
    ])
    container_secret = jsonencode([
      for secret in var.container_secrets : {
        name      = secret.name
        valueFrom = secret.valueFrom
      }
    ])
  })

  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
  }
  cpu    = 256
  memory = 512
  tags   = merge(var.tags, { Name = "${var.container_name}-task-define" })
}

resource "aws_ecs_service" "service" {
  name        = "${var.container_name}-ecs-service"
  cluster     = aws_ecs_cluster.mycluster.id
  launch_type = "FARGATE"

  desired_count = 1

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  deployment_controller {
    type = "ECS"
  }
  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [module.security-group.security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = var.container_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count, capacity_provider_strategy]
  }

  tags = merge(var.tags, { Name = "${var.container_name}-ecs-service" })
}

output "aws_ecs_service_id" {
  value = aws_ecs_service.imadoko.id
}
