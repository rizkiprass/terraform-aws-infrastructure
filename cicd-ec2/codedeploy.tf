data "aws_iam_policy_document" "assume_by_codedeploy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

# Get the policy by name
data "aws_iam_policy" "AWSCodeDeployRole-policy" {
  name = "AWSCodeDeployRole"
}

# Create additional policy for codedeploy service
resource "aws_iam_policy" "codedeploy-service-as" {
  name        = format("%s-codedeploy-service-as", var.project)
  description = "If you create your Auto Scaling group with a launch template, you must add the following permissions"
  policy      = file("./template/codedeploy-servicerole.json")
  tags        = local.common_tags
}

# Attach the AWSCodeDeployRole policy to the codedeploy role
resource "aws_iam_role_policy_attachment" "attach-to-codedeploy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = data.aws_iam_policy.AWSCodeDeployRole-policy.arn
}

# Attach the codedeploy-service policy to the codedeploy role
resource "aws_iam_role_policy_attachment" "ssmcore-attach-codedeploy-service" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = aws_iam_policy.codedeploy-service-as.arn
}

# Create Role for codedeploy
resource "aws_iam_role" "codedeploy" {
  name               = format("%s-codedeploy-role", var.project)
  assume_role_policy = data.aws_iam_policy_document.assume_by_codedeploy.json
  tags               = local.common_tags
  //  depends_on = [aws_iam_policy.codedeploy-service-as]
}

//resource "aws_iam_role_policy" "codedeploy" {
//  role   = "${aws_iam_role.codedeploy.name}"
//  policy = "${data.aws_iam_policy_document.codedeploy-career-journey-dta.json}"
//}

resource "aws_codedeploy_app" "deploy" {
  name = "${var.app_name}-deploy"
}

################### Deployment to EC2 using load balaner #####################
resource "aws_codedeploy_deployment_group" "deployment" {
  app_name              = aws_codedeploy_app.deploy.name
  deployment_group_name = format("%s-%s-web-deploy-asg", var.project, var.environment)
  service_role_arn      = aws_iam_role.codedeploy.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "codedeploy"
      type  = "KEY_AND_VALUE"
      value = "yes"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.albtg-web-app.name
    }
  }
}