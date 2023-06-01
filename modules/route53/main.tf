data "aws_route53_zone" "primary" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  # Z06886031V6MDUVE7YHG7
  name    = var.record_name
  type    = "A"
  #ttl     = 300
  
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
  #records = [aws_eip.lb.public_ip]
}