provider "aws" {
  region = "eu-central-1"
}
terraform {
  required_version = ">= 0.12.10"

  backend "s3" {
    bucket = "terraform-backend2"
    key = "lab4/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = "true"
  }
}
