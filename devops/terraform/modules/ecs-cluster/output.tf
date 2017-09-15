output "launch_configuration" {
  value = "${aws_launch_configuration.launch-config.id}"
}

output "sg_id" {
  value = "${aws_security_group.sg.id}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.cluster.name}"
}