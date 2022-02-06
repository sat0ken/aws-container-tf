resource "aws_ecs_cluster" "foo" {
  name = var.name
  tags = merge(var.tags, { Name : var.name })
}

output "cluster_id" {
  value = aws_ecs_cluster.foo.id
}