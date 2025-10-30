terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
  backend "s3" {
  }
}