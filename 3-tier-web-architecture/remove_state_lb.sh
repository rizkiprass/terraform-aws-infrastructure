#!/bin/bash

# List of Terraform resources to be removed
resources=("aws_lb_target_group_attachment.web-app-attach"
           "aws_lb_listener.ALBListenerwebhttp"
           "aws_lb_target_group.albtg-web-app"
           "aws_lb_target_group_attachment.web-app-attach"
           "aws_lb.web-alb")

# Loop through the resources array and remove each resource
for resource in "${resources[@]}"
do
    terraform state rm "$resource"
done

echo "All specified resources have been removed."