data "aws_route53_zone" "site" {
  name         = "shamaila.de."
  private_zone = false
}
