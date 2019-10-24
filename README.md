# Create EB and ElastiGroup via terraform

### Assumptions
- EB application from `var.application` exists
- vpc with subnets exists
- roles (iam image profile, service role) are created

### Requirements
1) LoadBalancerType = application			in EB env
2) health_check_type = "TARGET_GROUP" 		in ElastiGroup
3) VPC

### Flow to create/destroy EB+ElastiGroup:
1) `cd tf`
2) `terraform init`
3) `terraform apply`
The elastigroup is created:
```
.....
EB is created
.....
spotinst_elastigroup_aws.ElastiGroup: Creating...
spotinst_elastigroup_aws.ElastiGroup: Creation complete after 3s
```
4) Use SpotInst UI to wait until ElastiGroup is created. There will be 1 instance visible in EB environment.
5) `terraform destroy`
An error occurs:
```
spotinst_elastigroup_aws.ElastiGroup: Destroying... [id=sig-xxxx]
spotinst_elastigroup_aws.ElastiGroup: Destruction complete after 0s
aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment: Destroying... [id=e-555555]
aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment: Still destroying... [id=e-555555, 10s elapsed]
aws_elastic_beanstalk_environment.ElasticBeanstalkEnvironment: Still destroying... [id=e-555555, 20s elapsed]

Error: Error waiting for Elastic Beanstalk Environment (e-555555) to become terminated: 2 errors occurred:
        * 2019-10-24 15:48:19.957 +0000 UTC (e-555555) : Deleting Auto Scaling group named: awseb-e-555555-stack-AWSEBAutoScalingGroup-ABNSMDBHRQEW failed Reason: AutoscalingGroup deletion cannot be performed because the Terminate process has been suspended; please resume this process and then retry stack deletion.
        * 2019-10-24 15:48:20.041 +0000 UTC (e-555555) : Deleting Auto Scaling launch configuration named: awseb-e-555555-stack-AWSEBAutoScalingLaunchConfiguration-1UH7JBULI7KYO failed Reason: Cannot delete launch configuration awseb-e-555555-stack-AWSEBAutoScalingLaunchConfiguration-1UH7JBULI7KYO because it is attached to AutoScalingGroup awseb-e-555555-stack-AWSEBAutoScalingGroup-ABNSMDBHRQEW (Service: AmazonAutoScaling; Status Code: 400; Error Code: ResourceInUse; Request ID: 44d9642d-fc20-4b22-a7cf-63e4f8427162)
```
