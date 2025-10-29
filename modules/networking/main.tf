locals {
  az_count = length(var.az_lists)

  private_subnet_cidr = [for index in range(local.az_count) : cidrsubnet(aws_vpc.skillsync-vpc.cidr_block, 4, index)]
  public_subnet_cidr  = [for idx in range(local.az_count) : cidrsubnet(aws_vpc.skillsync-vpc.cidr_block, 6, (local.az_count + idx + 20))]
  default_routes = {
    "internet_ipv4"        = "0.0.0.0/0",
    "internet_egress_only" = "::/0",
    "vpc_route"            = aws_vpc.skillsync_vpc.cidr_block
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
  count             = local.az_count
  vpc_id            = aws_vpc.skillsync-vpc.id
  cidr_block        = local.public_subnet_cidr[count.index]
  availability_zone = var.az_lists[count.index]
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

resource "aws_route" "public-internet-ipv4-route" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = lookup(local.default_routes, "internet_ipv4", "")
  gateway_id             = aws_internet_gateway.igw.id
}

################################################################################################
######################################## Internet config for private ###########################
# resource "aws_nat_gateway" "example" {
#   subnet_id     = aws_subnet.public-subnets[0].id
#   tags = merge({
#     Name = "${var.env}-ngw"
#   }, var.default_tags)

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.igw]
# }



resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.skillsync-vpc.id

  tags = merge({
    Name = "${var.env}-private-rt-1"
  }, var.default_tags)
}


# resource "aws_route" "vpc-private-route" {
#   route_table_id            = aws_route_table.private-route-table.id
#   destination_cidr_block    = lookup(local.default_routes, "vpc_route", var.vpc_cidr)

# }

