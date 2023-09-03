module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  # insert the 14 required variables here
  name                             = format("%s-%s-VPC", var.project, var.environment)
  cidr                             = var.cidr
  enable_dns_hostnames             = true
  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]
  azs                              = ["${var.region}a", "${var.region}b"]
  public_subnets                   = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets                  = ["10.0.2.0/24", "10.0.3.0/24"]
  database_subnets                 = ["10.0.4.0/24", "10.0.5.0/24"]
  # Nat Gateway
  enable_nat_gateway = true
  single_nat_gateway = true #if true, nat gateway only create one
  # Reuse NAT IPs
  #  reuse_nat_ips         = true                 # <= if true, Skip creation of EIPs for the NAT Gateways
  #  external_nat_ip_ids   = [aws_eip.eip-nat.id] #attach eip from manual create eip
  public_subnet_suffix  = "public"
  private_subnet_suffix = "private"
  intra_subnet_suffix   = "db"
  #  intra_subnet_suffix   = "data"

  create_database_subnet_route_table = true #separate route table for database
  create_database_nat_gateway_route  = true #create db route table route to NAT
  tags                               = local.common_tags



  #  //tags for vpc flow logs
  #  vpc_flow_log_tags = {
  #    Name = format("%s-%s-vpc-flowlogs", var.customer, var.environment)
  #  }
}

#//eip for nat
#resource "aws_eip" "eip-nat" {
#  vpc = true
#  tags = merge(local.common_tags, {
#    Name = format("%s-%s-EIP", var.project, var.environment)
#  })
#}

#resource "aws_eip" "eip-nat2-sandbox" {
#  vpc = true
#  tags = merge(local.common_tags, {
#    Name = format("%s-production-EIP2", var.project)
#  })
#}

#resource "aws_eip" "eip-jenkins" {
#  vpc      = true
#  instance = aws_instance.jenkins-app.id
#  tags = merge(local.common_tags, {
#    Name = format("%s-production-EIP-jenkins", var.project)
#  })
#}

#

#//Create a db subnet with routing to nat
#resource "aws_subnet" "subnet-db-1a" {
#  vpc_id            = module.vpc.vpc_id
#  cidr_block        = var.Data_Subnet_AZA
#  availability_zone = format("%sa", var.aws_region)
#
#  tags = merge(local.common_tags,
#    {
#      Name = format("%s-%s-data-subnet-3a", var.customer, var.environment) //
#  })
#}
#
#resource "aws_subnet" "subnet-db-1b" {
#  vpc_id            = module.vpc.vpc_id
#  cidr_block        = var.Data_Subnet_AZB
#  availability_zone = format("%sb", var.aws_region)
#
#  tags = merge(local.common_tags,
#    {
#      Name = format("%s-%s-data-subnet-3b", var.customer, var.environment) //
#  })
#}
#
#resource "aws_route_table" "data-rt" {
#  vpc_id = module.vpc.vpc_id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = module.vpc.natgw_ids[0]
#  }
#
#  tags = merge(local.common_tags, {
#    Name = format("%s-%s-data-rt", var.customer, var.environment)
#  })
#}
#
#resource "aws_route_table_association" "rt-subnet-assoc-data-3a" {
#  subnet_id      = aws_subnet.subnet-db-1a.id
#  route_table_id = aws_route_table.data-rt.id
#}
