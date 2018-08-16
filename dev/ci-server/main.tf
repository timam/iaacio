# Define AWS as our provider
provider "aws" {
  region     = "us-east-1"
}

# Defining Security Group - Allowing All Ports
resource "aws_security_group" "ci-server-sg" {
  name = "ci-server-sg"
  vpc_id = "${data.aws_vpc.mavs-vpc.id}"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}

# Configure Dev Instance with proper subnet & vpc
resource "aws_instance" "dev-instance" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t2.micro"
  subnet_id = "${data.aws_subnet.public-us-east-1c.id}"
  vpc_security_group_ids = ["${aws_security_group.ci-server-sg.id}"]
  key_name               = "dev-key"
  user_data = "${data.template_file.user_data.rendered}"

  tags {
    Name = "ci-server"
  }
}


# Alocating Elastic IP
resource "aws_eip" "ci-server-elastic-ip" {
  vpc = true
}


# Associating Elastic IP with dev-instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.dev-instance.id}"
  allocation_id = "${aws_eip.ci-server-elastic-ip.id}"
}

//
//# Adding Record to Route53
//resource "aws_route53_record" "master" {
//  zone_id = "${data.aws_route53_zone.timamio.zone_id}"
//  name    = "ci.dev.timam.io"
//  type    = "A"
//  ttl     = "300"
//  records = ["${aws_eip.ci-server-elastic-ip.public_ip}"]
//}
