variable region { default = "us-east-2" }
variable vpc_id {}
variable subnet_id {}
variable allowed_cidrs {}
variable name {}

# Arch Linux
# https://www.uplinklabs.net/projects/arch-linux-on-ec2/
# LTS x86_64 ebs
variable ami_id { default = "ami-043b666ec218ceb75" }

# Amazon Linux
# variable ami_id { default = "ami-03657b56516ab7912" }
variable instance_type { default = "t3.micro" }

variable src_dir { default = "code" }
variable dest_dir { default = "/home/coder" }

locals {
  key_name = "${var.name}-deployment"
}

output "public_ip" {
  value = aws_instance.ipadd.public_ip
}

output "key_pem" {
  value = "${tls_private_key.deployer.private_key_pem}${tls_private_key.deployer.public_key_pem}"
}

output "ssh_access" {
  value = "ssh -i ~/.ssh/ipadd.pem arch@${aws_instance.ipadd.public_ip}"
}
