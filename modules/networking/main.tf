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
  count             = length(var.az_list)
  vpc_id            = aws_vpc.skillsync_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.skillsync_vpc.cidr_block, 4, count.index)
  availability_zone = count.index
  tags = merge({
    Name = concat("private-subnet-", count.index)
    },
    var.default_tags
  )
}