provider "aws" {
  region     = "${var.aws_region}" //AWS Credentials picked up from ~/.aws/credentials
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.app_name}-${var.environment}"
}