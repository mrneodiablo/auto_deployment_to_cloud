variable "path_mysql" {
 default = "mysql"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

variable "enable_autoscaling" {
 description = "If set to true, enable auto scaling"
}

# cluster input of modules
variable "cluster_name" {
 description = "The name to use for all the cluster resources"
}

# db state config modules
variable "db_address" {
 description = "address mysql"
}

# db state key
variable "db_port" {
  description = "port mysql"
}


variable "instance_type" {
 description = "The type of EC2 Instances to run"
 default = "t2.micro"
}

variable "ami_type" {
 description = "The type of AMI Instances to run"
 default = "ami-01da99628f381e50a"
}


variable "min_size" {
 description = "The minimum number of EC2 Instances in the ASG"
}

variable "max_size" {
 description = "The maximum number of EC2 Instances in the ASG"
}


variable "enable_new_user_data" {
 description = "If set to 1, use the new User Data script"
}