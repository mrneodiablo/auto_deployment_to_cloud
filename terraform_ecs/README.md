# ECS and Terraform
In this section, we will deploy a small web cluster on ECS service at AWS. The tool will be use to create that are `Terraform` and ECS service

Create `RDS`, `EC2`, `SecurityGroup`, `ECS`, `AutoScalingGroup`

### File Tree

```
 modules
      └ ecs
          └ services
          |    └ webapp
          |        └ main.tf
          |        └ outputs.tf
          |        └ vars.tf
          └ data-storage
              └ ecr
              |    └ main.tf
              |    └ outputs.tf
              |    └ vars.tf
              |    
              └ mysql
                  └ main.tf
                  └ outputs.tf
                  └ vars.tf
     

live
  └ prod
      └ main.tf
      └ outputs.tf
      └ vars.tf
```

### Run terraform
```
Dong:mysql dongvt$ terraform apply
aws_ecs_task_definition.http-app-task: Refreshing state... (ID: ecs-cluster-task-define)
aws_ecs_cluster.http-app-cluster: Refreshing state... (ID: arn:aws:ecs:ap-southeast-1:349161024290:cluster/http-app-cluster)
aws_security_group.ecs-cluster: Refreshing state... (ID: sg-06740b72618603cad)
data.aws_iam_policy.AmazonEC2ContainerServiceforEC2Role: Refreshing state...
data.aws_availability_zones.all: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_autoscaling_group.ecs-cluster-instance
      id:                                 <computed>
      arn:                                <computed>
      availability_zones.#:               "1"
      availability_zones.2424750709:      "ap-southeast-1a"
      default_cooldown:                   <computed>
      desired_capacity:                   <computed>
      force_delete:                       "false"
      health_check_grace_period:          "300"
      health_check_type:                  "ELB"
      launch_configuration:               "${aws_launch_configuration.ecs-cluster.id}"
      max_size:                           "2"
      metrics_granularity:                "1Minute"
      min_elb_capacity:                   "2"
      min_size:                           "2"
      name:                               "ecs-cluster-instance"
      protect_from_scale_in:              "false"
      service_linked_role_arn:            <computed>
      tag.#:                              "1"
      tag.3274064405.key:                 "Name"
      tag.3274064405.propagate_at_launch: "true"
      tag.3274064405.value:               "test-dongvt-scaling"
      target_group_arns.#:                <computed>
      termination_policies.#:             "1"
      termination_policies.0:             "Default"
      vpc_zone_identifier.#:              <computed>
      wait_for_capacity_timeout:          "10m"

  + aws_iam_instance_profile.ecs-cluster-instance-profile
      id:                                 <computed>
      arn:                                <computed>
      create_date:                        <computed>
      name:                               "ecs-cluster-instance-profile"
      path:                               "/"
      role:                               "ecs-cluster-role-ecsInstanceRole"
      roles.#:                            <computed>
      unique_id:                          <computed>

  + aws_iam_role.ecs-cluster-role-ecs-instance
      id:                                 <computed>
      arn:                                <computed>
      assume_role_policy:                 "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      },\n      \"Effect\": \"Allow\",\n      \"Sid\": \"\"\n    }\n  ]\n}\n"
      create_date:                        <computed>
      force_detach_policies:              "false"
      max_session_duration:               "3600"
      name:                               "ecs-cluster-role-ecsInstanceRole"
      path:                               "/"
      unique_id:                          <computed>

  + aws_iam_role_policy.ecs-cluster-role-policy-ecs-instance
      id:                                 <computed>
      name:                               "ecs-cluster-role-policy-ecs-instance"
      policy:                             "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"ecs:CreateCluster\",\n        \"ecs:DeregisterContainerInstance\",\n        \"ecs:DiscoverPollEndpoint\",\n        \"ecs:Poll\",\n        \"ecs:RegisterContainerInstance\",\n        \"ecs:StartTelemetrySession\",\n        \"ecs:UpdateContainerInstancesState\",\n        \"ecs:Submit*\",\n        \"ecr:GetAuthorizationToken\",\n        \"ecr:BatchCheckLayerAvailability\",\n        \"ecr:GetDownloadUrlForLayer\",\n        \"ecr:BatchGetImage\",\n        \"logs:CreateLogStream\",\n        \"logs:PutLogEvents\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}"
      role:                               "${aws_iam_role.ecs-cluster-role-ecs-instance.id}"

  + aws_launch_configuration.ecs-cluster
      id:                                 <computed>
      associate_public_ip_address:        "false"
      ebs_block_device.#:                 <computed>
      ebs_optimized:                      <computed>
      enable_monitoring:                  "true"
      iam_instance_profile:               "ecs-cluster-instance-profile"
      image_id:                           "ami-0a3f70f0255af1d29"
      instance_type:                      "t2.micro"
      key_name:                           "vothanhdong18_key_public"
      name:                               <computed>
      name_prefix:                        "testing.ecs.terraform-"
      root_block_device.#:                <computed>
      security_groups.#:                  "1"
      security_groups.1391827516:         "sg-06740b72618603cad"
      user_data:                          "53351238b404f4c11ce8829494712ac391a2a418"


Plan: 5 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_iam_role.ecs-cluster-role-ecs-instance: Creating...
  arn:                   "" => "<computed>"
  assume_role_policy:    "" => "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      },\n      \"Effect\": \"Allow\",\n      \"Sid\": \"\"\n    }\n  ]\n}\n"
  create_date:           "" => "<computed>"
  force_detach_policies: "" => "false"
  max_session_duration:  "" => "3600"
  name:                  "" => "ecs-cluster-role-ecsInstanceRole"
  path:                  "" => "/"
  unique_id:             "" => "<computed>"
aws_iam_role.ecs-cluster-role-ecs-instance: Creation complete after 3s (ID: ecs-cluster-role-ecsInstanceRole)
aws_iam_instance_profile.ecs-cluster-instance-profile: Creating...
  arn:         "" => "<computed>"
  create_date: "" => "<computed>"
  name:        "" => "ecs-cluster-instance-profile"
  path:        "" => "/"
  role:        "" => "ecs-cluster-role-ecsInstanceRole"
  roles.#:     "" => "<computed>"
  unique_id:   "" => "<computed>"
aws_iam_role_policy.ecs-cluster-role-policy-ecs-instance: Creating...
  name:   "" => "ecs-cluster-role-policy-ecs-instance"
  policy: "" => "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"ecs:CreateCluster\",\n        \"ecs:DeregisterContainerInstance\",\n        \"ecs:DiscoverPollEndpoint\",\n        \"ecs:Poll\",\n        \"ecs:RegisterContainerInstance\",\n        \"ecs:StartTelemetrySession\",\n        \"ecs:UpdateContainerInstancesState\",\n        \"ecs:Submit*\",\n        \"ecr:GetAuthorizationToken\",\n        \"ecr:BatchCheckLayerAvailability\",\n        \"ecr:GetDownloadUrlForLayer\",\n        \"ecr:BatchGetImage\",\n        \"logs:CreateLogStream\",\n        \"logs:PutLogEvents\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}"
  role:   "" => "ecs-cluster-role-ecsInstanceRole"
aws_iam_role_policy.ecs-cluster-role-policy-ecs-instance: Creation complete after 2s (ID: ecs-cluster-role-ecsInstanceRole:ecs-cluster-role-policy-ecs-instance)
aws_iam_instance_profile.ecs-cluster-instance-profile: Creation complete after 4s (ID: ecs-cluster-instance-profile)
aws_launch_configuration.ecs-cluster: Creating...
  associate_public_ip_address: "" => "false"
  ebs_block_device.#:          "" => "<computed>"
  ebs_optimized:               "" => "<computed>"
  enable_monitoring:           "" => "true"
  iam_instance_profile:        "" => "ecs-cluster-instance-profile"
  image_id:                    "" => "ami-0a3f70f0255af1d29"
  instance_type:               "" => "t2.micro"
  key_name:                    "" => "vothanhdong18_key_public"
  name:                        "" => "<computed>"
  name_prefix:                 "" => "testing.ecs.terraform-"
  root_block_device.#:         "" => "<computed>"
  security_groups.#:           "" => "1"
  security_groups.1391827516:  "" => "sg-06740b72618603cad"
  user_data:                   "" => "53351238b404f4c11ce8829494712ac391a2a418"
aws_launch_configuration.ecs-cluster: Still creating... (10s elapsed)
aws_launch_configuration.ecs-cluster: Creation complete after 10s (ID: testing.ecs.terraform-20181003073207551600000001)
aws_autoscaling_group.ecs-cluster-instance: Creating...
  arn:                                "" => "<computed>"
  availability_zones.#:               "" => "1"
  availability_zones.2424750709:      "" => "ap-southeast-1a"
  default_cooldown:                   "" => "<computed>"
  desired_capacity:                   "" => "<computed>"
  force_delete:                       "" => "false"
  health_check_grace_period:          "" => "300"
  health_check_type:                  "" => "ELB"
  launch_configuration:               "" => "testing.ecs.terraform-20181003073207551600000001"
  max_size:                           "" => "2"
  metrics_granularity:                "" => "1Minute"
  min_elb_capacity:                   "" => "2"
  min_size:                           "" => "2"
  name:                               "" => "ecs-cluster-instance"
  protect_from_scale_in:              "" => "false"
  service_linked_role_arn:            "" => "<computed>"
  tag.#:                              "" => "1"
  tag.3274064405.key:                 "" => "Name"
  tag.3274064405.propagate_at_launch: "" => "true"
  tag.3274064405.value:               "" => "test-dongvt-scaling"
  target_group_arns.#:                "" => "<computed>"
  termination_policies.#:             "" => "1"
  termination_policies.0:             "" => "Default"
  vpc_zone_identifier.#:              "" => "<computed>"
  wait_for_capacity_timeout:          "" => "10m"
aws_autoscaling_group.ecs-cluster-instance: Still creating... (10s elapsed)
aws_autoscaling_group.ecs-cluster-instance: Still creating... (20s elapsed)
aws_autoscaling_group.ecs-cluster-instance: Still creating... (30s elapsed)
aws_autoscaling_group.ecs-cluster-instance: Still creating... (40s elapsed)
aws_autoscaling_group.ecs-cluster-instance: Creation complete after 49s (ID: ecs-cluster-instance)
aws_ecs_service.run-service: Creating...
  cluster:                                            "" => "arn:aws:ecs:ap-southeast-1:349161024290:cluster/http-app-cluster"
  deployment_maximum_percent:                         "" => "200"
  deployment_minimum_healthy_percent:                 "" => "100"
  desired_count:                                      "" => "1"
  iam_role:                                           "" => "<computed>"
  launch_type:                                        "" => "EC2"
  name:                                               "" => "ecs-cluster-run-service"
  network_configuration.#:                            "" => "1"
  network_configuration.0.assign_public_ip:           "" => "false"
  network_configuration.0.security_groups.#:          "" => "1"
  network_configuration.0.security_groups.1391827516: "" => "sg-06740b72618603cad"
  network_configuration.0.subnets.#:                  "" => "1"
  network_configuration.0.subnets.1799346172:         "" => "subnet-96fbc2df"
  scheduling_strategy:                                "" => "REPLICA"
  task_definition:                                    "" => "arn:aws:ecs:ap-southeast-1:349161024290:task-definition/ecs-cluster-task-define:1"
aws_ecs_service.run-service: Creation complete after 2s (ID: arn:aws:ecs:ap-southeast-1:349161024290:service/ecs-cluster-run-service)
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```