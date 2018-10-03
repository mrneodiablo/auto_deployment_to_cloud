output "arn-database-tasks" {
  value = "${aws_ecs_task_definition.database.arn}"
}
