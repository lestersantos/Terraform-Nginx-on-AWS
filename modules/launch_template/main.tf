# Launch template from terraform

resource "aws_launch_template" "lt" {
  name          = "${var.project_name}-lt-${terraform.workspace}"
  image_id      = var.ami
  instance_type = var.instance_size

  # Volume configuration 
  block_device_mappings {
    device_name = "/dev/sda1" #Where are we mounting the volume

    ebs {
      volume_size = var.disk_size
      encrypted   = "true"
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.profile.arn
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    device_index                = 0
    security_groups             = [aws_security_group.allow_tls.id]
  }

  user_data = filebase64("${path.module}/init.sh")

}
#-------------AWS INSTANCE PROFILE--------------------------
resource "aws_iam_instance_profile" "profile" {
  name = "${var.project_name}-profile"
  role = aws_iam_role.role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "role" {
  name               = "${var.project_name}-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
#----------------------------------------------------------

#-------------AWS SECURITY GROUP --------------------------
resource "aws_security_group" "allow_tls" {
  name        = "${var.project_name}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443 # one single port
    to_port     = 443 # both the same port number
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
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