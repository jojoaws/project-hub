data "aws_ami" "amazon_linux_2023" {

  most_recent = true

  owners = ["amazon"]

  filter {

    name = "name"

    values = ["al2023-ami-*-x86_64"]

  }

}

resource "aws_security_group" "bastion" {

  name = "${var.project_name}-bastion-sg"

  description = "Bastion security group"

  vpc_id = module.networking.vpc_id

  ingress {

    description = "SSH"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["98.97.76.102/32"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "${var.project_name}-bastion-sg"

  }

}

resource "aws_instance" "bastion" {

  ami = data.aws_ami.amazon_linux_2023.id

  instance_type = "t3.micro"

  subnet_id = module.networking.public_subnet_a_id

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  key_name = "cloud-mastery"

  associate_public_ip_address = true

  tags = {

    Name = "${var.project_name}-bastion"

  }

}
