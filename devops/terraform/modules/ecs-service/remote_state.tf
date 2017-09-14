data "terraform_remote_state" "ecs-cluster" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_s3_bucket}"
    key = "${var.remote_ecs_cluster_s3_key}"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_s3_bucket}"
    key = "${var.remote_ecr_s3_key}"
    region = "${var.aws_region}"
  }
}