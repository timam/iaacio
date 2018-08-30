data "aws_vpc" "mavs-vpc" {
  filter {
    name = "tag:Name"
    values = ["mavs-vpc"]
  }
}

data "aws_route53_zone" "timamio" {
  name         = "timam.io."
}

data "template_file" "user_data" {
  template = "${file("user-data.sh")}"
}

data "aws_subnet" "public-us-east-1c" {
  filter {
    name = "tag:Name"
    values = ["10.0.3.0-public-us-east-1c"]
  }
}