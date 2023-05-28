#vARIABLES
variable "vpc_id" {
  description = "VPC ID where instances are going to be launched"
  validation {
    condition     = length(var.vpc_id) > 4 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The vpc_id value must be a valid VPC id, starting with \"VPC-\"."
  }
}

variable "instance_size" {
  description = "Instance size fo the Launch Template"
}

#"ami-0889a44b331db0194"

variable "disk_size" {
  type        = number
  description = "Disk size in GB"
  validation {
    condition     = var.disk_size >= 8
    error_message = "The disk_size has to be greater than 8GB"
  }
}

variable "ami" {
  description = "Specify the AMI ID"
  validation {
    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "project_name" {
  description = "Project Name"
}
