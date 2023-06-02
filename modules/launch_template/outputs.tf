output "lt_id" {
    value = aws_launch_template.lt.id
    description = "Returns Launch Template ID"
}

output "backend_sg_id" {
    value = aws_security_group.allow_tls.id
    description = "Returns the EC2 Backend web server ID"
}