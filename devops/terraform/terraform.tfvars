terragrunt = {
  # Configure Terragrunt to use DynamoDB for locking
  lock = {
    backend = "dynamodb"
    config {
      aws_region = "us-west-2"
      state_file_id = "spring-boot-ecs-sample_${path_relative_to_include()}"
    }
  }
  # Configure Terragrunt to automatically store tfstate files in S3
  remote_state = {
    backend = "s3"
    config {
      encrypt = "true"
      bucket = "eric-terraform-remote-state"
      key = "spring-boot-ecs-sample/${path_relative_to_include()}/terraform.tfstate"
      region = "us-west-2"
    }
  }
}