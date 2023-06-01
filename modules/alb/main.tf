locals {
  mytags ={
    Name = "${var.project_name}"
    Owner = "Lester Santos"
  }
}

resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnets

  tags = merge(local.mytags, {Name = "${local.mytags.Name}-alb"})
}

#-------------AWS ALB LISTENER ----------------------------
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_certificate
  tags = merge(local.mytags, {Name = "${local.mytags.Name}-alb-listener"})

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.albtg.arn
  }
}
#---------------------------------------------------------

#--------------AWS ALB TARGET GROUP ----------------------
resource "aws_lb_target_group" "albtg" {
  name     = "${var.project_name}-ALBTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    path = "/"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = 200
  }
  tags = merge(local.mytags, {Name = "${local.mytags.Name}-ALBTG"})
}

#---------------------------------------------------------

#-------------AWS SECURITY GROUP --------------------------
resource "aws_security_group" "lb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allows https traffic from internet to ALB"
  vpc_id      = var.vpc_id
  tags = merge(local.mytags, {Name = "${local.mytags.Name}-alb-sg"})

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443 # one single port
    to_port     = 443 # both the same port number
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80 # one single port
    to_port     = 80 # both the same port number
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0 #All traffic
    to_port     = 0
    protocol    = "-1" #minus one means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#-----------------------------------------------------------