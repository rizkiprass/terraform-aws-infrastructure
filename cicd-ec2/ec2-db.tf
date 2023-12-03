locals {
  db_name = format("%s-%s-db", var.project, var.environment)
}

//Server Private web
resource "aws_instance" "db" {
  ami = data.aws_ami.ubuntu_20.id
  #  ami                         = "ami-0261755bbcb8c4a84"
  instance_type               = "t3.medium"
  associate_public_ip_address = "false"
  key_name                    = aws_key_pair.webmaster-key.key_name
  subnet_id                   = module.vpc.database_subnets[0]
  iam_instance_profile        = aws_iam_instance_profile.ssm-codedeploy-profile.name
  user_data                   = file("./user_data/install_mysql_ubuntu20.sh")
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    iops                  = 3000
    encrypted             = true
    delete_on_termination = true
    tags = merge(local.common_tags, {
      Name = format("%s-ebs", local.db_name)
    })
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [module.vpc.natgw_ids]

  tags = merge(local.common_tags, {
    Name       = local.db_name,
    OS         = "Ubuntu",
    Backup     = "DailyBackup" # TODO: Set Backup Rules
  })
}