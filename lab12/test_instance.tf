resource "aws_launch_configuration" "test" {
  name_prefix = "test-"

  image_id                    = data.aws_ami.amazon_linux.id
  instance_type               = var.bastion_instance_type
  key_name                    = aws_key_pair.bastion.key_name
  associate_public_ip_address = false
  enable_monitoring           = false
  security_groups             = [aws_security_group.test.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "test" {
  name              = "test-asg"
  min_size          = 0
  desired_capacity  = 0
  max_size          = 1
  health_check_type = "EC2"

  launch_configuration = aws_launch_configuration.test.name

  vpc_zone_identifier = aws_subnet.private.*.id
}

resource "aws_security_group" "test" {
  name_prefix = "test SG"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_all_ssh_test" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = aws_subnet.public.*.cidr_block
  security_group_id = aws_security_group.test.id
}

resource "aws_security_group_rule" "allow_all_outbound_test" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test.id
}

resource "aws_security_group_rule" "allow_ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.test.id}"
}
