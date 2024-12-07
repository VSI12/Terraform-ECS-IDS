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
# Public Subnets in Different Availability Zones
resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.ids-vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "IDS public-subnet-a"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id            = aws_vpc.ids-vpc.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "IDS public-subnet-b"
  }
}
# Private Subnets in Different Availability Zones
resource "aws_subnet" "private-a" {
  vpc_id            = aws_vpc.ids-vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "IDS private-subnet-a"
  }
}

resource "aws_subnet" "private-b" {
  vpc_id            = aws_vpc.ids-vpc.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "IDS private-subnet-b"
  }
}

# Route table for public subnets
resource "aws_route_table" "ids-public-rt" {
  vpc_id = aws_vpc.ids-vpc.id

  tags = {
    Name = "IDS Public-route-table"
  }
}
resource "aws_route" "ids-public-rt-route" {
  route_table_id         = aws_route_table.ids-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ids-vpc-igw.id
}
resource "aws_route_table_association" "public-subnet-association-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.ids-public-rt.id
}

resource "aws_route_table_association" "public-subnet-association-b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.ids-public-rt.id
}
# Route table for private subnets
resource "aws_route_table" "ids-private-rt" {
  vpc_id = aws_vpc.ids-vpc.id

  tags = {
    Name = "IDS Private-route-table"
  }
}

resource "aws_route_table_association" "private-subnet-association-a" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.ids-private-rt.id
}

resource "aws_route_table_association" "private-subnet-association-b" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.ids-private-rt.id
}

