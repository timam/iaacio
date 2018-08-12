provider "aws" {
  region     = "us-east-1"
}

resource "aws_security_group" "allow-all" {
  name = "terraform-instance-sg"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.terraform-instance.id}"
  allocation_id = "${aws_eip.terraform-instance-elastic-ip.id}"
}

resource "aws_instance" "terraform-instance" {
  ami                    = "ami-4e79ed36"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.allow-all.id}"]
  key_name               = "TimamKeySaifAws"

  user_data = <<-EOF
	#!/bin/bash#!/bin/bash

	EOF

  tags {
    Name = "si-terraform-cluster"
  }
}

resource "aws_eip" "terraform-instance-elastic-ip" {
  vpc = true
}

output "public_ip" {
  value = "${aws_instance.terraform-instance.public_ip}"
}
