variable "default_tags" {
  description = "Default tags"
  type        = map(string)
}

variable "default_region" {
  type        = string
  description = "AWS default region"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "skillsync-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "az_list" {
  type        = set(string)
  description = "Number of subnets to create under the VPC."
}

variable "env" {
  type        = string
  default     = "ppe"
  description = "Environment name."
}