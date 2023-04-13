### -- VPC --
resource "aws_vpc" "main" {
  cidr_block = var.cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.name}-main"
  }
}

### -- Public Subnet --
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = merge({
    Name = "${var.name}-public-${count.index + 1}"
  },
  var.public_subnet_tags
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-main"
  }
}

resource "aws_eip" "nat_gateway" {
    count = var.single_nat_gateway ? 1 : length(var.public_subnets)
    vpc = true
    depends_on = [aws_vpc.main]

    tags = {
        Name = "${var.name}-main"
    }
}

resource "aws_nat_gateway" "primary" {
    count = var.single_nat_gateway ? 1 : length(var.public_subnets)
    subnet_id = element(aws_subnet.public.*.id, count.index)
    allocation_id = element(aws_eip.nat_gateway.*.id, count.index)  
    tags = {
        Name = "${var.name}-primary-${count.index + 1}"
    }
}

resource "aws_route_table" "public_subnet" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "${var.name}-public-subnet"
    }
}

resource "aws_route_table_association" "public_subnet" {
  count = length(var.azs)
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_subnet.id
}

### -- Private Subnet --
resource "aws_subnet" "private" {
  count             = length(var.azs)
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  vpc_id            = aws_vpc.main.id

  tags = merge({
    Name = "${var.name}-private-${count.index + 1}"
  },
  var.private_subnet_tags
  )
}

resource "aws_route_table" "private_subnet" {
    count = length(var.private_subnets) # Each NAT Gateway will have a corresponding route table in private subnets
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = element(aws_nat_gateway.primary.*.id, count.index)
    }

    tags = {
        Name = "${var.name}-private-subnet-${count.index}"
    }
}

resource "aws_route_table_association" "private_subnet" {
  count = length(var.azs)
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private_subnet.*.id, count.index)
}