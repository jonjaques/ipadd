locals {
  domain_name          = "${var.name}.${var.route53_wildcard_domain}"
  wildcard_domain_name = "*.${var.route53_wildcard_domain}"
  dns_validation_ops   = aws_acm_certificate.this.domain_validation_options
}

resource "aws_acm_certificate" "this" {
  domain_name       = local.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.route53_zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "acm" {
  for_each = {
    for dvo in local.dns_validation_ops : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

data "aws_subnet" "this" {
  for_each = toset(var.subnet_ids)
  id       = each.value
}

# resource "aws_eip" "ipadd" {
# instance = aws_instance.ipadd.id
# vpc      = true
# }

# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "example.com"
#   type    = "A"
#   records
# }
