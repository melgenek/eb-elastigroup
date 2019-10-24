resource "aws_elastic_beanstalk_environment" "ElasticBeanstalkEnvironment" {
  name = var.eb-env
  application = var.application
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.13.0 running Docker 18.06.1-ce"


  setting {
    namespace = "aws:elasticbeanstalk:hostmanager"
    name = "LogPublicationControl"
    value = "true"
    resource = ""
  }

  ### Instances
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "t3.small"
    resource = ""
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "ImageId"
    value = var.image_id
    resource = ""
  }

  ### Capacity
  setting {
    namespace = "aws:autoscaling:asg"
    name = "Availability Zones"
    value = "Any"
    resource = ""
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = "0"
    resource = ""
  }

  ### Load Balancer
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
    resource = ""
  }

  ### Deployment
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "DeploymentPolicy"
    value = "AllAtOnce"
    resource = ""
  }

  ### Security
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = var.iam_instance_profile
    resource = ""
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "ServiceRole"
    value = var.service_role
    resource = ""
  }

  ### Monitoring
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name = "HealthCheckPath"
    value = "/health"
    resource = ""
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name = "SystemType"
    value = "enhanced"
    resource = ""
  }

  ### Network
  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = var.vpc_id
    resource = ""
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBScheme"
    value = "internal"
    resource = ""
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = join(",", var.public_subnets)
    resource = ""
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = false
    resource = ""
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = join(",", var.private_subnets)
    resource = ""
  }

}

data "aws_launch_configuration" "ElasticBeanstalkLaunchConfiguration" {
  name = aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment.launch_configurations[0]
}

data "aws_lb_listener" "LoadBalancerListener" {
  load_balancer_arn = aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment.load_balancers[0]
  port = "80"
}

data "aws_lb_target_group" "ElasticBeanstalkTargetGroup" {
  arn = data.aws_lb_listener.LoadBalancerListener.default_action[0].target_group_arn
}
