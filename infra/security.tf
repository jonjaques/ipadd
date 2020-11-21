resource "tls_private_key" "deployer" {
  algorithm = "RSA"
  rsa_bits  = 4096
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

  ingress {
    description = "HTTP from allowed_cidrs"
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    description     = "HTTP from LB"
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
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

resource "aws_security_group" "web" {
  name        = "${var.name}-web"
  description = "ACL for ${var.name} web"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from allowed_cidrs"
    from_port   = 443
    to_port     = 443
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
    Name = "${var.name}-web"
  }

  depends_on = [aws_key_pair.deployer]
}
