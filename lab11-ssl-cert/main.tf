provider "aws" {
  region = var.region
}

resource "aws_acm_certificate" "cert" { // certificate request
  domain_name       = "test.shamaila.de"
  subject_alternative_names = ["www.test.shamaila.de"]
  validation_method = "DNS" //Only one validation method supported at the moment
}

data "aws_route53_zone" "zone" {
  name         = "shamaila.de."
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = [
    aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_alt1" {
  name    = aws_acm_certificate.cert.domain_validation_options[1].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[1].resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = [
    aws_acm_certificate.cert.domain_validation_options[1].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" { // Virtual resource
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    aws_route53_record.cert_validation.fqdn,
    aws_route53_record.cert_validation_alt1.fqdn
  ]
}

output "certificate_arn" {
  value = aws_acm_certificate_validation.cert.certificate_arn
}
