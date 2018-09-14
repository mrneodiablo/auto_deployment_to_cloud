provider "aws" {
 region = "ap-southeast-1"
 shared_credentials_file = ""
}

terraform {
  backend "s3" {
    bucket = "dongvt-terraform-state"
    key    = "stage/data-storage/mysql/terraform.tfstate"
    region = "ap-southeast-1"
  }
}


resource "aws_db_instance" "example" {
 engine = "mysql"
 allocated_storage = 10
 instance_class = "db.t2.micro"
 name = "example_database"
 username = "admin"
 password = "${var.db_password}"
 skip_final_snapshot = true
}