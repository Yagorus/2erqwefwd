provider "aws" {
    region      = var.aws_region
    access_key  = "AKIA26XYZMMBHL25FWER"
    secret_key  = "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"
}

data "aws_availability_zones" "available" {

}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "terraform-vpc-test"
  }
}

resource "aws_subnet" "public" {
  count      =  1
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "subnet-public"
  }
}

resource "aws_subnet" "private" {
  count      =  1
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "subnet-private"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
      Name = "Internet-gateway"
  }
}

resource "aws_route" "internet_access" {
    #what vpc use for route
  route_table_id         = aws_vpc.main.main_route_table_id
    #add routes 
  destination_cidr_block = "0.0.0.0/0"
    #define gateway to internet
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_eip" "gw" {
  count = 1
  vpc = true
  depends_on = [aws_internet_gateway.gw] 
  tags = {
    Name = "EIP"
  }

}

resource "aws_nat_gateway" "gateway" {
  count         = 1
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gw.*.id, count.index)
  tags = {
    Name = "Public-NAT-gateway"
  }
}

resource "aws_route_table" "private" {
  count = "1" 
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
  tags = {
    Name = "RT-gateway"
  }
}

resource "aws_route_table_association" "private" {
  count = "1"
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.private[count.index].id
}
