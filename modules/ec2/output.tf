output "sonar_server_instance_details" {
  description = "Sonar host server details"
  value = {
    instance_id       = aws_instance.sonar.id,
    security_group_id = aws_instance.sonar.security_groups,
    instance_state    = aws_instance.sonar.instance_state
  }
}

output "bastion_host_instance_details" {
  description = "Bastion host instance details"
  value = {
    instance_id        = aws_instance.bastion_host.id,
    security_group_ids = aws_instance.bastion_host.security_groups,
    instance_state     = aws_instance.bastion_host.instance_state
  }
}