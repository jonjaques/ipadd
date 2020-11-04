variable region { default = "us-east-2" }
variable vpc_id {}
variable subnet_id {}
variable allowed_cidrs {}
variable name {}
variable ami_id { default = "ami-03657b56516ab7912" }
variable instance_type { default = "t3.micro" }

terraform {
  required_version = "~> 0.13"
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.13.0"
    }
    
    tls = {
      source = "hashicorp/tls"
      version = "3.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "tls" {}

resource "tls_private_key" "deployer" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  key_name   = "${var.name}-deployment"
}

resource "aws_key_pair" "deployer" {
  key_name   = local.key_name
  public_key = tls_private_key.deployer.public_key_openssh
}

resource "aws_security_group" "acl" {
  name        = "${var.name}-acl"
  description = "ACL for ${var.name}"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from allowed_cidrs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-acl"
  }
  
  depends_on = [aws_key_pair.deployer]
}

resource "aws_instance" "ipadd" {
  ami           = var.ami_id
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id = var.subnet_id
  monitoring = true
  ebs_optimized = true
  key_name = local.key_name
  vpc_security_group_ids = [aws_security_group.acl.id]
  user_data = <<EOF
#cloud-config
write_files:
- content: |
    Hello World!
  path: /home/ec2-user/hello_world
runcmd:
- echo "start"
- echo `date` > startup
EOF
  
  tags = {
    Name = "${var.name}-dev"
  }
}
