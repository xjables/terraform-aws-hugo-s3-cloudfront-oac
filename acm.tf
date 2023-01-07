locals {
  route53_zone = var.route53_zone != "" ? var.route53_zone : var.cert_domain
}

# Data toggle for acm certificate
resource "aws_acm_certificate" "hugo" {
  count = var.create_cert ? 1 : 0

  domain_name       = var.cert_domain
  validation_method = "DNS"

  subject_alternative_names = var.cert_SNIs
}

data "aws_acm_certificate" "hugo" {
  domain = var.create_cert ? aws_acm_certificate.hugo[0].domain_name : var.cert_domain
}

data "aws_route53_zone" "this" {
  count = var.create_cert ? 1 : 0

  name         = local.route53_zone
  private_zone = false
}

resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.hugo[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  ttl             = 60
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this[0].zone_id
}

resource "aws_acm_certificate_validation" "hugo" {
  count = var.create_cert ? 1 : 0

  certificate_arn         = data.aws_acm_certificate.hugo.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}
