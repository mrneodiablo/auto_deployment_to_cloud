output "elb_dns_address" {
 value = "${aws_elb.example.dns_name}"
}
