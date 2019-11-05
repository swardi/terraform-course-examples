provider "aws" {
  region = var.region
}
terraform {
  required_version = ">= 0.12.10"

  backend "s3" {
    bucket = "terraform-backend2"
    key = "lab6/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = "true"
  }
}
