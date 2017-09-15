#Common Variables
variable "app_name" {}
variable "aws_region" {}
variable "environment" {}

#Remote State
variable "remote_state_s3_bucket" {}
variable "remote_ecs_cluster_s3_key" {}
variable "remote_ecr_s3_key" {}

#ALB
variable "vpc_id" {}
variable "alb_subnets" {type = "list"}
variable "alb_target_group_protocol" {default = "HTTP"}
variable "alb_target_group_port" { default = 80}
variable "alb_health_check_protocol" {default = "HTTP"}
variable "alb_health_check_port" {default = "traffic-port"}
variable "alb_health_check_path" {default = "/"}
variable "alb_health_check_interval" {default = 30}
variable "alb_healthy_threshold" {default = 5}
variable "alb_unhealthy_threshold" {default = 2}
variable "docker_ephemeral_from_port" {default = 32768}
variable "docker_ephemeral_to_port" {default = 65535}
variable "alb_internal" {default = true}
variable "deregistration_delay" {default = 300}
variable "matcher" {default = "200"}

#ECS
variable "docker_image_version" {default = "latest"}
variable "desired_count" {}
variable "deployment_minimum_healthy_percent" {}
variable "deployment_maximum_percent" {}
variable "container_name" {default = "spring-boot-ecs-sample"}
variable "container_port" {default = 8080}
variable "ecs_service_iam_role" {default = "ecsServiceRole"}
