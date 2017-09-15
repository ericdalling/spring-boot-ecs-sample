data "template_file" "init" {
  template = "${file("./userdata.sh")}"

  vars {
    ecs_cluster = "${aws_ecs_cluster.cluster.name}"
  }
}

data "aws_ami" "ecs_optimized" {
  most_recent = true
  filter {
    name = "name"
    values = ["*-amazon-ecs-optimized"]
  }
  owners = ["amazon"]
}

resource "aws_launch_configuration" "launch-config" {
  name_prefix = "${var.app_name}-${lower(var.environment)}-launch-config"
  image_id = "${data.aws_ami.ecs_optimized.id}"
  instance_type = "${var.instance_type}"

  user_data = "${data.template_file.init.rendered}"

  security_groups = ["${aws_security_group.sg.id}"]

  key_name = "${var.key_name}"

  iam_instance_profile = "${aws_iam_instance_profile.instance-profile.id}"

  root_block_device {
    volume_type = "${var.root_block_device_volume_type}"
    volume_size = "${var.root_block_device_volume_size}"
    iops = "${var.root_block_device_iops}"
    delete_on_termination = "${var.root_block_delete_on_termination}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudformation_stack" "asg" {
  name = "${lower(var.app_name)}-${lower(var.environment)}-asg"

  template_body = <<EOF
{
  "Resources": {
    "AutoScalingGroup": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "Cooldown": 300,
        "HealthCheckType": "${var.health_check_type}",
        "HealthCheckGracePeriod": "${var.health_check_grace_period}",
        "LaunchConfigurationName": "${aws_launch_configuration.launch-config.name}",
        "MaxSize": "${var.max_size}",
        "MetricsCollection": [
          {
            "Granularity": "1Minute",
            "Metrics": [
              "GroupMinSize",
              "GroupMaxSize",
              "GroupDesiredCapacity",
              "GroupInServiceInstances",
              "GroupPendingInstances",
              "GroupStandbyInstances",
              "GroupTerminatingInstances",
              "GroupTotalInstances"
            ]
          }
        ],
        "MinSize": "${var.min_size}",
        "Tags": [
          {
            "Key": "Name",
            "Value": "${var.app_name}-${lower(var.environment)}",
            "PropagateAtLaunch": true
          }
        ],
        "TerminationPolicies": [
          "OldestLaunchConfiguration",
          "OldestInstance",
          "Default"
        ],
        "VPCZoneIdentifier": ${jsonencode(var.vpc_zone_identifier)}
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "${var.min_size}",
          "MaxBatchSize": "1",
          "PauseTime": "${var.pause_time}",
          "WaitOnResourceSignals": "false"
        }
      }
    }
  },
  "Outputs": {
    "AsgName": {
      "Description": "The name of the auto scaling group",
      "Value": {
        "Ref": "AutoScalingGroup"
      }
    }
  }
}
EOF
}

