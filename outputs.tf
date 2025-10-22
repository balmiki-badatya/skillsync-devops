output "vpc_id" {
  description = "VPC id"
  depends_on  = [module.networking]
  value       = module.networking.vpc_id
}