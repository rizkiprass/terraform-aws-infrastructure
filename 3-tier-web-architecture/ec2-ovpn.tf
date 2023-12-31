module "ec2-openvpn" {
  source = "rizkiprass/ec2-openvpn-as/aws"

  name                          = "Openvpn-Access-Server"
  create_ami                    = true
  create_vpc_security_group_ids = true
  instance_type                 = "t3.micro"
  key_name                      = "sandbox-key"
  vpc_id                        = module.vpc.vpc_id
  ec2_subnet_id                 = module.vpc.public_subnets[0]
  user_openvpn                  = "user-1"
  routing_ip                    = "10.0.0.0/16"

  tags = {
    Terraform = "Yes"
  }
}