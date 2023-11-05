resource "aws_security_group" "node-sg" {
  name        = format("%s-%s-node-sg", var.project, var.environment)
  description = format("%s-%s-node-sg", var.project, var.environment)
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
    description = "node port"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
    description = "ssh"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1" //all traffic
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = local.common_tags

  lifecycle { ignore_changes = [ingress, egress] }

}