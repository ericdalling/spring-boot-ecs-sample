resource "aws_security_group" "alb_sg" {
  name_prefix = "${var.app_name}-${lower(var.environment)}-alb-sg"
  vpc_id = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb_sg_ingress_80" {
  security_group_id = "${module.ecs-service.alb_sg_id}"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  type              = "ingress"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_sg_egress_docker_ephemeral_port_range" {
  security_group_id = "${aws_security_group.alb_sg.id}"
  from_port         = "${var.docker_ephemeral_from_port}"
  to_port           = "${var.docker_ephemeral_to_port}"
  protocol          = "tcp"
  type              = "egress"

  source_security_group_id = "${data.terraform_remote_state.ecs-cluster.sg_id}"
}

resource "aws_security_group_rule" "cluster_ingress_ephemeral_port_range" {
  security_group_id = "${data.terraform_remote_state.ecs-cluster.sg_id}"
  from_port = "${var.docker_ephemeral_from_port}"
  to_port = "${var.docker_ephemeral_to_port}"
  protocol = "tcp"
  type = "ingress"

  source_security_group_id = "${aws_security_group.alb_sg.id}"
}

resource "aws_alb" "alb" {
  name = "${lower(var.app_name)}-${lower(var.environment)}-alb"
  internal = "${var.alb_internal}"
  subnets         = ["${var.alb_subnets}"]
  security_groups = ["${aws_security_group.alb_sg.id}"]
}

resource "aws_alb_target_group" "alb_target_group" {
  name = "${lower(var.app_name)}-${lower(var.environment)}"
  port = "${var.alb_target_group_port}"
  protocol = "${var.alb_target_group_protocol}"
  vpc_id = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path = "${var.alb_health_check_path}"
    port = "${var.alb_health_check_port}"
    protocol = "${var.alb_health_check_protocol}"
    interval = "${var.alb_health_check_interval}"
    healthy_threshold = "${var.alb_healthy_threshold}"
    unhealthy_threshold = "${var.alb_unhealthy_threshold}"
    matcher = "${var.matcher}"
  }

  depends_on = [
    "aws_alb.alb"
  ]
}

resource "aws_alb_listener" "alb_80_listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type = "forward"
  }
}