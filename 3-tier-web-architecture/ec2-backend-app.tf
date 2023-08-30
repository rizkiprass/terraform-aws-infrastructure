locals {
  node_name = format("%s-%s-node", var.project, var.environment)
}

//Server Private web
resource "aws_instance" "node-app" {
  ami                         = data.aws_ami.ubuntu_20.id
  instance_type               = "t3.micro"
  associate_public_ip_address = "false"
  key_name                    = "sandbox-key"
  subnet_id                   = module.vpc.private_subnets[0]
  iam_instance_profile        = aws_iam_instance_profile.ssm-profile.name
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  vpc_security_group_ids = [aws_security_group.node-sg.id]
  root_block_device {
    volume_size           = 256
    volume_type           = "gp3"
    iops                  = 3000
    encrypted             = true
    delete_on_termination = true
    tags = merge(local.common_tags, {
        Name = format("%s-ebs", local.node_name)
    })
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(local.common_tags, {
    Name                = local.node_name,
    OS                  = "Ubuntu",
    Backup              = "DailyBackup" # TODO: Set Backup Rules
  })
}