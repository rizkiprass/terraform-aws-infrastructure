locals {
  bastion_name = format("%s-%s-bastion", var.project, var.environment)
}

//Server Private web
resource "aws_instance" "bastion-app" {
  ami = data.aws_ami.ubuntu_20.id
  #  ami                         = "ami-0261755bbcb8c4a84"
  instance_type               = "t3.medium"
  associate_public_ip_address = "true"
  key_name                    = "tp-key"
  subnet_id                   = module.vpc.public_subnets[0]
  iam_instance_profile        = aws_iam_instance_profile.ssm-profile.name
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    iops                  = 3000
    encrypted             = true
    delete_on_termination = true
    tags = merge(local.common_tags, {
      Name = format("%s-ebs", local.bastion_name)
    })
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = []
  }

  depends_on = [module.vpc.natgw_ids]

  tags = merge(local.common_tags, {
    Name = local.bastion_name,
    OS   = "Ubuntu",
  })
}

//AWS Resource for Create EIP bastion
resource "aws_eip" "bastion-eip" {
  instance = aws_instance.bastion-app.id
  vpc      = true
  tags = merge(local.common_tags, {
    Name = "bastion-eip"
  })
}