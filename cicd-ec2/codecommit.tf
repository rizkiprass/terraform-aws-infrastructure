resource "aws_codecommit_repository" "react" {
  repository_name = "${var.project}-${var.app_name}"
  description     = "This is the Sample App Repository"
}