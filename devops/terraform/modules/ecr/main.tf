provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_ecr_repository" "docker-repository" {
  name = "${var.ecr_repository_name}"
}