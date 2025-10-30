data "aws_availability_zones" "available_az" {
  state = "available"
}

module "networking" {
  source         = "./modules/networking"
  vpc_cidr       = var.vpc_cidr
  vpc_name       = var.vpc_name
  default_region = var.default_region
  default_tags   = local.common_tags
  az_lists       = data.aws_availability_zones.available_az.names
  env            = var.environment
}

module "security_groups" {
  source       = "./modules/security-groups"
  env          = var.environment
  vpc_details  = module.networking.vpc-details
  default_tags = local.common_tags
  ssh_ipv4_set = var.bastion_host_ssh_ips
}

module "ec2" {
  source                     = "./modules/ec2"
  default_tags               = local.common_tags
  sonar_ami                  = var.sonar_ami
  subnet_id                  = module.networking.private-subnet-ids[0]
  domain_name                = var.domain_name
  sonar_instance_type        = var.sonar_instance_type
  sonar_sg_id_list           = tolist(module.security_groups.sonar_sg_id)
  bastion_ami_id             = var.bastion_ami_id
  bastion_subnet_id          = module.networking.public-subnet-ids[1]
  bastion_host_instance_type = var.bastion_instance_type
  bastion_sg_id_list         = tolist(module.security_groups.bastion_host_sg_id)
}