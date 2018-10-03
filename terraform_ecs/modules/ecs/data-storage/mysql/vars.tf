variable "name" {
  type = "string"
  description = "name of mysql task"
}

variable "cpu" {
  type = "string"
  description = "cpu usage of task"
  default = "1024"
}

variable "memory" {
  type = "string"
  description = "memory usage of task"
  default = "default_value"
}