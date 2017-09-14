terragrunt = {
  terraform {
    source = "../../modules//ecr"

    extra_arguments "common-variables" {
      arguments = [
        "-var-file=../common.tfvars"
      ]
      commands = [
        "apply",
        "plan",
        "import",
        "push",
        "refresh"
      ]
    }
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}