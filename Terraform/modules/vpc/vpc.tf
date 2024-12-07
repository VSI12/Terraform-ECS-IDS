# VPC
resource "aws_vpc" "ids-vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ids-vpc"
  }
}
# Internet Gateway to give the VPC internet access
resource "aws_internet_gateway" "ids-vpc-igw" {
  vpc_id = aws_vpc.ids-vpc.id

  tags = {
    Name = "ids-igw"
  }
}