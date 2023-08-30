resource "aws_security_group" "web-sg" {
  name        = format("%s-%s-web-sg", var.project, var.environment)
  description = format("%s-%s-web-sg", var.project, var.environment)
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    var.cidr]
    description = "http"
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
    var.cidr]
    description = "https"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    var.cidr]
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