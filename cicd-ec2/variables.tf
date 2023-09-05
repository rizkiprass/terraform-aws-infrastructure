variable "project" {
  default = "sandbox"
}

variable "app_name" {
  default = "react"
}

variable "environment" {
  default = "dev"
}

#Tagging Common
locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "Yes"
  }
}