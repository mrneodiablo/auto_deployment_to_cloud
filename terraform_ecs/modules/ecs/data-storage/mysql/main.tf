resource "aws_ecs_task_definition" "database" {
  family                = "${var.name}"
  container_definitions = "${file("${path.module}/mysql-container-definition.json")}"
  task_role_arn = "arn:aws:iam::349161024290:role/ecsTaskExecutionRole"
  network_mode = "awsvpc"
  requires_compatibilities = [ "EC2" ]
  cpu = "${var.cpu}"
  memory = "${var.memory}"
}

