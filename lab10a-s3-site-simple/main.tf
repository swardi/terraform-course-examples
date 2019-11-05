provider "aws" {
  region = var.region
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
    error_document = "index.html"
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

#this is different than bucket_domain_name which is for general http access to bucket
#you can create a cname record to this endpoint on your DNS provider to use custom domain
output "website_url" {
  value = aws_s3_bucket.www_site.website_endpoint
}
