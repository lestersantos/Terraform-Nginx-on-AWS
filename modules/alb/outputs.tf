output "alb_dns_name" {
    value = aws_lb.alb.dns_name
    description = "The DNS name of the Application Load Balancer"
}

output "alb_zone_id" {
    value = aws_lb.alb.zone_id
    description = "Application Load Balancer Hosted zone ID. (to be used in a Route 53 Alias record)."
}

output "alb_sg_id" {
    value = aws_security_group.lb_sg.id
    description = "Id of the security group of the Application Load Balancer"
}