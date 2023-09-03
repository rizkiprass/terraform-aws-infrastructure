resource "aws_ecs_service" "fe_service" {
  name                               = format("%s-%s-$s-service", var.project, var.environment, var.app_name)
  task_definition                    = aws_ecs_task_definition.aws_ecs_task.family
  cluster                            = aws_ecs_cluster.aws_ecs_cluster.name
  enable_ecs_managed_tags            = true
  force_new_deployment               = true
  launch_type                        = "EC2"
  desired_count                      = var.ecs_service_desired
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

#  load_balancer {
#    target_group_arn = module.alb_public.target_group_arns[0]
#    container_name   = aws_ecr_repository.aws_ecr.name
#    container_port   = "443"
#  }

  # depends_on = ["aws_alb_listener_rule.ecs_alb_listener_rule"]
}