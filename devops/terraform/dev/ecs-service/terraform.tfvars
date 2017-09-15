terragrunt = {
  terraform {
    source = "../../modules//ecs-service"

    extra_arguments "common-variables" {
      arguments = [
        "-var-file=../common.tfvars",
        "-var-file=../dev.tfvars"
      ]
      commands = [
        "apply",
        "plan",
        "import",
        "push",
        "refresh",
        "destroy"
      ]
    }
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}

#ECS
desired_count = 1
deployment_minimum_healthy_percent = 50
deployment_maximum_percent = 200

alb_internal = false