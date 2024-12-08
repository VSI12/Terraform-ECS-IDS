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

# VPC Endpoints (ECR, DKR, CloudWatch Logs, S3)
resource "aws_vpc_endpoint" "ecr-endpoint" {
  vpc_id              = aws_vpc.ids-vpc.id
  service_name        = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private-a.id, aws_subnet.private-b.id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    name = "ECR-endpoint"
  }
}

resource "aws_vpc_endpoint" "dkr-endpoint" {
  vpc_id              = aws_vpc.ids-vpc.id
  service_name        = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private-a.id, aws_subnet.private-b.id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    name = "DKR-endpoint"
  }
}

resource "aws_vpc_endpoint" "logs-endpoint" {
  vpc_id              = aws_vpc.ids-vpc.id
  service_name        = "com.amazonaws.us-east-1.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private-a.id, aws_subnet.private-b.id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    name = "cloudwatchlogs-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3-gateway" {
  vpc_id            = aws_vpc.ids-vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.ids-private-rt.id]

  tags = {
    Name = "s3-gateway-endpoint"
  }
}

