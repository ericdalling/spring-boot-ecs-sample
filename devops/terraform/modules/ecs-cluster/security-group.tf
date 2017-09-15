resource "aws_security_group" "sg" {
  name_prefix = "${var.app_name}-${lower(var.environment)} asg security group"
  vpc_id = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_egress_all" {
  security_group_id = "${aws_security_group.sg.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  type              = "egress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]

  lifecycle {
    create_before_destroy = true
  }
}