data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "terraform-backend2"
    key    = "lap10/vpc/terrafrom.tfstate"
    region = var.region
  }
}
