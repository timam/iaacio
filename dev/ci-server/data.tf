
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


# Finding CentOS 7 AMI
data "aws_ami" "centos" {
  most_recent       = true
  owners            = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }

}


# Load startup script
data "template_file" "user_data" {
  template = "${file("user-data.sh")}"
}