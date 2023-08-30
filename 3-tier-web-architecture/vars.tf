variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "region" {
  default = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

#Tagging Common
variable "environment" {
  default = "prod"
}

variable "environment_dev" {
  default = "dev"
}
variable "project" {
  default = "sandbox"
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "Yes"
  }

  common_tags_dev = {
    Project     = var.project
    Environment = var.environment_dev
    Terraform   = "Yes"
  }
}