output "vpc_id" {
  description = "VPC id"
  value       = module.networking.vpc-details.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.networking.vpc-details.vpc_cidr
}

output "private_subnet_ids" {
  description = "Private subent id's"
  value       = module.networking.private-subnet-ids
}

output "public_subnet_ids" {
  description = "Public subnet id's"
  value       = module.networking.public-subnet-ids
}

output "internet_gateway_id" {
  description = "Internet Gateway id"
  value       = module.networking.internet-gateway-id
}

output "public_route_table_id" {
  description = "public route table id"
  value       = module.networking.public-route-table-id
}

output "private_route_table_id" {
  description = "Private route table id"
  value       = module.networking.private-route-table-id
}

output "elasic_ip_id" {
  description = "Elastic IP id"
  value       = module.networking.elatic-ip-id
}

output "nat-gateway-id" {
  description = "NAT Gateway id"
  value       = module.networking.nat-gateway-id
}

output "sonar_security_grou_id" {
  description = "Sonar SG id"
  value       = module.security_groups.sonar_sg_id
}

output "bastion_host_security_group_id" {
  description = "Bastion host security group id"
  value       = module.security_groups.bastion_host_sg_id
}

output "ec2_sonar_server_details" {
  description = "SONAR server ec2 instance details"
  value       = module.ec2.sonar_server_instance_details
}

output "ec2_bastion_host_details" {
  description = "Bastion host ec2 instance details"
  value       = module.ec2.bastion_host_instance_details
}