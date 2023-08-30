locals {
  sg_alb_name = format("%s-%s-alb-sg", var.project, var.environment)
}

# ALB Security Group

variable "alb-port-list" {
  type = map(any)
  default = {
    "http"  = 80
    "https" = 443
  }
}

resource "aws_security_group" "alb-sg" {
  name        = local.sg_alb_name
  description = local.sg_alb_name
  vpc_id      = module.vpc.vpc_id
  dynamic "ingress" {
    for_each = var.alb-port-list
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = [
      "0.0.0.0/0"]
      description = ingress.key
    }
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = merge(local.common_tags, {
    Name = local.sg_alb_name,
  })
  lifecycle {
    ignore_changes = [
    ingress]
  }
}