provider "aws" {
  region = "ap-southeast-1"
}

# get all zone
data "aws_availability_zones" "all" {}

// create cluster for ECS
resource "aws_ecs_cluster" "http-app-cluster" {
  name = "http-app-cluster"
}

// security group for ECS
resource "aws_security_group" "ecs-cluster" {
  name = "${var.ecs_cluster_name}-instance"
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
  lifecycle {
  create_before_destroy = true
  }
}

// iam role for cluster for action on `containerInstance`
data "aws_iam_policy" "AmazonEC2ContainerServiceforEC2Role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
resource "aws_iam_role" "ecs-cluster-role-ecs-instance" {
  name = "ecs-cluster-role-ecsInstanceRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
//inline policy in role (attach policy to role IAM)
resource "aws_iam_role_policy" "ecs-cluster-role-policy-ecs-instance" {
  name = "ecs-cluster-role-policy-ecs-instance"
  role = "${aws_iam_role.ecs-cluster-role-ecs-instance.id}"
  policy = "${data.aws_iam_policy.AmazonEC2ContainerServiceforEC2Role.policy}"
}

resource "aws_iam_instance_profile" "ecs-cluster-instance-profile" {
  name = "ecs-cluster-instance-profile"
  role = "${aws_iam_role.ecs-cluster-role-ecs-instance.name}"
}


# create launch config
resource "aws_launch_configuration" "ecs-cluster" {
  name_prefix = "testing.ecs.terraform-"
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.ecs-cluster.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs-cluster-instance-profile.name}"
  key_name = "vothanhdong18_key_public"

  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=''${aws_ecs_cluster.http-app-cluster.name} >> /etc/ecs/ecs.config
  EOF
}
# create autoscaling from launch config, ans elb
resource "aws_autoscaling_group" "ecs-cluster-instance" {
  name = "ecs-cluster-instance"
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.ecs-cluster.id}"
  load_balancers = []
  lifecycle {
    create_before_destroy = true
    ignore_changes = [ "suspended_processes" ]
  }

  availability_zones = ["ap-southeast-1a"]

  health_check_type = "ELB"

  min_size = "${var.min_size}"
  max_size = "${var.max_size}"
  min_elb_capacity = "${var.min_size}"
  termination_policies = [ "Default" ]

  tag {
    key = "Name"
    value = "${var.ecs_cluster_name}-scaling"
    propagate_at_launch = true
  }
}


module "task-define" {
 source = "../../modules/ecs/services/webapp"
 name = "ecs-cluster-task-define"
}

// subnet id
data "aws_subnet_ids" "subnet-1a" {
  vpc_id = "vpc-62133705"
}
// run service, tassk
resource "aws_ecs_service" "run-service" {
  name            = "ecs-cluster-run-service"
  cluster         = "${aws_ecs_cluster.http-app-cluster.id}"
  task_definition = "${module.task-define.arn-webapp-tasks}"
  desired_count   = 1
  network_configuration {
    subnets = ["subnet-96fbc2df"] 
    security_groups = ["${aws_security_group.ecs-cluster.id}"]
  } 
}
