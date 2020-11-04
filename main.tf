variable region {}
variable vpc_id {}
variable subnet_id {}
variable allowed_cidrs {}
variable name {}
variable keyname {}

terraform {
  version = "~> 0.13"
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.13.0"
    }
  }
}

provider "aws" {
  region = var.region
}
