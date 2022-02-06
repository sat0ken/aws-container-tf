resource "aws_ecs_task_definition" "service" {
  family = var.name
  container_definitions = jsonencode(templatefile("${path.module}/task.tmpl", {
    name  = var.container_name
    image = var.container_image
    port  = var.container_port
  }))
}