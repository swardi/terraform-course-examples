provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "helloWorld" {
  ami = "ami-01e8fb9918c3b3eb2"
  instance_type = "t2.micro"

  tags = {
    Name = "helloWorld"
  }
}

