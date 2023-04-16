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
  for_each                = { for index, value in var.public_subnets : value.name => value }
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = merge({
    Name = "${each.value.name}"
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
  for_each   = var.single_nat_gateway ? { for index, value in [var.public_subnets[0]] : value.name => value } : { for index, value in var.public_subnets : value.name => value }
  vpc        = true
  depends_on = [aws_vpc.main]

  tags = {
    Name = "${each.value.name}"
  }
}

resource "aws_nat_gateway" "primary" {
  for_each      = var.single_nat_gateway ? { for index, value in [var.public_subnets[0]] : value.name => value } : { for index, value in var.public_subnets : value.name => value }
  subnet_id     = aws_subnet.public[each.value.name].id
  allocation_id = aws_eip.nat_gateway[each.value.name].id
  tags = {
    Name = "${each.value.name}"
  }
}

resource "aws_route_table" "public_subnet" {
  for_each = { for index, value in var.public_subnets : value.name => value }
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${each.value.name}"
  }
}

resource "aws_route_table_association" "public_subnet" {
  for_each       = { for index, value in var.public_subnets : value.name => value }
  subnet_id      = aws_subnet.public[each.value.name].id
  route_table_id = aws_route_table.public_subnet[each.value.name].id
}

### -- Private Subnet --
resource "aws_subnet" "private" {
  for_each          = { for index, value in var.private_subnets : value.name => value }
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  vpc_id            = aws_vpc.main.id

  tags = merge({
    Name = "${each.value.name}"
    },
    var.private_subnet_tags,
    each.value.tags
  )
}

resource "aws_route_table" "private_subnet" {
  for_each = { for index, value in var.private_subnets : value.name => value }
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.primary[var.public_subnets[0].name].id # Cant not refer to public subnets -> hard code 0 to access first subnet value
  }

  tags = {
    Name = "${each.value.name}"
  }
}

resource "aws_route_table_association" "private_subnet" {
  for_each       = { for index, value in var.private_subnets : value.name => value }
  subnet_id      = aws_subnet.private[each.value.name].id
  route_table_id = aws_route_table.private_subnet[each.value.name].id
}