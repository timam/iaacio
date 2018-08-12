variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_1" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "public_subnet_2" {
  description = "CIDR for the public subnet"
  default = "10.0.2.0/24"
}


variable "public_subnet_3" {
  description = "CIDR for the public subnet"
  default = "10.0.3.0/24"
}


variable "private_subnet_1" {
  description = "CIDR for the private subnet"
  default = "10.0.11.0/24"
}

variable "private_subnet_2" {
  description = "CIDR for the private subnet"
  default = "10.0.12.0/24"
}

variable "private_subnet_3" {
  description = "CIDR for the private subnet"
  default = "10.0.13.0/24"
}


variable "db_subnet_1" {
  description = "CIDR for the private subnet"
  default = "10.0.21.0/24"
}


variable "db_subnet_2" {
  description = "CIDR for the private subnet"
  default = "10.0.22.0/24"
}

variable "db_subnet_3" {
  description = "CIDR for the private subnet"
  default = "10.0.23.0/24"
}
