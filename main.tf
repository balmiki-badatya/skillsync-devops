module "networking" {
  source         = "./modules/networking"
  vpc_cidr       = var.vpc_cidr
  vpc_name       = var.vpc_name
  default_region = var.default_region
  default_tags   = var.common_tags
}