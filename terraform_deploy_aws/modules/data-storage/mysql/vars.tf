# cluster input of modules
variable "cluster_name" {
 description = "The name to use for all the cluster resources"
}


variable "instance_class" {
  description = "Instance class of db"
}

variable "db_username" {
  description = "Username of database"
}

variable "db_password" {
  description = "Password of database"
}