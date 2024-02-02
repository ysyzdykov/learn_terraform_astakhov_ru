provider "aws" {
  profile = "wk-dev"
  region  = "us-east-2"
}

data "aws_ami" "ami_amazon_linux_2023" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

output "ami_amazon_linux_2023_id" {
  value = data.aws_ami.ami_amazon_linux_2023.id
}

output "ami_amazon_linux_2023_name" {
  value = data.aws_ami.ami_amazon_linux_2023.name
}
