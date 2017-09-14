data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    effect = "Allow"
    sid    = ""
  }
}

resource "aws_iam_role" "role" {
  name_prefix = "${lower(var.app_name)}-${lower(var.environment)}-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume-role-policy.json}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "instance-profile" {
  name_prefix = "${lower(var.app_name)}-${lower(var.environment)}-instance-profile"
  roles = [
    "${aws_iam_role.role.name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}