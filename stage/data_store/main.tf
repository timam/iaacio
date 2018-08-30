# Define AWS as our provider
provider "aws" {
  region     = "us-east-1"
}

# Collecting VPC ID
data "aws_vpc" "mavs-vpc" {
  filter {
    name = "tag:Name"
    values = ["mavs-vpc"]
  }
}

# Define DB Security Groupgit
resource "aws_security_group" "swin-rds-sg" {
  name = "swin-rds-sg"

  description = "RDS postgres servers (terraform-managed)"
  vpc_id = "${data.aws_vpc.mavs-vpc.id}"

  # Allow only mysql within vpc only
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define swin-rds
resource "aws_db_instance" "swin-rds" {
  allocated_storage        = 10
  backup_retention_period  = 7
  db_subnet_group_name     = "db-subnet"

  engine                   = "mysql"
  engine_version           = "5.7"
  instance_class           = "db.t2.micro"
  multi_az                 = false
  port                     = 3306
  identifier               = "swin-rds"
  name                     = "swindb"

  username                 = "foo"
  password                 = "foobarbaz"
  parameter_group_name     = "default.mysql5.7"
  publicly_accessible      = false

  storage_encrypted        = false
  storage_type             = "gp2"
  vpc_security_group_ids   = ["${aws_security_group.swin-rds-sg.id}"]

  final_snapshot_identifier = "final-swin-snapshot"
}


######################################################################################################
## db_subnet_group_name     = "db-subnet#                                                           ##
## password                 = "${trimspace(file("${path.module}/secrets/mydb1-password.txt"))}"     ##
######################################################################################################
