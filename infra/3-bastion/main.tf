resource "aws_security_group" "bastion_sg" {
  name        = "rhel-bastion-sg"
  description = "Allow SSH ingress from specific CIDR and egress to peered VPCs"
  vpc_id      = data.aws_vpc.primary.id

  ingress {
    description = "SSH from local machine"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_my_ip_cidr]
  }

  egress {
    description = "Allow all outbound traffic to peered VPCs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rhel-bastion-sg"
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.rhel9.id
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnet.public.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion.key_name

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "rhel-bastion"
  }
}
