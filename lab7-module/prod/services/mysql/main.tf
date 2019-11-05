module "database_server" {
  source = "../../../module/services/mysql"
  region = "eu-central-1"
  db_name = "terraformDb2"
  username = "terraform"
  instance_class = "db.t2.micro"
}
