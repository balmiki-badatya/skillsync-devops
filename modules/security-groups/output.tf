output "sonar_sg_id" {
  description = "SONAR security group id"
  value       = aws_security_group.sonar_sg.id
}

output "bastion_host_sg_id" {
  description = "Bastion Host security group id"
  value       = aws_security_group.bastion_sg.id
}