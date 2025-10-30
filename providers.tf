provider "aws" {
  # Configuration options
  region = var.default_region
}

provider "local" {}