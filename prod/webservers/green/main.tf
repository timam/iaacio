provider "aws" {
  region     = "us-east-1"
}

resource "aws_launch_configuration" "auto_launch_config" {
  name_prefix = "${var.domain_name}-tf"
  image_id        = "${var.ami_id}"
  user_data              = "${data.template_file.user_data.rendered}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.stage-instance-sg.id}"]
//  iam_instance_profile = "${aws_iam_instance_profile.iam_instance_profile.id}"
  key_name = "${var.keypair}"
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "auto_scale_group" {
  name = "${var.domain_name}-tf"
  launch_configuration = "${aws_launch_configuration.auto_launch_config.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]
  target_group_arns = ["${aws_alb_target_group.elb-tg.arn}"]
  health_check_type = "EC2"
  default_cooldown= 180
  health_check_grace_period =  30
  vpc_zone_identifier = ["${data.aws_subnet.public-us-east-1c.id}", "${data.aws_subnet.public-us-east-1b.id}"]
  min_size = 2
  max_size = 2

  tag {
    key                 = "Name"
    value               = "${var.domain_name}-tf"
    propagate_at_launch = true
  }
}

resource "aws_alb" "elb-tg" {
  name            =       "${var.domain_name}-tg"
//  internal        =       true
  security_groups =       ["${aws_security_group.stage-elb-sg.id}"]
  subnets         =       ["${data.aws_subnet.public-us-east-1c.id}", "${data.aws_subnet.public-us-east-1b.id}"]
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "elb-tg" {
  name    = "${var.domain_name}-tf"
  vpc_id  = "${data.aws_vpc.mavs-vpc.id}"
  port    = "80"
  protocol        = "HTTP"
  deregistration_delay = 30
  health_check {
    path = "/"
    port = "80"
    protocol = "HTTP"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 5
    timeout = 4
    matcher = "200"
  }
}


resource "aws_alb_listener" "elb-listener" {
  load_balancer_arn       =       "${aws_alb.elb-tg.arn}"
  port                    =       "80"
  protocol                =       "HTTP"
//  ssl_policy              =       "ELBSecurityPolicy-2016-08"
//  certificate_arn         =       "${var.certificate_arn}"
  default_action {
    target_group_arn        =       "${aws_alb_target_group.elb-tg.arn}"
    type                    =       "forward"
  }
}