output "elb_dns_address" {
 value = "${aws_elb.elb.dns_name}"
}

output "elb_dns_name" {
  value = "${aws_elb.elb.dns_name}"
}

output "asg_name" {
 value = "${aws_autoscaling_group.scaling.name}"
}
