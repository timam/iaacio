# Define AWS as our provider
provider "aws" {
  region = "${var.aws_region}"
}


# Define our VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
 
  tags {
    Name = "test-vpc"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet1" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_1}"
  availability_zone = "us-west-1a"
 
  tags {
    Name = "Public Subnet1"
  }
}


#resource "aws_subnet" "public-subnet2" {
#  vpc_id = "${aws_vpc.default.id}"
#  cidr_block = "${var.public_subnet_2}"
#  availability_zone = "us-west-1b"
 
#  tags {
#    Name = "Public Subnet2"
#  }
#}

resource "aws_subnet" "public-subnet3" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_3}"
  availability_zone = "us-west-1c"
 
  tags {
    Name = "Public Subnet3"
  }
}
 
# Define the private subnet
resource "aws_subnet" "private-subnet1" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_1}"
  availability_zone = "us-west-1a"
 
  tags {
    Name = "Private Subnet1"
  }
}


#resource "aws_subnet" "private-subnet2" {
#  vpc_id = "${aws_vpc.default.id}"
#  cidr_block = "${var.private_subnet_2}"
#  availability_zone = "us-west-1b"
 
#  tags {
#    Name = "Private Subnet2"
#  }
#}


resource "aws_subnet" "private-subnet3" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_3}"
  availability_zone = "us-west-1c"
 
  tags {
    Name = "Private Subnet3"
  }
}



# Define the DB subnet
resource "aws_subnet" "db-subnet1" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.db_subnet_1}"
  availability_zone = "us-west-1a"
 
  tags {
    Name = "db Subnet1"
  }
}

#resource "aws_subnet" "db-subnet2" {
#  vpc_id = "${aws_vpc.default.id}"
#  cidr_block = "${var.db_subnet_2}"
#  availability_zone = "us-west-1b"
 
#  tags {
#    Name = "db Subnet2"
#  }
#}

resource "aws_subnet" "db-subnet3" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.db_subnet_3}"
  availability_zone = "us-west-1c"

  tags {
    Name = "db Subnet3"
  }
}



# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"
 
  tags {
    Name = "VPC IGW"
  }
}



# Define the route table
resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.default.id}"
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
 
  tags {
    Name = "Public Subnet RT"
  }
}
 
# Assign the route table to the public Subnet
resource "aws_route_table_association" "public-rt1" {
  subnet_id = "${aws_subnet.public-subnet1.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}


#resource "aws_route_table_association" "public-rt2" {
#  subnet_id = "${aws_subnet.public-subnet2.id}"
#  route_table_id = "${aws_route_table.public-rt.id}"
#}


resource "aws_route_table_association" "public-rt3" {
  subnet_id = "${aws_subnet.public-subnet3.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}


resource  "aws_db_subnet_group" "db-subnet" {
  name       = "db-subnet"
  subnet_ids = ["${aws_subnet.db-subnet1.id}", "${aws_subnet.db-subnet3.id}"]

  tags {
    Name = "My DB subnet group"
  }
}

