# Locals
locals {
  mytags ={
    Name = "${var.project_name}"
    Owner = "Lester Santos"
  }
}

# Launch template from terraform
resource "aws_launch_template" "lt" {
  name          = "${var.project_name}-lt-${terraform.workspace}"
  image_id      = var.ami
  instance_type = var.instance_size

  iam_instance_profile {
    arn = aws_iam_instance_profile.profile.arn
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    device_index                = 0
    security_groups             = [aws_security_group.allow_tls.id]
  }

  user_data = filebase64("${path.module}/init.sh")

  tags = merge(local.mytags, {Name = "${local.mytags.Name}-EC2-nginx-webserver"})
  description = "EC2 Backend running nginx"

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.mytags, {Name = "${local.mytags.Name}-EC2-nginx-webserver"})
  }
}
#-------------AWS INSTANCE PROFILE--------------------------
resource "aws_iam_instance_profile" "profile" {
  name = "${var.project_name}-profile"
  role = aws_iam_role.role.name
}
#-------------AWS TRUSTED POLICY DOCUMENT ----------------
data "aws_iam_policy_document" "trust_policy_ec2" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
#------------AWS IAM ROLE --------------------------------
resource "aws_iam_role" "role" {
  name               = "${var.project_name}-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.trust_policy_ec2.json
  tags = local.mytags
}
#----------------------------------------------------------
#------------------ AWS IAM ROLE POLICY ATTACHMENT --------
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::737584674007:policy/lsS3RestrictedPolicy"
}
#----------------------------------------------------------

#-------------AWS SECURITY GROUP --------------------------
resource "aws_security_group" "allow_tls" {
  name        = "${var.project_name}-EC2Webserver-sg"
  description = "Allows traffic from ALB to backend instances"
  vpc_id      = var.vpc_id
  tags = merge(local.mytags, {Name = "${local.mytags.Name}-EC2Webserver-sg"})

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443 # one single port
    to_port     = 443 # both the same port number
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.alb_sg_id]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80 # one single port
    to_port     = 80 # both the same port number
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0 #All traffic
    to_port     = 0
    protocol    = "-1" #minus one means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#-----------------------------------------------------------