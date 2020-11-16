resource "random_password" "user_pass" {
  length  = 20
  special = true
}

resource "aws_instance" "ipadd" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  monitoring                  = true
  ebs_optimized               = true

  key_name               = local.key_name
  vpc_security_group_ids = [aws_security_group.acl.id]

  user_data = templatefile("${path.module}/templates/cloud-config.yaml", {
    SRC_DIR      = var.src_dir
    DEST_DIR     = var.dest_dir
    USER_PASS    = random_password.user_pass.result
    USER_PUB_KEY = jsonencode(tls_private_key.deployer.public_key_pem)
  })

  tags = {
    Name = "${var.name}-dev"
  }
}
