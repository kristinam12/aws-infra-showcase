variable "aws_region" {
  default = "eu-central-2"
}

# Specify the availability zone (a 'data center' in a region)
variable "aws_zone" {
  default = "eu-central-2a"
}

variable "project_name" {
  default = "aws-infra-showcase"
}

# CIDR block defines the range of IP addresses the VPC will use
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}
