provider "aws" {
  region = var.aws_region
  #  access_key = var.access_key
  #  secret_key = var.secret_key
}

#terraform {
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "~> 5.0"  # Replace with your desired version constraint
#    }
#  }
#}
