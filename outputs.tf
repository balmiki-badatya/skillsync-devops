output "vpc_id" {
  description = "VPC id"
  depends_on  = [module.networking]
  value       = module.networking.vpc-id
}

output "private_subnet_ids" {
  description = "Private subent id's"
  depends_on  = [module.networking]
  value       = module.networking.private-subnet-ids
}

output "public_subnet_ids" {
  description = "Public subnet id's"
  depends_on  = [module.networking]
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
