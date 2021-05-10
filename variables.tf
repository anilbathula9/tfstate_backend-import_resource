variable "aws_region" {}
variable "access_key" {}
variable "secret_key" {}
variable "vpc_cidr" {}
variable "azs" {
    description = "azs"
    type = list
    default = [ "us-east-1a", "us-east-1b"]
}
variable "subnet_cidr" {
    description = "subnet_cidrs"
    type = list
    default = [ "10.0.1.0/24", "10.0.2.0/24"]
}
variable "pvtsubnet_cidr" {
    description = "subnet_cidrs"
    type = list
    default = [ "10.0.10.0/24", "10.0.20.0/24"]
}
variable "ec2_ami" {
    type = map 
    description = "region wise AMI's"
    default = {
        us-east-1 = "ami-09e67e426f25ce0d7"  # Ubuntu Server 20.04 LTS (HVM)  
        us-east-2 = "ami-00399ec92321828f5"  # Ubuntu Server 20.04 LTS (HVM)
    }
}
variable "instance_type" {
    type = map 
    default = {
        dev = "t2.nano"
        test = "t2.micro"
    }

}
variable "environment" {}
variable "key" {}
