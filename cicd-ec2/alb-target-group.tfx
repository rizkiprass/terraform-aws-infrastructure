////////target group web-app
resource "aws_lb_target_group" "albtg-web-app" {
  name     = format("%s-%s-albtg-web-app", var.project, var.environment)
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
  # lifecycle {
  #     create_before_destroy = true
  #   }

  tags = merge(local.common_tags, {
    Name = format("%s-%s-albtg-web-app", var.project, var.environment)
  })
}

################# TARGET GROUP ASG ################
#resource "aws_lb_target_group" "albtg-web-asg" {
#  name     = format("%s-%s-albtg-web-asg", var.project, var.environment)
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = module.vpc.vpc_id
#  health_check {
#    path                = "/"
#    protocol            = "HTTP"
#    healthy_threshold   = 3
#    unhealthy_threshold = 2
#  }
#  # lifecycle {
#  #     create_before_destroy = true
#  #   }
#
#  tags = merge(local.common_tags, {
#    Name = format("%s-%s-albtg-web-asg", var.project, var.environment)
#  })
#}
#
#//attachment asg
## Create a new ALB Target Group attachment
#resource "aws_autoscaling_attachment" "asg_attachment" {
#  autoscaling_group_name = module.autoscaling-launchtemplate.autoscaling_group_name
#  lb_target_group_arn    = aws_lb_target_group.albtg-web-asg.arn
#}
################################################

######################### CREATE LISTENER HTTP ###########################

## Redirect to HTTPS
#resource "aws_lb_listener" "ALBListenerwebhttp" {
#  load_balancer_arn = aws_lb.web-alb.arn
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type             = "redirect"
#    target_group_arn = aws_lb_target_group.albtg-web-app.arn
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#}

## Forward to HTTP
resource "aws_lb_listener" "ALBListenerwebhttp" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.albtg-web-app.arn
  }
}

##custom rule http (Optional)
#resource "aws_lb_listener_rule" "prod-http" {
#  listener_arn = aws_lb_listener.ALBListenerwebhttp.arn
#  priority     = 100
#
#  action {
#    type = "redirect"
#
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#
#  condition {
#    host_header {
#      values = ["rp-server.site"]
#    }
#  }
#}

#resource "aws_lb_listener_rule" "dev-http" {
#  listener_arn = aws_lb_listener.ALBListenerwebhttp.arn
#  priority     = 90
#
#  action {
#    type = "redirect"
#
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#
#  condition {
#    host_header {
#      values = ["dev.rp-server.site"]
#    }
#  }
#}

#####################################################################################

#################### Create Listener Https ########################################
#resource "aws_lb_listener" "ALBListenerwebhttps" {
#  load_balancer_arn = aws_lb.web-alb.arn
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = aws_acm_certificate.cert-rp.arn
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.albtg-web-app.arn
#  }
#}

#//Custom Rule HTTPS
#resource "aws_lb_listener_rule" "prod-https" {
#  listener_arn = aws_lb_listener.ALBListenerwebhttps.arn
#  priority     = 100
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.albtg-prod-app.arn
#  }
#
#  condition {
#    host_header {
#      values = ["prod.rp-server.site"]
#    }
#  }
#}

#resource "aws_lb_listener_rule" "dev-https" {
#  listener_arn = aws_lb_listener.ALBListenerwebhttps.arn
#  priority     = 90
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.albtg-dev-app.arn
#  }
#
#  condition {
#    host_header {
#      values = ["dev.rp-server.site"]
#    }
#  }
#}

//attach web-app
resource "aws_lb_target_group_attachment" "web-app-attach" {
  target_group_arn = aws_lb_target_group.albtg-web-app.arn
  target_id        = aws_instance.web-app.id
  port             = 80
}



#///////target group dev-app
#resource "aws_lb_target_group" "albtg-dev-app" {
#  name     = format("%s-dev-albtg-dev-app", var.project)
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = module.vpc.vpc_id
#  health_check {
#    path                = "/"
#    protocol            = "HTTP"
#    healthy_threshold   = 3
#    unhealthy_threshold = 2
#  }
#  # lifecycle {
#  #     create_before_destroy = true
#  #   }
#
#  tags = merge(local.common_tags, {
#    Name = format("%s-%s-albtg-dev-app", var.project, var.environment)
#  })
#}

//create Listener Http
# resource "aws_lb_listener" "ALBListenerapphttp" {
#   load_balancer_arn = "${aws_lb.web-alb.arn}"
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "forward"
#     target_group_arn = "${aws_lb_target_group.albtg-vectrkdev-jkt01.arn}"

#     /*redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     } */
#   }
# }

# // Create Listener Https
# resource "aws_lb_listener" "ALBListenerbehttps" {
#    load_balancer_arn = "${aws_lb.be-alb.arn}"
#    port              = "443"
#    protocol          = "HTTPS"
#    ssl_policy        = "ELBSecurityPolicy-2016-08"
#    certificate_arn   = "arn:aws:acm:ap-southeast-1:465117112479:certificate/5a49ef56-ee76-4e06-93d6-0a986fbd5cd7"

#    default_action {
#      type             = "forward"
#      target_group_arn = "${aws_lb_target_group.albtg-be.arn}"
#    }
#  }


#//attach dev-app
#resource "aws_lb_target_group_attachment" "dev-app-attach" {
#  target_group_arn = aws_lb_target_group.albtg-dev-app.arn
#  target_id        = aws_instance.prod-app.id
#  port             = 80
#}