resource "aws_ecs_task_definition" "http-app-task" {
  family = "${var.name}"
  container_definitions = "${file("${path.module}/app-container-definitions.json")}"
  task_role_arn = "${var.task_role_arn}"
  network_mode = "awsvpc"
  requires_compatibilities = [ "EC2" ]
  cpu = "${var.cpu}"
  memory = "${var.memory}"
}


