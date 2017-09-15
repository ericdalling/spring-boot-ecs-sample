#Common Variables
aws_region = "us-west-2"
app_name = "spring-boot-ecs-sample"

#Remote State
remote_state_s3_bucket = "eric-terraform-remote-state-storage"
remote_ecr_s3_key = "spring_boot/global/ecr/terraform.tfstate"

ecr_repository_name = "spring-boot-ecs-sample"

ecs_service_iam_role = "arn:aws:iam::589147405124:role/ecsServiceRole"