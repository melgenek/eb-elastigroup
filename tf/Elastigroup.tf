resource "spotinst_elastigroup_aws" "ElastiGroup" {
  name = aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment.name
  description = "Linked environment: ${aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment.id}"

  iam_instance_profile = data.aws_launch_configuration.ElasticBeanstalkLaunchConfiguration.iam_instance_profile
  image_id = data.aws_launch_configuration.ElasticBeanstalkLaunchConfiguration.image_id
  user_data = data.aws_launch_configuration.ElasticBeanstalkLaunchConfiguration.user_data

  spot_percentage = 100

  orientation = "balanced"
  draining_timeout = 120
  fallback_to_ondemand = true
  lifetime_period = "days"
  revert_to_spot {
    perform_at = "always"
  }

  desired_capacity = 1
  min_size = 0
  max_size = 2
  capacity_unit = "instance"

  integration_beanstalk {
    environment_id = aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment.id

    deployment_preferences {
      automatic_roll = true
      batch_size_percentage = 100
      grace_period = 600
      strategy {
        action = "REPLACE_SERVER"
        should_drain_instances = true
      }
    }
  }

  instance_types_ondemand = "t3.small"
  instance_types_spot = [
    "t3.small",
    "t2.small"
  ]
  subnet_ids = var.private_subnets
  product = "Linux/UNIX"

  target_group_arns = [data.aws_lb_target_group.ElasticBeanstalkTargetGroup.arn]
  security_groups = data.aws_launch_configuration.ElasticBeanstalkLaunchConfiguration.security_groups

  enable_monitoring = data.aws_launch_configuration.ElasticBeanstalkLaunchConfiguration.enable_monitoring
  ebs_optimized = data.aws_launch_configuration.ElasticBeanstalkLaunchConfiguration.ebs_optimized

  dynamic "ebs_block_device" {
    for_each = data.aws_launch_configuration.ElasticBeanstalkLaunchConfiguration.ebs_block_device
    content {
      device_name = ebs_block_device.value.device_name
      delete_on_termination = ebs_block_device.value.delete_on_termination
      volume_size = ebs_block_device.value.volume_size
      volume_type = ebs_block_device.value.volume_type
      encrypted = ebs_block_device.value.encrypted
      iops = ebs_block_device.value.iops
      snapshot_id = ebs_block_device.value.snapshot_id
    }
  }

  health_check_type = "TARGET_GROUP"
  health_check_grace_period = 600

  placement_tenancy = "default"

  region = var.region

  tags {
    key = "Name"
    value = aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment.name
  }

  tags {
    key = "elasticbeanstalk:environment-id"
    value = aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment.id
  }

  tags {
    key = "elasticbeanstalk:environment-name"
    value = aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment.name
  }

}
