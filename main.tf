data "aws_availability_zones" "available_az" {
  state = "available"
}

module "networking" {
  source         = "./modules/networking"
  vpc_cidr       = var.vpc_cidr
  vpc_name       = var.vpc_name
  default_region = var.default_region
  default_tags   = local.common_tags
  az_list        = data.aws_availability_zones.available_az.names
}