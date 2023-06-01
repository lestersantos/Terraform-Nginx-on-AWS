output "route53_record" {
    value = aws_route53_record.record.name
    description = "The name of the record"
}
