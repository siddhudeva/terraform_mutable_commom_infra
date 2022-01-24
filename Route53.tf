resource "aws_route53_record" "private_alb" {
  count = var.LB_PRIVATE
  zone_id = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTEDZONE_ID
  name    = "${var.COMPONENT}-${var.ENV}.roboshop.internal"
  type    = "A"
  ttl     = "300"
  records = data.terraform_remote_state.alb.outputs.PUBLIC_LB_DNSNAME
}