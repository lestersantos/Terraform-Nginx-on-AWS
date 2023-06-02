variable "project_name" {
  description = "Project Name"
}

variable "vpc_id" {
  description = "VPC ID where load balancer is going to be created"
  validation {
    condition     = length(var.vpc_id) > 4 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The vpc_id value must be a valid VPC id, starting with \"VPC-\"."
  }
}

variable "subnets"{
  type = list(string)
}

variable "backend_sg_id" {
  description = "Specify the Application Load Balancer Security Group id"
}