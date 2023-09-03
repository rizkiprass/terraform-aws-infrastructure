resource "aws_ecs_cluster" "cluster_1" {
  name = format("%s-%s-ecs-cluster", var.project, var.environment)

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}