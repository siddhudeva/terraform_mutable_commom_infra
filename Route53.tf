resource "aws_route53_record" "private_alb" {
  count = var.LB_PRIVATE
  zone_id = aws_route53_zone.primary.zod
  name    = "www.example.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.lb.public_ip]
}