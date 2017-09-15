provider "aws" {
  region = "${var.aws_region}"
}

data "template_file" "task-definitions" {
  template = "${file("task-definitions/sample.json")}"

  vars {
    region = "${var.aws_region}"
    repo = "${data.terraform_remote_state.ecr.repository_url}"
    version = "${var.docker_image_version}"
    container_name = "${var.container_name}"
    container_port = "${var.container_port}"
    app_name = "${lower(var.app_name)}"
    env = "${var.environment}"
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  family = "${var.app_name}-${var.environment}"
  container_definitions = "${data.template_file.task-definitions.rendered}"

  task_role_arn = "${aws_iam_role.role.arn}"
}

data "aws_iam_role" "ecs_service_iam_role" {
  name = "${var.ecs_service_iam_role}"
}

resource "aws_ecs_service" "ecs_service" {
  name =  "${var.app_name}-${var.environment}"
  task_definition = "${aws_ecs_task_definition.ecs_task.arn}"
  cluster = "${data.terraform_remote_state.ecs-cluster.cluster_name}"
  desired_count = "${var.desired_count}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent = "${var.deployment_maximum_percent}"

  iam_role = "${data.aws_iam_role.ecs_service_iam_role.id}"
  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    container_name = "${var.container_name}"
    container_port = "${var.container_port}"
  }
}