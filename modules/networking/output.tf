output "vpc_id" {
  description = "AWS vpc id"
  value       = aws_vpc.skillsync_vpc.id
  depends_on  = [aws_vpc.skillsync_vpc]
}

output "private_subnet_ids" {
  description = "Private subnet id's"
  value       = aws_subnet.private_subnets[*].id
}

output "public_subnet_ids" {
  description = "Public subnet id's"
  value       = aws_subnet.public_subnets[*].id
}