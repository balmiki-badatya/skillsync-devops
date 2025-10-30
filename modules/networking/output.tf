output "vpc-details" {
  description = "AWS vpc id"
  value = {
    vpc_id   = aws_vpc.skillsync-vpc.id,
    vpc_cidr = aws_vpc.skillsync-vpc.cidr_block
  }
}

output "private-subnet-ids" {
  description = "Private subnet id's"
  value       = aws_subnet.private-subnets[*].id
}

output "public-subnet-ids" {
  description = "Public subnet id's"
  value       = aws_subnet.public-subnets[*].id
}

output "internet-gateway-id" {
  description = "Internet Gateway id"
  value       = aws_internet_gateway.igw.id
}

output "public-route-table-id" {
  description = "Public route table id"
  value       = aws_route_table.public-route-table.id
}

output "private-route-table-id" {
  description = "Private route table id"
  value       = aws_route_table.private-route-table.id
}

output "elatic-ip-id" {
  description = "Elastic Ip id"
  value       = aws_eip.eip.id
}

output "nat-gateway-id" {
  description = "NAT Gateway id"
  value       = aws_nat_gateway.ngw.id
}