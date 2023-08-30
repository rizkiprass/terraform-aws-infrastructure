#Create Role ssm core role
resource "aws_iam_role" "ssm-core-role" {
  name        = format("%s-ssm-core-role", var.project)
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