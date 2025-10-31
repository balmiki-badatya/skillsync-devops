locals {
  az_count = length(var.az_lists)

  private_subnet_cidr = [for index in range(local.az_count) : cidrsubnet(aws_vpc.skillsync-vpc.cidr_block, 4, index)]
  public_subnet_cidr  = [for idx in range(local.az_count) : cidrsubnet(aws_vpc.skillsync-vpc.cidr_block, 6, (local.az_count + idx + 20))]
  default_routes = {
    "internet_ipv4"        = "0.0.0.0/0",
    "internet_egress_only" = "::/0",
    "vpc_route"            = aws_vpc.skillsync-vpc.cidr_block
  }
}

resource "aws_vpc" "skillsync-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  region               = var.default_region
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({
    Name = var.vpc_name
    },
    var.default_tags
  )

}

resource "aws_subnet" "private-subnets" {
  count             = local.az_count
  vpc_id            = aws_vpc.skillsync-vpc.id
  cidr_block        = local.private_subnet_cidr[count.index]
  availability_zone = var.az_lists[count.index]
  tags = merge({
    Name = "${var.env}-private-subnet-${count.index + 1}"
    },
    var.default_tags
  )
}

resource "aws_subnet" "public-subnets" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.skillsync-vpc.id
  cidr_block              = local.public_subnet_cidr[count.index]
  availability_zone       = var.az_lists[count.index]
  map_public_ip_on_launch = true
  tags = merge({
    Name = "${var.env}-public-subnet-${count.index + 1}"
    },
    var.default_tags
  )
}

############################ public internet access configuration ###########################
resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.skillsync-vpc.id
  depends_on = [aws_vpc.skillsync-vpc]
  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.skillsync-vpc.id
  tags = merge({
    Name = "${var.env}-public-rt-1"
    },
    var.default_tags
  )
}

resource "aws_route_table_association" "public-subnet-association" {
  count          = length(aws_subnet.public-subnets[*].id)
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public-route-table.id
  depends_on     = [aws_subnet.public-subnets]
}

resource "aws_route" "public-internet-ipv4-route" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = lookup(local.default_routes, "internet_ipv4", "")
  gateway_id             = aws_internet_gateway.igw.id
}

################################################################################################
######################################## Internet config for private ###########################
resource "aws_nat_gateway" "ngw" {
  subnet_id         = aws_subnet.public-subnets[0].id
  allocation_id     = aws_eip.eip.id
  connectivity_type = "public"
  tags = merge({
    Name = "${var.env}-ngw"
  }, var.default_tags)

  depends_on = [aws_internet_gateway.igw, aws_eip.eip]

}

resource "aws_eip" "eip" {
  domain = "vpc"
  tags = merge({
    Name = "${var.env}-eip"
    },
    var.default_tags
  )
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.skillsync-vpc.id

  tags = merge({
    Name = "${var.env}-private-rt-1"
  }, var.default_tags)
}

resource "aws_route_table_association" "private-subnet-association" {
  count          = length(aws_subnet.private-subnets[*].id)
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private-route-table.id
  depends_on     = [aws_subnet.private-subnets]
}

resource "aws_route" "vpc-private-route" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = lookup(local.default_routes, "internet_ipv4", var.vpc_cidr)
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

