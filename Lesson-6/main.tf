provider "aws" {
  profile = "wk-dev"
  region  = "us-east-2"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "default"
  }
}

resource "aws_eip" "eip_my_webserver" {
  instance = aws_instance.ec2_my_webserver.id
}

resource "aws_instance" "ec2_my_webserver" {
  ami                    = "ami-0d406e26e5ad4de53"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_my_webserver.id]

  user_data = templatefile("user-data.sh.tpl", {
    f_name = "Denis",
    l_name = "Astahov",
    names  = ["Vasia", "Petia", "Masha"]
  })

  tags = {
    Name = "My Webserver"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "sg_my_webserver" {
  name   = "My WebServer SG"
  vpc_id = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My WebServer SG"
  }
}
