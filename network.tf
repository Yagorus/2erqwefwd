data "aws_availability_zones" "available" {

}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "VPC-terrafrom"
  }
}

resource "aws_subnet" "public" {
  count      =  var.az_count
  vpc_id     =  aws_vpc.main.id
  cidr_block =  cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-public"
  }
}

resource "aws_subnet" "private" {
  count      =  var.az_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + var.az_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "subnet-private"
  }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags = {
    Name = "gw"
  }
}

resource "aws_route" "internet_access" {
    #what vpc use for route
    route_table_id         = aws_vpc.main.main_route_table_id
    #add routes 
    destination_cidr_block = "0.0.0.0/0"
    #define gateway to internet
    gateway_id = aws_internet_gateway.gw.id
}

resource "aws_eip" "gw" {
    count      =  var.az_count
    vpc = true
    depends_on = [aws_internet_gateway.gw] 
    tags = {
    Name = "EIP"
  }
}

resource "aws_nat_gateway" "gateway" {
  count         =  var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gw.*.id, count.index)
  tags = {
    Name = "Public-NAT-gateway"
  }
}


resource "aws_route_table" "private" {
  count         =  var.az_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
  tags = {
    Name = "RT-gateway"
  }
}


resource "aws_route_table_association" "private" {
  count = var.az_count
  subnet_id     = element(aws_subnet.private.*.id, count.index)
  route_table_id =element(aws_route_table.private.*.id, count.index)
}
