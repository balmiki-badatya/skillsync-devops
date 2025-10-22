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