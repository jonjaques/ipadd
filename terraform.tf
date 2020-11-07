terraform {
  required_version = "~> 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.13.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
  }

  # backend "remote" {
  #   hostname     = "app.terraform.io"
  #   organization = "jaquesco"

  #   workspaces {
  #     name = "ipadd"
  #   }
  # }
}
