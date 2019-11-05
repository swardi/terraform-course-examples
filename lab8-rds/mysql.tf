resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-ctbto"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = var.instance_class
  name                = var.db_name
  username            = var.username
  password            = random_string.db_password.result
}
//
//data "aws_secretsmanager_secret_version" "db_password" {
//  secret_id = "mysql-master-password-stage"
//}

resource "random_string" "db_password" {
  length  = 24
  lower   = true
  upper   = true
  number  = true
  special = false
}
