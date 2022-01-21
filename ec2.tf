resource "aws_spot_instance_request" "ec2-spot" {
  count                = var.INSTANCES_NO
  ami                  = data.aws_ami.ami_ec2.id
  instance_type        = var.INSTANCES_TYPE
  wait_for_fulfillment = "true"
  tags = {
    Name = "${var.COMPONENT}-${var.ENV}-${count.index + 1}"
  }
  security_groups = [aws_security_group.sg-ec2.id]
  subnet_id = data.terraform_remote_state.vpc.outputs.private_subnet[count.index]
}


resource "aws_ec2_tag" "spot-ec2" {
  count       = length(aws_spot_instance_request.ec2-spot)
  resource_id = aws_spot_instance_request.ec2-spot.*.spot_instance_id[count.index]
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}-${count.index + 1}"
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.ENV}-${var.COMPONENT}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}
resource "aws_lb_target_group_attachment" "tg-attach" {
  count            = length(aws_spot_instance_request.ec2-spot)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_spot_instance_request.ec2-spot.*.spot_instance_id[count.index]
  port             = 80
}
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = data.terraform_remote_state.alb.outputs.alb_public_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}