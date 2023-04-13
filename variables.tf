# Common
variable "aws_region" {}
variable "environment" {}
variable "project_id" {}
variable "application" {}
variable "cost_center" {}
# VPC
variable "cidr" {}
variable "azs" {}
variable "name" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "public_subnet_tags" {}
variable "private_subnet_tags" {}
variable "single_nat_gateway" {}