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

variable "project_name" {
  description = "Project Name"
}

variable "acm_certificate" {
  description = "ACM SSL certificate ARN"
}

variable "ssl_policy" {
  description = "Security policy, to negotiate SSL connections"
}