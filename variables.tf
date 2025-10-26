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