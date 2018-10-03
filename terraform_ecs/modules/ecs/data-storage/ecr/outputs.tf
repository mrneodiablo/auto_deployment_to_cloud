output "repo-http-api-server" {
  value = "${aws_ecr_repository.http-api-server.repository_url}"
}
