variable "default_region" {
  description = "Default region for the AWS provider"
  default     = "us-west-1"
}

variable "account_name" {
  description = "AWS account name"
  default     = "SkillSync"
}

variable "created_by" {
  description = "Default created by field value"
  default     = "GitHub Actions"
}

locals {
  common_tags = {
    region      = var.default_region,
    application = var.account_name,
    created_by  = var.created_by,
    managed_by  = "Terraform"
  }
}

variable "vpc_cidr" {
  description = "VPC cidr block"
  type        = string
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "environment" {
  type        = string
  description = "Environment (dev, stage, prod)"
  default     = "dev"
}

variable "sonar_ami" {
  type        = string
  description = "AMI for sonar server"
}

variable "domain_name" {
  type        = string
  description = "Domain Name"
}

variable "sonar_instance_type" {
  type        = string
  description = "SONAR instance type"
}

variable "bastion_ami_id" {
  type        = string
  description = "Bastion host ami id"
}

variable "bastion_instance_type" {
  type        = string
  description = "Bastion host instance type"
}

variable "bastion_host_ssh_ips" {
  type        = set(string)
  description = "Ip to login to bastion host via SSH"
}
