provider "aws" {
  region = "eu-central-1"
}
terraform {
  required_version = ">= 0.12.12"

  backend "s3" {
    bucket = "terraform-backend"
    key = "lab3/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = "true"
  }
}
