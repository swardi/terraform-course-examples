data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"

  config {
    bucket = "terraform-backend2"
    key    = "lab12/ecs_cluster/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "terraform-backend2"
    key    = "lab10/vpc/terraform.tfstate"
    region = var.region
  }
}
