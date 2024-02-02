provider "aws" {
  profile = "wk-dev"
  region  = "us-east-2"
}

provider "http" {}

data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_default_vpc" "vpc_default" {
  tags = {
    Name = "default"
  }
}

data "aws_availability_zones" "available" {}

data "aws_ami" "ami_amazon_linux_2023" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "sg_my" {
  name   = "My SG"
  vpc_id = aws_default_vpc.vpc_default.id

  dynamic "ingress" {
    for_each = ["80"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["${chomp(data.http.my_public_ip.body)}/32"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My SG"
  }
}

resource "aws_launch_configuration" "lc_my" {
  name            = "My LC"
  image_id        = data.aws_ami.ami_amazon_linux_2023.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg_my]
  user_data       = file("user-data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_my" {
  name                 = "My ASG"
  launch_configuration = aws_launch_configuration.lc_my.name
  max_size             = 2
  min_size             = 2
  min_elb_capacity     = 2
  vpc_zone_identifier  = [aws_default_vpc.default.]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.elb_my.name]

  dynamic "tag" {
    for_each = {
      Name  = "My Webserver in ASG"
      Owner = "Yerkebulan Syzdykov"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true

    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "elb_my" {
  name               = "My ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.sg_my.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    interval            = 10
    target              = "HTTP:80/"
    timeout             = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "My ELB"
  }
}

resource "aws_default_subnet" "subnet_default" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
