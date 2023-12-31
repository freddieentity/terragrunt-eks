### -- VPC --
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.name}-main"
  }
}

### -- Public Subnet --
resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = merge({
    Name = "${each.key}"
    },
    var.public_subnet_tags,
    each.value.tags
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-main"
  }
}

resource "aws_eip" "nat_gateway" {
  for_each   = var.public_subnets
  vpc        = true
  depends_on = [aws_vpc.main]

  tags = {
    Name = "${each.key}"
  }
}

resource "aws_nat_gateway" "primary" {
  for_each      = var.public_subnets
  subnet_id     = aws_subnet.public[each.key].id
  allocation_id = aws_eip.nat_gateway[each.key].id
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_route_table" "public_subnet" {
  for_each = var.public_subnets
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${each.key}"
  }
}

resource "aws_route_table_association" "public_subnet" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public_subnet[each.key].id
}

### -- Private Subnet --
resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  vpc_id            = aws_vpc.main.id

  tags = merge({
    Name = "${each.key}"
    },
    var.private_subnet_tags,
    each.value.tags
  )
}

resource "aws_route_table" "private_subnet" {
  for_each = var.private_subnets
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.primary[var.public_subnets[0].name].id
  }

  tags = {
    Name = "${each.key}"
  }
}

resource "aws_route_table_association" "private_subnet" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private_subnet[each.key].id
}