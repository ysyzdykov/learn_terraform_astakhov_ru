provider "aws" {
  profile = "wk-dev"
  region  = "us-east-2"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "default"
  }
}

resource "aws_instance" "ec2_my_webserver" {
  ami                    = "ami-0b59bfac6be064b78"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_my_webserver.id]

  user_data = file("user-data.sh")

  tags = {
    Name = "My Webserver"
  }
}

resource "aws_security_group" "sg_my_webserver" {
  name   = "My WebServer SG"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
