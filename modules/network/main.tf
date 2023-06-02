# Locals
locals {
  mytags ={
    Name = "${var.project_name}"
    Env = var.environment == "qa" ? "Es qa" : var.environment
    Owner = "Lester Santos"
  }
}

#Data source
# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# Create a VPC
resource "aws_vpc" "ls-vpc" {
  cidr_block = var.vpc_cidr
  tags = merge(local.mytags, {Name = "${local.mytags.Name}-vpc"})
  enable_dns_hostnames = true
}

# Create an Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ls-vpc.id

  tags = merge(local.mytags, {Name = "${local.mytags.Name}-IGW"})
}


# Allocate an EllasticIP
resource "aws_eip" "ls-ei" {
  vpc = true
  tags = merge(local.mytags, {Name = "${local.mytags.Name}-EIP"})
}

# # Create a NAT gateway

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.ls-ei.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(local.mytags, {Name = "${local.mytags.Name}-NATGW"})

  # tags = {
  #   Name = "LS trr NAT gateway"
  # }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# Create a subnet

#Public subnets
resource "aws_subnet" "public" {
  count = 2 #makes this resource an array
  vpc_id     = aws_vpc.ls-vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr,8,count.index)
  # availability_zone = "us-east-2a"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(local.mytags, {Name = "${local.mytags.Name}-pb-${cidrsubnet(var.vpc_cidr,8,count.index)}"})
}


#Private subnets
resource "aws_subnet" "private" {
  count = 2
  vpc_id     = aws_vpc.ls-vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr,8,count.index + length(aws_subnet.public))
  # availability_zone = "us-east-2a"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(local.mytags, {Name = "${local.mytags.Name}-pv-${cidrsubnet(var.vpc_cidr,8,count.index + length(aws_subnet.public))}"})
}

# Create a Public Route Table

resource "aws_route_table" "RT-public" {
  vpc_id = aws_vpc.ls-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  # tags = {
  #   Name = "Lester terraform public rt"
  # }
  tags = merge(local.mytags, {Name = "${local.mytags.Name} public rt"})
}

# Create a Private Route Table
resource "aws_route_table" "RT-private" {
  vpc_id = aws_vpc.ls-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

  # tags = {
  #   Name = "Lester terraform private rt"
  # }
  tags = merge(local.mytags, {Name = "${local.mytags.Name} private rt"})
}

# Create a route table association for public subnets on aws
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.RT-public.id
}

# Create a route table association for private subnets 
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.RT-private.id
}
