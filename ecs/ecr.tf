resource "aws_ecr_repository" "aws_ecr" {
  name = format("%s-%s-ecr", var.environment, var.app_name)

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = local.common_tags
}