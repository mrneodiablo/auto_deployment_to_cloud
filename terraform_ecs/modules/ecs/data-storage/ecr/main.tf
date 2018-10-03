resource "aws_ecr_repository" "http-api-server" {
  name = "${var.name}"
}
