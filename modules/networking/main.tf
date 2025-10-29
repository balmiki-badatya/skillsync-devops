locals {
  az_count = length(var.az_lists)

  private_subnet_cidr = [for index in range(local.az_count) : cidrsubnet(aws_vpc.skillsync_vpc.cidr_block, 4, index)]
  public_subnet_cidr  = [for idx in range(local.az_count) : cidrsubnet(aws_vpc.skillsync_vpc.cidr_block, 6, (local.az_count + idx + 1))]
}

resource "aws_vpc" "skillsync_vpc" {
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

resource "aws_subnet" "private_subnets" {
  count             = local.az_count
  vpc_id            = aws_vpc.skillsync_vpc.id
  cidr_block        = local.private_subnet_cidr[count.index]
  availability_zone = var.az_lists[count.index]
  tags = merge({
    Name = "${var.env}-private-subnet-${count.index + 1}"
    },
    var.default_tags
  )
}

resource "aws_subnet" "public_subnets" {
  count             = local.az_count
  vpc_id            = aws_vpc.skillsync_vpc.id
  cidr_block        = local.public_subnet_cidr[count.index]
  availability_zone = var.az_lists[count.index]
  tags = merge({
    Name = "${var.env}-public-subnet-${count.index}"
    },
    var.default_tags
  )
}