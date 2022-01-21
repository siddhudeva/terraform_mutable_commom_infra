resource "null_resource" "app-deploy" {
  count = length(aws_spot_instance_request.ec2-spot)
  connection {
    type     = "ssh"
    user     = local.SSH_USERNAME
    password = local.SSH_PASSWD
    host     = aws_spot_instance_request.ec2-spot.*.private_ip[count.index]
  }

  provisioner "remote-exec" {
    inline = [
      "ansible-pull -U https://github.com/siddhudeva/ansible-1.git roboshop-pull.yml -e COMPONENT=${var.COMPONENT} -e ENV=${var.ENV} -e APP_VERSION=${var.APP_VERSION} -e NEXUS_USERNAME=${local.NEXUS_USERNAME} -e NEXUS_PASSWORD=${local.NEXUS_PASSWD} "
    ]
  }
}
locals {
  SSH_USERNAME = jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["SSH_USERNAME"]
  SSH_PASSWD = jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["SSH_PASSWD"]
  NEXUS_USERNAME = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["NEXUS_USERNAME"])
  NEXUS_PASSWD = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["NEXUS_PASSWD"])

}