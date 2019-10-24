variable "region" {
  type = string
  description = "for example, us-east-1"
}

variable "application" {
  type = string
  description = "EB application name"
}

variable "eb-env" {
  type = string
  description = "EB environment name"
}

variable "vpc_id" {
  type = string
  description = "vpc-xxxxx"
}

variable "public_subnets" {
  type = list(string)
  description = "['subnet-xxxx']"
}

variable "private_subnets" {
  type = list(string)
  description = "['subnet-xxxx']"
}

variable "iam_instance_profile" {
  type = string
  description = "https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts-roles-instance.html"
}

variable "image_id" {
  type = string
  description = "ami-xxxx"
}

variable "service_role" {
  type = string
  description = "https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts-roles-service.html"
}
