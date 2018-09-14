
resource "aws_db_instance" "db" {
 engine = "mysql"
 allocated_storage = 10
 #db.t2.micro
 instance_class = "${var.instance_class}"
 name = "${var.cluster_name}_db"
 username = "${var.db_username}"
 password = "${var.db_password}"
 skip_final_snapshot = true
}