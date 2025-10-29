output "vpc_id" {
  description = "VPC id"
  depends_on  = [module.networking]
  value       = module.networking.vpc_id
}
output "private_subnet_ids" {
  description = "Private subent id's"
  depends_on  = [module.networking]
  value       = module.networking.private_subnet_ids
}