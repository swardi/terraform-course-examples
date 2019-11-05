resource "aws_security_group" "instance" {
  name = "terraform-example-instance2"

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "helloWorld" {
  ami = "ami-01e8fb9918c3b3eb2"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  tags = {
    Name = "helloWorld"
  }
}

