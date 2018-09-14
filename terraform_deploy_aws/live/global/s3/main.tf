provider "aws" {
 region = "ap-southeast-1"
 shared_credentials_file = ""
}


resource "aws_s3_bucket" "terraform_state" {
 bucket = "dongvt-terraform-state"

 acl = "private"

 versioning {
    enabled = true
 }
 
 lifecycle {
 	prevent_destroy = true
 }
}