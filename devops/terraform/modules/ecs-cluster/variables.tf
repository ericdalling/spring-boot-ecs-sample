#Common
variable "aws_region" {}
variable "app_name" {}
variable "environment" {}

#Remote State
variable "remote_state_s3_bucket" {}

#Health Check
variable "health_check_type" {default = "EC2"}
variable "health_check_grace_period" {default = 300}

#ASG
variable "private_key_path" {default = "~/.ssh/ecs-sample.pem"}
variable "key_name" {default = "ecs-sample"}
variable "asg_terminate_hook_enabled" {default = true}
variable "vpc_id" {default = "vpc-dd71e9bb"}
variable "instance_type" {default = "t2.micro"}
variable "pause_time" {default = "PT0S"}
variable "wait_on_resource_signals" {default = false}
variable "vpc_zone_identifier" {type = "list"
  default = [
    "subnet-fb41e99d",
    "subnet-46bec11d",
    "subnet-9bb57cd3"
  ]}
variable "min_size" {default = 1}
variable "max_size" {default = 2}
variable "root_block_device_volume_type" {default = "gp2"}
variable "root_block_device_volume_size" {default = 8}
variable "root_block_device_iops" {default = 0}
variable "root_block_delete_on_termination" {default = true}

#SG
variable "sg_ingress_custom_rule_enabled" {default = true}
variable "custom_port" { default = 8080}


#Role
variable "role_identifiers" {
  type = "list"

  default = [
    "ec2.amazonaws.com"
  ]
}

