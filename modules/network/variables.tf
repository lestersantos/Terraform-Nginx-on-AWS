#vARIABLES
variable "vpc_cidr" {
  description = "Type the VPC CIDR"
}

variable "environment" {
  description = "Type the enviroment name"
  default = "dev"
}

variable "project_name" {
  description = "Project Name"
}