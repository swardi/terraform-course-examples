provider "aws" {
  region  = var.region
}

provider "random" {
}

terraform {
  required_version = ">= 0.12.10"

  backend "s3" {
    bucket = "terraform-backend2"

    key = "lab10/rds/terraform.tfstate"

    region = "eu-central-1"

    encrypt = "true"
  }
}
