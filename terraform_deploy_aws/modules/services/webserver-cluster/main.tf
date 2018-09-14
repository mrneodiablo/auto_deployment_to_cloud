
# get all zone
data "aws_availability_zones" "all" {}


#render file from variable
data "template_file" "user_data" {
  count = "${1 - var.enable_new_user_data}"

  template = "${file("${path.module}/user-data.sh")}"
  vars {
    server_port = "${var.server_port}"
    db_address = "${var.db_address}"
    db_port = "${var.db_port}"
  }
}

# new user_data_temple
data "template_file" "user_data_new" {
 count = "${var.enable_new_user_data}"

 template = "${file("${path.module}/user-data-new.sh")}"
 vars {
  server_port = "${var.server_port}"
 }
}

# create launch config
resource "aws_launch_configuration" "config" {
 image_id = "${var.ami_type}"
 instance_type = "${var.instance_type}"
 security_groups = ["${aws_security_group.instance.id}"]
 key_name = "vothanhdong18_key_public"


 user_data = "${element(concat(data.template_file.user_data.*.rendered,data.template_file.user_data_new.*.rendered),0)}"

 lifecycle {
 create_before_destroy = true
 }
}


# create ELB
resource "aws_elb" "elb" {
 name = "${var.cluster_name}-elb"
 availability_zones = ["${data.aws_availability_zones.all.names}"]
 security_groups = ["${aws_security_group.elb.id}"]
 listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = "${var.server_port}"
        instance_protocol = "http"
 }
 health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        interval = 30
        target = "HTTP:${var.server_port}/"
 }
}

# create autoscaling from launch config, ans elb
resource "aws_autoscaling_group" "scaling" {
 name = "${var.cluster_name}-${aws_launch_configuration.config.name}"
 launch_configuration = "${aws_launch_configuration.config.id}"
 load_balancers = ["${aws_elb.elb.name}"]

 availability_zones = ["${data.aws_availability_zones.all.names}"]
 
 health_check_type = "ELB"

 min_size = "${var.min_size}"
 max_size = "${var.max_size}"
 min_elb_capacity = "${var.min_size}"
 
 lifecycle {
  create_before_destroy = true
 }

 tag {
  key = "Name"
  value = "${var.cluster_name}-scaling"
  propagate_at_launch = true
 }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
 count = "${var.enable_autoscaling}"
  
 scheduled_action_name = "scale-out-during-business-hours"
 min_size = 2
 max_size = 10
 desired_capacity = 10
 recurrence = "0 9 * * *"

 autoscaling_group_name = "${aws_autoscaling_group.scaling.name}"
}


resource "aws_autoscaling_schedule" "scale_in_at_night" {
 count = "${var.enable_autoscaling}"
  
 scheduled_action_name = "scale-in-at-night"
 min_size = 2
 max_size = 10
 desired_capacity = 2
 recurrence = "0 17 * * *"

 autoscaling_group_name = "${aws_autoscaling_group.scaling.name}"
}

resource "aws_security_group" "instance" {
 name = "${var.cluster_name}-instance"
 ingress {
 from_port = "${var.server_port}"
 to_port = "${var.server_port}"
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 lifecycle {
 create_before_destroy = true
 }
}



resource "aws_security_group" "elb" {
 name = "${var.cluster_name}-elb"
 ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
 }
}


# Cloud watch
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
 alarm_name = "${var.cluster_name}-high-cpu-utilization"
 namespace = "AWS/EC2"
 metric_name = "CPUUtilization"
 dimensions = {
 AutoScalingGroupName = "${aws_autoscaling_group.scaling.name}"
 }
 comparison_operator = "GreaterThanThreshold"
 evaluation_periods = 1
 period = 300
 statistic = "Average"
 threshold = 90
 unit = "Percent"
}


resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
 count = "${replace(replace(var.instance_type, "/^[^t].*/", "0"),"/^t.*$/", "1")}"

 alarm_name = "${var.cluster_name}-low-cpu-credit-balance"
 namespace = "AWS/EC2"
 metric_name = "CPUCreditBalance"
 dimensions = {
 AutoScalingGroupName = "${aws_autoscaling_group.scaling.name}"
 }
 comparison_operator = "LessThanThreshold"
 evaluation_periods = 1
 period = 300
 statistic = "Minimum"
 threshold = 10
 unit = "Count"
}
