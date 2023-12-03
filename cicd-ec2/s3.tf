#Bucket for codedeploy
resource "aws_s3_bucket" "artifact" {
  bucket = "${var.project}-${var.app_name}-pipeline-artifact"

  tags = merge(local.common_tags, {
    Name = format("%s-%s-pipeline-artifact", var.project, var.environment),
  })
}