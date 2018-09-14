provider "aws" {
 region = "ap-southeast-1"
 shared_credentials_file = ""
}

terraform {
  backend "s3" {
    #dongvt-terraform-state
    bucket = "dongvt-terraform-state"

    #prod/data-storage/mysql/terraform.tfstate
    key    = "prod/data-storage/mysql/terraform.tfstate"
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