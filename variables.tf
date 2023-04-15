# Common
variable "aws_region" {
  description = "AWS Region to deploy the infrastructure"
  type        = string
}
variable "environment" {
  description = "The infrastructure environment (dev, qa, staging, prod)"
  type        = string
}
variable "project_id" {
  description = "Project ID"
  type        = string
}
variable "application" {
  description = "Application Name"
  type        = string
}
variable "cost_center" {
  description = "Cost center sponsors for the infrastructure expenses"
  type        = string
}
# VPC
variable "cidr" {
  description = "CIDR of the VPC"
  type        = string
}
variable "name" {
  description = "The common name of the VPC"
  type        = string
}
variable "public_subnets" {
  description = "An List of Objects containing configuration about subnet"
  type        = list(any)
}
variable "private_subnets" {
  description = "An List of Objects containing configuration about subnet"
  type        = list(any)
}
variable "public_subnet_tags" {
  description = "Common tag for public subnets"
  type        = map(any)
}
variable "private_subnet_tags" {
  description = "Common tag for private subnets"
  type        = map(any)
}
variable "single_nat_gateway" {
  description = "Enable a single NAT Gateway for private subnets"
  type        = bool
}