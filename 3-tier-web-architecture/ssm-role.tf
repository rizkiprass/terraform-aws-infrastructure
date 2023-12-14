#Create Role ssm core role
resource "aws_iam_role" "ssm-core-role" {
  name               = format("%s-ssm-core-role", var.project)
  assume_role_policy = file("template/assumepolicy.json")
  tags = merge(local.common_tags, {
    Name = format("%s-ssm-core-role", var.project)
  })

}

#Attach Policy SSMCore
resource "aws_iam_role_policy_attachment" "ssmcore-attach-ssmcore" {
  role       = aws_iam_role.ssm-core-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#Attach Policy CloudWatch
resource "aws_iam_role_policy_attachment" "ssmcore-attach-cwatch" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.ssm-core-role.name
}

#Instance Profile ssm
resource "aws_iam_instance_profile" "ssm-profile" {
  name = format("%s-ssm-profile", var.project)
  role = aws_iam_role.ssm-core-role.name
}

############################### FOR CODEDEPLOY ##########################################
#create policy permission to access s3 for download bundle
resource "aws_iam_policy" "codedeploy-s3-ec2" {
  name        = format("%s-codedeploy-ec2", var.project)
  description = "attach this policy to ec2 instance profile for codedeploy purpose"
  policy      = file("./template/codedeploy-instanceprofile.json")
  tags        = local.common_tags
}

#1.Attach Policy SSMCore
resource "aws_iam_role_policy_attachment" "ssmcore-attach-ssmcore3" {
  role       = aws_iam_role.ssmcore-codedeploy-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#2.Attach Policy CloudWatch
resource "aws_iam_role_policy_attachment" "ssmcore-attach-cwatch3" {
  role       = aws_iam_role.ssmcore-codedeploy-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

#3. Attach Policy codedeploy-ec2
resource "aws_iam_role_policy_attachment" "ssmcore-attach-codedeploy-ec2" {
  role       = aws_iam_role.ssmcore-codedeploy-role.name
  policy_arn = aws_iam_policy.codedeploy-s3-ec2.arn
}

#Create Role for ec2 contain 1.ssminstancecore, 2.cwagent, 3.codedeploy policy. Please attach this role to ec2 that you want to use for codedeploy
resource "aws_iam_role" "ssmcore-codedeploy-role" {
  name               = format("%s-ssmcore-codedeploy-role", var.project)
  assume_role_policy = file("template/assumepolicy.json")
  tags = merge(local.common_tags, {
    Name = format("%s-ssmcore-codedeploy-role", var.project)
  })
}

#Instance Profile ec2 for codedeploy download bundled
resource "aws_iam_instance_profile" "ssm-codedeploy-profile" {
  role = aws_iam_role.ssmcore-codedeploy-role.name
  name = format("%s-ssm-codedeploy-profile2", var.project)
}