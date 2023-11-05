locals {
  sg_db_name = format("%s-%s-db", var.project, var.environment)
}

//Security Group db
variable "mysql-port-list" {
  type = map(any)
  default = {
    "mysql" = 3306,
    "ssh"   = 22
  }
}

//mysql-sg
resource "aws_security_group" "db-sg" {
  name        = local.sg_db_name
  description = local.sg_db_name
  vpc_id      = module.vpc.vpc_id
  dynamic "ingress" {
    for_each = var.mysql-port-list
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = [
      var.cidr]
      description = ingress.key
    }
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1" //all traffic
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = local.sg_db_name
  })

}