provider "aws" {
    region     = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
      Name = "anil"
    }
}
resource "aws_subnet" "public" {
    count = length(var.subnet_cidr)
    vpc_id = aws_vpc.vpc.id
    availability_zone = element(var.azs, count.index)
    cidr_block = element(var.subnet_cidr, count.index)
    map_public_ip_on_launch = true
    tags = {
      "Name" = "public_subnet ${count.index + 1}"
    }
}
resource "aws_subnet" "private" {
    count = length(var.pvtsubnet_cidr)
    vpc_id = aws_vpc.vpc.id
    availability_zone = element(var.azs, count.index)
    cidr_block = element(var.pvtsubnet_cidr, count.index)
    # map_public_ip_on_launch = true
    tags = {
      "Name" = "private_subnet ${count.index + 1}"
    }
}
resource "aws_route_table" "public_routetable" {
    vpc_id = aws_vpc.vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.IG.id
    }
    tags = {
      "Name" = "public_routetable"
    }
}
resource "aws_route_table" "private_routetable" {
    vpc_id = aws_vpc.vpc.id

    #route {
      # cidr_block = "0.0.0.0/0"
      # gateway_id = aws_internet_gateway.IG.id
    #}
    tags = {
      "Name" = "private_routetable"
    }
}
resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      "Name" = "anil_IGW"
    }
}
resource "aws_route_table_association" "route_table_association" {
    count = length(var.subnet_cidr)
    route_table_id = aws_route_table.public_routetable.id
    subnet_id = element(aws_subnet.public[*].id, count.index) # slat syntax
}
resource "aws_route_table_association" "pvtroute_table_association" {
    count = length(var.pvtsubnet_cidr)
    route_table_id = aws_route_table.private_routetable.id
    subnet_id = element(aws_subnet.private[*].id, count.index) # slat syntax
}
resource "aws_security_group" "SG" {
    vpc_id      = aws_vpc.vpc.id

    ingress {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [ "0.0.0.0/0" ]  #[aws_vpc.vpc.cidr_block]
    }
    ingress {
      description      = "TLS from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = [ "0.0.0.0/0" ]  #[aws_vpc.vpc.cidr_block]
    }


    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
      Name = "allow_tls"
    }
}