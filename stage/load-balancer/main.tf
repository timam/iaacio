provider "aws" {
  region     = "us-east-1"
}

resource "aws_security_group" "stage-instance-sg" {
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

resource "aws_security_group" "stage-elb-sg" {
  name = "stage-elb-sg"
  vpc_id = "${data.aws_vpc.mavs-vpc.id}"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web" {
  name = "example-elb"
  subnets = ["${data.aws_subnet.public-us-east-1c.id}"]
  security_groups = ["${aws_security_group.stage-elb-sg.id}"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  instances                   = ["${aws_instance.web.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_lb_cookie_stickiness_policy" "default" {
  name                     = "lbpolicy"
  load_balancer            = "${aws_elb.web.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami = "ami-0d34c8b4564f31f43"
  key_name = "rtr"
  vpc_security_group_ids = ["${aws_security_group.stage-instance-sg.id}"]
  subnet_id              = "${data.aws_subnet.public-us-east-1c.id}"
  user_data              = "${data.template_file.user_data.rendered}"

  tags {
    Name = "elb-example"
  }
}

resource "aws_eip" "stage-instance-elastic-ip" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.web.id}"
  allocation_id = "${aws_eip.stage-instance-elastic-ip.id}"
}
