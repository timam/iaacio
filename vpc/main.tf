# Define AWS as our provider
provider "aws" {
  region = "${var.aws_region}"
}


# Define VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
 
  tags {
    Name = "mavs-vpc"
  }
}

# Define Public Subnets
resource "aws_subnet" "public-subnet1" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_1}"
  availability_zone = "us-east-1a"
 
  tags {
    Name = "10.0.1.0-public-us-east-1a"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_2}"
  availability_zone = "us-east-1b"
 
  tags {
    Name = "10.0.2.0-public-us-east-1b"
  }
}

resource "aws_subnet" "public-subnet3" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_3}"
  availability_zone = "us-east-1c"
 
  tags {
    Name = "10.0.3.0-public-us-east-1c"
  }
}


# Define Private Subnets
resource "aws_subnet" "private-subnet1" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_1}"
  availability_zone = "us-east-1a"
 
  tags {
    Name = "10.0.11.0-private-us-east-1a"
  }
}


resource "aws_subnet" "private-subnet2" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_2}"
  availability_zone = "us-east-1b"

  tags {
    Name = "10.0.12.0-private-us-east-1b"
  }
}


resource "aws_subnet" "private-subnet3" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_3}"
  availability_zone = "us-east-1c"
 
  tags {
    Name = "10.0.13.0-private-us-east-1c"
  }
}


# Define DB Subnets
resource "aws_subnet" "db-subnet1" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.db_subnet_1}"
  availability_zone = "us-east-1a"
 
  tags {
    Name = "10.0.21.0-db-subnet-us-east-1a"
  }
}

resource "aws_subnet" "db-subnet2" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.db_subnet_2}"
  availability_zone = "us-east-1b"
 
  tags {
    Name = "10.0.22.0-db-subnet-us-east-1b"
  }
}

resource "aws_subnet" "db-subnet3" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.db_subnet_3}"
  availability_zone = "us-east-1c"

  tags {
    Name = "10.0.23.0-db-subnet-us-east-1c"
  }
}



# Define Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"
 
  tags {
    Name = "mavs-vpc-igw"
  }
}


# Define Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.default.id}"
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
 
  tags {
    Name = "public-subnet-route-tabel"
  }
}
 
# Assign Route Table to Public Subnets
resource "aws_route_table_association" "public-rt1" {
  subnet_id = "${aws_subnet.public-subnet1.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "public-rt2" {
  subnet_id = "${aws_subnet.public-subnet2.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "public-rt3" {
  subnet_id = "${aws_subnet.public-subnet3.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}


# Define DB Subnet
resource  "aws_db_subnet_group" "db-subnet" {
  name       = "db-subnet"
  subnet_ids = ["${aws_subnet.db-subnet1.id}", "${aws_subnet.db-subnet2.id}"]

  tags {
    Name = "mavs-db-subnet"
  }
}
