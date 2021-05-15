provider "aws" {
    region     = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}
terraform {
  backend "s3" {
    bucket = "experttecho"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
data "aws_vpc" "bathula" {
  id = "vpc-09ce6b5f1ad4c0537"
}

resource "aws_subnet" "bathula_public" {
  vpc_id            = data.aws_vpc.bathula.id
  availability_zone = "us-east-1a"
  cidr_block        = cidrsubnet(data.aws_vpc.bathula.cidr_block, 4, 1)
  tags = {
    "Name" = "bathula_public"
  }
}