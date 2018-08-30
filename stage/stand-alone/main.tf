# Define AWS as our provider
provider "aws" {
  region     = "us-east-1"
}


# Collecting "mavs-vpc" ID
data "aws_vpc" "mavs-vpc" {
  filter {
    name = "tag:Name"
    values = ["mavs-vpc"]
  }
}


# Collecting "public-us-east-1c" ID
data "aws_subnet" "public-us-east-1c" {
  filter {
    name = "tag:Name"
    values = ["10.0.3.0-public-us-east-1c"]
  }
}


#Find Route53 Hosted Zone ID
data "aws_route53_zone" "timamio" {
  name         = "timam.io."
}

# Load startup script
data "template_file" "user_data" {
  template = "${file("user-data.sh")}"
}


# Defining Security Group - Allowing All Ports
resource "aws_security_group" "allow-all" {
  name = "stage-instance-sg"
  vpc_id = "${data.aws_vpc.mavs-vpc.id}"

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


# Configure Stage Instance with proper subnet & vpc
resource "aws_instance" "stage-instance" {
  ami                    = "ami-0d34c8b4564f31f43"
  instance_type          = "t2.micro"
  subnet_id = "${data.aws_subnet.public-us-east-1c.id}"
  vpc_security_group_ids = ["${aws_security_group.allow-all.id}"]
  key_name               = "rtr"
  user_data = "${data.template_file.user_data.rendered}"

  tags {
    Name = "stage-instance"
  }
}


# Alocating Elastic IP
resource "aws_eip" "stage-instance-elastic-ip" {
  vpc = true
}


# Associating Elastic IP with stage-instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.stage-instance.id}"
  allocation_id = "${aws_eip.stage-instance-elastic-ip.id}"
}

# Adding Record to Route53
resource "aws_route53_record" "master" {
  zone_id = "${data.aws_route53_zone.timamio.zone_id}"
  name    = "stage.fiesta.timam.io"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.stage-instance-elastic-ip.public_ip}"]
}
