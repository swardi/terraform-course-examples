provider "aws" {
  region = var.region
}

provider "random" {
}

terraform {

  backend "s3" {
    bucket = "terraform-backend2"
    key = "lab8/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = "true"
  }
}
