

provider "aws" {
    region      = "eu-central-1"
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



