variable "env" {
  type        = string
  description = "Environment type"
  default     = "dev"
}

variable "domain_name" {
  type        = string
  description = "Domain name, under which domain EC2 instances will be created."
}

variable "sonar_ami" {
  type        = string
  description = "AMI for launching the SonarQube instance"
}

variable "sonar_instance_type" {
  type        = string
  description = "SonarQube Iinstance type"
}

variable "sonar_sg_id_list"{
    type = list
    description = "Security group Id's to attach to SONAR server."

}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for the ec2 instances creaded by Terraform."
}

variable "default_instance_type_map" {
  type = map(string)
  default = {
    "sonar"         = "t2.large",
    "bastion"       = "t2.micro",
    "github_runner" = "t2.large"
  }
}

variable "subnet_id" {
  type        = string
  description = "Subnet Id where the instace will be created."
}

variable "bastion_ami_id" {
  type        = string
  description = "AMI id for Bastion host"
}

variable "bastion_subnet_id" {
  type        = string
  description = "Subnet id for bastion host"
}

variable "bastion_host_instance_type" {
  type        = string
  description = "bastion host instance type"
}

variable "bastion_sg_id_list"{
    type = list(string)
    description = "Bastion host security group id's"
}


