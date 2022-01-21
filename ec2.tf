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
