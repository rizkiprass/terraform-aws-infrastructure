locals {
  name   = "sandbox-mysql"
  region = var.aws_region
  tags = {
    project     = var.project
    environment = var.environment
  }

  engine               = "mysql"
  engine_version       = "5.7"
  family               = "mysql5.7" # DB parameter group
  major_engine_version = "5.7"      # DB option group
  instance_class       = "db.t3.micro"
  allocated_storage    = 30
  port                 = 3306
}

resource "random_string" "dbpass" {
  length           = 16
  upper            = true
  lower            = true
  numeric          = true
  special          = true
  override_special = "#$!^"
}

###############################################################################
#Master DB
###############################################################################

module "master" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.1.1"

  identifier = local.name #The name of the RDS instance

  engine               = local.engine
  engine_version       = local.engine_version
  family               = local.family
  major_engine_version = local.major_engine_version
  instance_class       = local.instance_class

  // Only support for >= t3.medium
  //performance_insights_enabled = true
  //performance_insights_retention_period = 7

  #max_allocated_storage = 1000

  auto_minor_version_upgrade = false

  allocated_storage = local.allocated_storage
  storage_encrypted = true

  port = local.port

  publicly_accessible    = false
  multi_az               = false
  create_db_subnet_group = false
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  # Backups are required in order to create a replica
  backup_retention_period     = 1
  skip_final_snapshot         = true
  deletion_protection         = false
  db_name                     = "mydb"
  username                    = "admin"
  manage_master_user_password = false
  password                    = random_string.dbpass.result
  availability_zone           = "${var.region}a"

  tags = {
    Name        = format("%s-%s-rds", var.project, var.environment)
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "rds-subnet" {
  name       = format("%s-%s-rds-subnet", var.project, var.environment)
  subnet_ids = [module.vpc.database_subnets[0], module.vpc.database_subnets[1]]

  tags = {
    Name        = format("%s-%s-subnet-group", var.project, var.environment)
    ENVIRONMENT = var.environment
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rdsmysql"
  description = "rdsmysql"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############Create without module##################
// RDS
#resource "aws_db_instance" "rdsmysql" {
#  allocated_storage       = 80
#  storage_type            = "gp2"
#  engine                  = "mysql"
#  engine_version          = "5.7.38"
#  instance_class          = "db.t3.medium"
#  db_name                 = "rdsmysql"
#  identifier              = "rdsmysql"
#  username                = "admin"
#  password                = random_string.dbpass.result
#  port                    = "3306"
#  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
#  db_subnet_group_name    = aws_db_subnet_group.subnetgroup_db.id
#  deletion_protection     = false
#  backup_retention_period = 30
#  maintenance_window      = "Mon:00:00-Mon:03:00"
#  backup_window           = "03:00-06:00"
##  ca_cert_identifier      = "rds-ca-2019"
#  auto_minor_version_upgrade  = "true"
#  parameter_group_name    = aws_db_parameter_group.rdsmysql-pg.id
#  multi_az                = true
#
#  skip_final_snapshot = true
#  publicly_accessible = false
#
#  tags = {
#    Name = "rdsmysql" //tagging name at rds
#    Birthday = "${var.Birthday}"
#    Environment = "${var.environment == "" ? "Development" : "Production"}"
#  }
#}


#resource "aws_db_parameter_group" "rdsmysql-pg" {
#  name   = "rdsmysql-pg"
#  family = "mysql5.7"
#  description = "mysql-db"
#}

#resource "aws_db_subnet_group" "subnetgroup_db" {
#  name       = "rdsmysql"
#  #subnet_ids = ["${aws_subnet.subnet-db-1a.id}", "${aws_subnet.subnet-db-1b.id}"]
#  subnet_ids =   [module.vpc.intra_subnets[0], module.vpc.intra_subnets[1]]
#
#  tags = {
#    Name = "rdsmysql"
#    Birthday = "${var.Birthday}"
#    Environment = "${var.environment == "" ? "Development" : "Production"}"
#  }
#}
##########################################################################################

output "dbpass" {
  value       = "Please copy and save your password = ${random_string.dbpass.result}"
  description = "password rds"
}