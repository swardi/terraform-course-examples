resource "aws_s3_bucket" "main" {
  bucket = "terraform-backend2"
  acl    = "private"

  tags = {
    Name        = "Bucket for TFState"
    Environment = "Dev"
  }
}
