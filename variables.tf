variable "project_name" {
  type = string
}

variable "vpc_module"{
  description = "Set of variables for VPC Module"  
}

variable "launch_template_module"{
  description = "Set of variables for Launch Template Module"
}

variable "alb_module"{
    description = "Set of variables for Application Load Balancer Module"
}
