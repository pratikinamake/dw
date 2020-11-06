############# * VPC.################

resource "aws_vpc" "secondary" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "secondary-vpc "
  }

}

################## * Internet gateway (IGW).###########

resource "aws_internet_gateway" "secondary" {
  vpc_id = aws_vpc.secondary.id
  tags = {
    Name = "secondary-vpc-IG"
  }

}

###############33* Route rule.################

resource "aws_route" "secondary-internet_access" {
  route_table_id         = aws_vpc.secondary.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.secondary.id

}

######### Subnet.#############
resource "aws_subnet" "secondary-az1" {
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "secondary-subnet-1 "
  }

}

######### * Subnet.######################
resource "aws_subnet" "secondary-az2" {
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name = "secondary-subnet-2 "
  }

}

