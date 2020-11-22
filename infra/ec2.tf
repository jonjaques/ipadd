locals {
  user_data = templatefile("${path.module}/templates/cloud-config.yaml", {
    USER         = local.user
    USER_PASS    = random_password.user_pass.result
    USER_PUB_KEY = jsonencode(tls_private_key.deployer.public_key_openssh)
  })
}

resource "aws_instance" "ipadd" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = local.instance_subnet
  monitoring                  = true
  ebs_optimized               = true

  key_name               = local.key_name
  vpc_security_group_ids = [aws_security_group.acl.id]

  user_data = local.user_data

  tags = {
    Name = "${var.name}-dev"
  }
}

resource "aws_ebs_volume" "ipadd" {
  availability_zone = data.aws_subnet.this[local.instance_subnet].availability_zone
  size              = 100
  encrypted         = false
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ipadd.id
  instance_id = aws_instance.ipadd.id
}
