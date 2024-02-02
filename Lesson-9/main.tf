provider "aws" {
  profile = "wk-dev"
  region  = "us-east-2"
}

data "aws_vpc" "vpc_default" {
  tags = {
    Name = "default"
  }
}

output "default_vpc_id" {
  value = data.aws_vpc.vpc_default.id
}

output "default_vpc_cidr" {
  value = "Default VPC CIDR block is ${ data.aws_vpc.vpc_default.cidr_block }"
}
