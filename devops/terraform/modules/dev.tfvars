environment = "dev"

#Remote State
remote_ecs_cluster_s3_key = "spring_boot/dev/ecs-cluster/terraform.tfstate"

vpc_id = "vpc-dd71e9bb"
alb_subnets= [
  "subnet-fb41e99d",
  "subnet-46bec11d",
  "subnet-9bb57cd3"
]