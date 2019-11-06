module "elb" {
  source = "../../../module/services/elb"

  instance_type = "t2.micro"
  port = 80
  region = "eu-central-1"
}
