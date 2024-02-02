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
  tags                   = {
    Name = "My Webserver"
  }

  user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
echo "Lalafa" /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
EOF
}

resource "aws_security_group" "sg_my_webserver" {
  name   = "My WebServer SG"
  vpc_id = aws_default_vpc.default.id

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
}
