data "aws_iam_policy_document" "codebuild" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

#  statement {
#    effect = "Allow"
#
#    actions = [
#      "ec2:CreateNetworkInterface",
#      "ec2:DescribeDhcpOptions",
#      "ec2:DescribeNetworkInterfaces",
#      "ec2:DeleteNetworkInterface",
#      "ec2:DescribeSubnets",
#      "ec2:DescribeSecurityGroups",
#      "ec2:DescribeVpcs",
#    ]
#
#    resources = ["*"]
#  }

#  statement {
#    effect    = "Allow"
#    actions   = ["ec2:CreateNetworkInterfacePermission"]
#    resources = ["arn:aws:ec2:us-east-1:123456789012:network-interface/*"]
#
#    condition {
#      test     = "StringEquals"
#      variable = "ec2:Subnet"
#
#      values = [
#        aws_subnet.example1.arn,
#        aws_subnet.example2.arn,
#      ]
#    }
#
#    condition {
#      test     = "StringEquals"
#      variable = "ec2:AuthorizedService"
#      values   = ["codebuild.amazonaws.com"]
#    }
#  }

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.artifact.arn,
      "${aws_s3_bucket.artifact.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "codebuild" {
  role   = aws_iam_role.codebuild.name
  policy = data.aws_iam_policy_document.codebuild.json
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.project}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

resource "aws_codebuild_project" "react" {
  name          = "${var.project}-${var.app_name}-build"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "S3"
    location = aws_s3_bucket.artifact.arn
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

    source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.react.clone_url_http
  }
  }