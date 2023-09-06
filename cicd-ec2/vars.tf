variable "aws_region" {
  description = "AWS Region"
  default     = "eu-west-3"
}

variable "region" {
  default = "eu-west-3"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

#Tagging Common
variable "environment" {
  default = "dev"
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
}

############ Variable for Pipeline #################
variable "app_name" {
  default = "react"
}