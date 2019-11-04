resource "aws_s3_bucket" "main" {
  bucket = "terraform-backend"
  acl    = "private"

  tags = {
    Name        = "Bucket for TFState"
    Environment = "Dev"
  }
}
