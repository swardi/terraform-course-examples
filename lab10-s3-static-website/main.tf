provider "aws" {
  region = var.region
}

provider "aws" {
  alias = "aws-cert-region"
  region = "us-east-1"
}

resource "aws_s3_bucket" "logs" {
  region = var.region
  bucket = "${var.site_name}-site-logs"
  acl = "log-delivery-write"
}

resource "aws_s3_bucket" "www_site" {
  region = var.region
  bucket = "www.${var.site_name}"
  logging {
    target_bucket = aws_s3_bucket.logs.bucket
    target_prefix = "www.${var.site_name}/"
  }
  website {
    index_document = "index.html"
  }
}

##
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" { //connect CF plus s3
  comment = "cloudfront origin access identity"
}

## Read the already issued certificates
data "aws_acm_certificate" "cert" {
  provider = "aws.aws-cert-region"
  domain   = "${var.site_name}"
  statuses = ["ISSUED"]
  most_recent = true
}

resource "aws_cloudfront_distribution" "website_cdn" {
  enabled      = true
  price_class  = "PriceClass_200"
  http_version = "http1.1"
  aliases = ["www.${var.site_name}"]
  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.www_site.id}"
    domain_name = "www.${var.site_name}.s3.${var.region}.amazonaws.com"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = "origin-bucket-${aws_s3_bucket.www_site.id}"
    min_ttl          = "0"
    default_ttl      = "300"                                              //3600
    max_ttl          = "1200"                                             //86400
    // This redirects any HTTP request to HTTPS. Security first!
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn #"arn:aws:acm:us-east-1:807383789153:certificate/0b255193-8726-405e-a582-2f9ec8d72c8e"
    ssl_support_method       = "sni-only"
  }
}

##
resource "aws_route53_record" "www_site" {
  zone_id = data.aws_route53_zone.site.zone_id
  name = "www.${var.site_name}"
  type = "A"
  alias {
    name = aws_cloudfront_distribution.website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}


variable "content-types" {
  type = "map"

  default = {
    html = "text/html"
    js = "application/javascript"
    css = "text/css"
  }
}


resource "aws_s3_bucket_object" "site_files" {
  for_each = fileset("${path.module}/website", "**")

  bucket = aws_s3_bucket.www_site.bucket
  key    = each.value
  source = "${path.module}/website/${each.value}"
  content_type = lookup(var.content-types, split(".", each.value)[length(split(".", each.value)) - 1 ], "binary/octet-stream")
  acl = "public-read" # see https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
}
