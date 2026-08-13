resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion" {
  key_name   = "${var.primary_vpc_name}-bastion-ssh-key"
  public_key = tls_private_key.bastion.public_key_openssh
}

resource "local_file" "bastion_private_key" {
  filename        = "${path.module}/${aws_key_pair.bastion.key_name}.pem"
  content         = tls_private_key.bastion.private_key_pem
  file_permission = "0400"
}
