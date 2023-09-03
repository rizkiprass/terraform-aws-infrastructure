# Task Definition
resource "aws_ecs_task_definition" "task_def_1" {
  family                   = format("%s-%s-taskdef", var.environment, var.app_name)
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      name = format("%s-react", var.environment) //container name
      image = "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.environment}-${var.app_name}"
      essential = true
      portMappings = [{
          containerPort = 80
          hostPort = 0
          protocol = "tcp"

      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "/ecs/${var.environment}-${var.app_name}"
          awslogs-region = "${var.aws_region}"
          awslogs-stream-prefix = "ecs"
        }
      }
      family = "${var.environment}-react2"
      networkMode = "brigde"
      requiresCompatibilities = ["EC2"]
      cpu = 256
      memory = 512
    }
  ])
}

resource "aws_cloudwatch_log_group" "ecs_cw" {
  name = "/ecs/react-taskdef"
}