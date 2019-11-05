resource "aws_db_instance" "default" {
  identifier           = var.db_name
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.4"
  instance_class       = var.instance_class
  name                 = var.db_name
  username             = var.username
  password             = random_string.db_password.result
  db_subnet_group_name = aws_db_subnet_group.default.id
  parameter_group_name = aws_db_parameter_group.default.id
  publicly_accessible  = true
  skip_final_snapshot  = true

  vpc_security_group_ids = [
    aws_security_group.default.id]

  tags = {
    "Name" = var.db_name
  }
}

resource "random_string" "db_password" {
  length  = 24
  lower   = true
  upper   = true
  number  = true
  special = false
}



data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "vpc_subnet_ids" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = data.aws_subnet_ids.vpc_subnet_ids.ids

  tags = {
    "Name" = "${var.db_name} subnet group"
  }
}

resource "aws_db_parameter_group" "default" {
  name   = var.db_name
  family = "postgres10"

  # Enable logging
  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name = "log_min_duration_statement"

    # in milliseconds
    value = "1000"
  }

  tags = {
    "Name" = "Postgres param group for ${var.db_name}"

  }
}
# Security group for controlling access to database
resource "aws_security_group" "default" {
  name        = "${var.db_name} db SG"
  description = "Allow Postgres traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    "Name" = "${var.db_name} db SG"
  }
}

resource "aws_security_group_rule" "allow_ingress" {
  type        = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = [data.aws_vpc.default.cidr_block]

  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_egress" {
  type        = "egress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = [data.aws_vpc.default.cidr_block]

  security_group_id = aws_security_group.default.id
}

//resource "aws_key_pair" "ssh_key" {
//  key_name   = "tf_ssh_key_rds_example"
//  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
//}
//
//resource "aws_instance" "bastion_host" {
//  ami = ""
//  instance_type = ""
//  associate_public_ip_address = true
//  key_name = aws_key_pair.ssh_key.key_name
//  security_groups = []
//}
