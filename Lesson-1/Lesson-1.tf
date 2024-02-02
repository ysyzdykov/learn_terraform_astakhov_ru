provider "aws" {
  profile = "wk-dev"
  region  = "us-east-2"
}

resource "aws_instance" "my_ubuntu" {
  ami           = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  count         = 1
  tags          = {
    Name    = "UbuntuTest"
    Owner   = "Yerkebulan Syzdykov"
    Project = "Terraform lessons"
  }
}
