
provider "aws" {
  region = var.region
}

provider "tls" {}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}