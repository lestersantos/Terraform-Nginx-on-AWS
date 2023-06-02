//AUTOSCALING GROUP MODULE
locals {
  mytags ={
    Name = "${var.project_name}"
    Owner = "Lester Santos"
  }
}

resource "aws_autoscaling_group" "asg" {
  name               = "${var.project_name}-asg"
  desired_capacity   = 3
  max_size           = 6
  min_size           = 1
  target_group_arns  = [var.alb_tg_arn]
  health_check_type = "ELB"
  health_check_grace_period = 300
  
  launch_template {
    id      = var.lt_id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnets
}

resource "aws_autoscaling_policy" "target_tracking" {
  name           = "${var.project_name}-asg-target-tracking-policy"
  policy_type    = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
  estimated_instance_warmup = 100
}