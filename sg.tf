resource "aws_security_group" "sg-ec2" {
  name        = "${var.COMPONENT}}-sg-public"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description      = "HTTP"
    from_port        = var.APP_PORT
    to_port          = var.APP_PORT
    protocol         = "tcp"
    cidr_blocks      = data.terraform_remote_state.vpc.outputs.PRIVATE_CIDR
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = concat(data.terraform_remote_state.vpc.outputs.PRIVATE_CIDR,tolist([data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]))
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.COMPONENT}}-sg-public"
  }
}