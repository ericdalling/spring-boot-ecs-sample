output "repository_url" {
  value = "${replace(aws_ecr_repository.docker-repository.repository_url, "https://", "")}"
}

output "repository_name" {
  value = "${aws_ecr_repository.docker-repository.name}"
}

output "repository_id" {
  value = "${aws_ecr_repository.docker-repository.id}"
}