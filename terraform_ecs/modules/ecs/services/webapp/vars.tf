variable "name" {
  type = "string"
  description = "name of task"
}

variable "task_role_arn" {
  type = "string"
  description = "describe your variable"
  default = "arn:aws:iam::349161024290:role/ecsTaskExecutionRole"
}

variable "cpu" {
  type = "string"
  description = "cpu usage of task"
  default = "1024"
}

variable "memory" {
  type = "string"
  description = "memory usage of task"
  default = "512"
}