output "dns_name" {
    value = aws_lb.alb.dns_name
    description = "The DNS name of the Application Load Balancer"
}


output "alb_sg_id" {
    value = aws_security_group.lb_sg.id
    description = "Id of the security group of the Application Load Balancer"
}