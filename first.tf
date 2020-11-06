############ * VPC.########################
resource "aws_vpc" "primary" {
  cidr_block = "172.30.0.0/16"
  tags = {
    Name = "first vpc "
  }
}



########### * Internet gateway (IGW).######################

resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id
  tags = {
    Name = "primary gateway "
  }

}

######### * Route rule.############################

resource "aws_route" "primary-internet_access" {
  route_table_id         = aws_vpc.primary.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary.id
}

############### * Subnet.########################

resource "aws_subnet" "primary-az1" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "172.30.131.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-2a"
  tags = {
    Name = "primary-subnet-1 "
  }

}

############# * Subnet.#######################

resource "aws_subnet" "primary-az2" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "172.30.132.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-2b"
  tags = {
    Name = "primary-subnet-2"
  }

}

#####################elastic ip###############333

resource "aws_eip" "elasticsearch" {
  vpc = true

}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.elasticsearch.id
  subnet_id     = aws_subnet.primary-az2.id
  tags = {
    Name = "NAT IG "
  }

}

########### * Security group.######################33

resource "aws_security_group" "primary-default" {
  name_prefix = "default-"
  description = "Default security group for all instances in VPC ${aws_vpc.primary.id}"
  vpc_id      = aws_vpc.primary.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      aws_vpc.primary.cidr_block,
      aws_vpc.secondary.cidr_block,
    ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

