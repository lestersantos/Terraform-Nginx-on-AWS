variable "alb_dns_name" {
  description = "Application Load Balancer DNS name"
}

variable "alb_zone_id" {
  description = "Application Load Balancer Hosted zone ID"
}

variable "hosted_zone_name" {
  description = "Route53 Hosted Zone Name"
}

variable "record_name" {
  description = "Route53 Hosted Zone new Record Name"
}