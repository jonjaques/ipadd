variable region { default = "us-east-2" }

variable vpc_id {}

variable subnet_ids {}

variable allowed_cidrs {}

variable name {}

variable route53_wildcard_domain {}

variable route53_zone_id {}

variable ami_id { default = "ami-0a91cd140a1fc148a" }

variable instance_type { default = "t3.micro" }

variable src_dir { default = "code" }

variable dest_dir { default = "/home/coder" }

variable github_token {}

variable github_owner {}

locals {
  user            = "coder"
  instance_subnet = var.subnet_ids[0]
  key_name        = "${var.name}-deployment"
  key_contents    = "${tls_private_key.deployer.private_key_pem}${tls_private_key.deployer.public_key_pem}"
}

resource "random_password" "user_pass" {
  length  = 20
  special = false
}

output "public_ip" {
  value = aws_instance.ipadd.public_ip
}

output "key_pem" {
  value = local.key_contents
}

output "hostname" {
  value = local.domain_name
}

output "user_pw" {
  value = random_password.user_pass.result
}

output "url" {
  value = "https://${local.domain_name}"
}
