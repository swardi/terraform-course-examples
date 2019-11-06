provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 0.12.10"

  backend "s3" {
    bucket  = "terraform-backend2"
    key     = "lab12/ecs_cluster/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = "true"
  }
}
