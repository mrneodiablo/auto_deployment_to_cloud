provider "aws" {
 region = "ap-southeast-1"
 shared_credentials_file = ""
}


terraform {
  backend "s3" {
    #dongvt-terraform-state
    bucket = "dongvt-terraform-state"

    #prod/data-storage/mysql/terraform.tfstate
    key    = "prod/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

module "database" {
 source = "../../../modules/data-storage/mysql"

 cluster_name = "database_prod"
 instance_class = "db.t2.micro"
 db_username = "admin"
 db_password = ""
}


module "webserver_cluster" {
 source = "../../../modules/services/webserver-cluster"

 cluster_name = "webservers-prod"
 db_address = "${module.database.address}"
 db_port = "${module.database.port}"
 instance_type = "t2.micro"
 ami_type = "ami-01da99628f381e50a"
 min_size = 2
 max_size = 10
 enable_autoscaling = true
 enable_new_user_data = true

}

