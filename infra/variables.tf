variable allowed_cidrs {}
variable ami_id { default = "ami-0a91cd140a1fc148a" }
variable github_token {}
variable github_owner {}
variable instance_type { default = "t3.medium" }
variable name {}
variable region { default = "us-east-2" }
variable route53_wildcard_domain {}
variable route53_zone_id {}
variable subnet_ids {}
variable vpc_id {}

locals {
  user            = var.github_owner
  instance_subnet = var.subnet_ids[0]
  key_name        = "${var.name}-deployment"
  key_contents    = "${tls_private_key.deployer.private_key_pem}${tls_private_key.deployer.public_key_pem}"
}

resource "random_password" "user_pass" {
  length           = 24
  special          = true
  override_special = "_^@*%()"
}

output "public_ip" {
  value = aws_instance.ipadd.public_ip
}

output "key_pem" {
  sensitive = true
  value     = local.key_contents
}

output "hostname" {
  value = local.domain_name
}

output "user_pw" {
  sensitive = true
  value     = random_password.user_pass.result
}

output "url" {
  value = "https://${local.domain_name}"
}
