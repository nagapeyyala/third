terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc"
  }
}
#creating first subnet
resource "aws_subnet" "subnet01" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subnet01_cidr
  availability_zone = var.az_sub01
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet01"
  }
}
#creating second subnet
resource "aws_subnet" "subnet02" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subnet02_cidr
  availability_zone = var.az_sub02
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet02"
  }
}

#creating internet gateway
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myigw"
  }
}
#creating route table 
resource "aws_route_table" "myrt01" {
  vpc_id = aws_vpc.myvpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myigw.id
}
      tags = {
         Name = "myrt01"
      }
}
resource "aws_route_table_association" "subasso1" {
  subnet_id      = aws_subnet.subnet01.id
  route_table_id = aws_route_table.myrt01.id
}

#creating route table association 
resource "aws_route_table_association" "subasso2" {
  subnet_id      = aws_subnet.subnet02.id
  route_table_id = aws_route_table.myrt01.id
}
#creating security groups
resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "Allow ssh and http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id
  tags = {
    Name = "mysg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allowssh" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allowhttp" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.mysg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "terraform1" {
   ami = var.aws_ami 
   instance_type = var.aws_instance_type
   key_name = var.aws_keypair
   subnet_id = aws_subnet.subnet01.id
   vpc_security_group_ids = [aws_security_group.mysg.id]
   user_data = "${file("web.sh")}"
   tags = { 
      Name = "terraform1"
   }
      
} 
