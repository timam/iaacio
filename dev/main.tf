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

# Finding CentOS 7 AMI
data "aws_ami" "centos" {
  most_recent       = true
  owners            = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }

}

data "template_file" "user_data" {
  template = "${file("user-data.sh")}"
}

# Defining Security Group - Allowing All Ports
resource "aws_security_group" "allow-all" {
  name = "dev-instance-sg"
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

# Configure Dev Instance with proper subnet & vpc
resource "aws_instance" "dev-instance" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t2.micro"
  subnet_id = "${data.aws_subnet.public-us-east-1c.id}"
  vpc_security_group_ids = ["${aws_security_group.allow-all.id}"]
  key_name               = "dev-key"
  user_data = "${data.template_file.user_data.rendered}"

  tags {
    Name = "dev-instance"
  }
}

# Alocating Elastic IP
resource "aws_eip" "dev-instance-elastic-ip" {
  vpc = true
}

# Associating Elastic IP with dev-instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.dev-instance.id}"
  allocation_id = "${aws_eip.dev-instance-elastic-ip.id}"
}