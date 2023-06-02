#vARIABLES
variable "lt_id" {
  description = "Type the VPC CIDR"
}

variable "subnets"{
  type = list(string)
}

variable "project_name" {
  description = "Project Name"
}

variable "alb_tg_arn" {
    description = "Target Groutp ARN for use with Application Load Balancer"
}