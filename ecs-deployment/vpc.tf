resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform VPC"
  }
}

# Allows instances in VPC to communicate to internet 
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

# Public subnet to deploy instances into
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
}

# Points all internet bound traffic to an internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

# Associates route table with subnet
resource "aws_route_table_association" "route_table_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

# Creates security group to specify allowed communication
resource "aws_security_group" "ec2_sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "allow-all-ec2"
  description = "Allows all communications to EC2 instances"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
