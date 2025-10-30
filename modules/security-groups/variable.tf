variable "env" {
  type        = string
  description = "Environment"
}

variable "vpc_details" {
  type        = map(string)
  description = "VPC details like vpc id, CIDR range, etc.."
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for the security group"
}

variable "ssh_ipv4_set" {
  type        = set(string)
  description = "Set of ipv4 address for SSH."
}

variable "port_map" {
  type        = map(number)
  description = "This is created for utility, will be used for ingress and egress"
  default = {
    "ssh"        = 22,
    "http"       = 80,
    "https"      = 443,
    "PostgreSQL" = 5432,
    "all"        = -1
  }
}