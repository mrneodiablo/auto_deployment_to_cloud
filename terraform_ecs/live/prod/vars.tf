// name of cluster ECS
variable "ecs_cluster_name" {
 default = "test-dongvt"
}

// AWS INFO of cont
variable "ami_id" {
 default = "ami-0a3f70f0255af1d29"
}
variable "instance_type" {
 default = "t2.micro"
}


//ASG
variable "min_size" {
 default = "2"
}
variable "max_size" {
 default = "2"
}