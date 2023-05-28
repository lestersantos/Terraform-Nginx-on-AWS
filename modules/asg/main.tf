//AUTOSCALING GROUP MODULE
resource "aws_autoscaling_group" "bar" {
  name               = "${var.project_name}-asg"
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = var.lt_id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnets
}