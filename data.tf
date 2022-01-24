data "aws_ami" "ami_ec2" {
  most_recent      = true
  name_regex       = "base-ec2"
  owners           = ["self"]
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraformbucket021"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "terraformbucket021"
    key    = "vpc/${var.ENV}/alb/terraform.tfstate"
    region = "us-east-1"
  }
}

////here we are trying to get secrets form aws secrets form aws secret manager
data "aws_secretsmanager_secret" "secret" {
  name = "nexus"
}
///// why????
data "aws_secretsmanager_secret_version" "secret-ssh" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}
