data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["${var.role_identifiers}"]
    }

    effect = "Allow"
    sid    = ""
  }
}

resource "aws_iam_role" "role" {
  name = "${var.app_name}-${lower(var.environment)}-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume-role-policy.json}"
}

resource "aws_iam_instance_profile" "instance-profile" {
  name = "${var.app_name}-${lower(var.environment)}-instance-profile"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy_attachment" "ecs_for_ec2_role" {
  role = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}