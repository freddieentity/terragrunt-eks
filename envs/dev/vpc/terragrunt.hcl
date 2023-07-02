include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=4.0.1" # "../../../modules/terraform-aws-vpc"
  //   source = "git@github.com:freddieentity/terraform-modules.git//vpc?ref=vpc-v0.0.1"
}

locals {
  // inputs   = yamldecode(file("inputs.yaml"))
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
}

skip = local.env_vars.modules.vpc.skip

inputs = {
  name = local.env_vars.application_name
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  // database_subnets  = ["10.0.151.0/24", "10.0.152.0/24", "10.0.153.0/24"]
  public_subnet_tags = {
    "kubernetes.io/role/elb"                     = "1"
    "kubernetes.io/cluster/${local.env_vars.application_name}" = "owned"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"            = "1"
    "kubernetes.io/cluster/${local.env_vars.application_name}" = "owned"
  }
  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_nat_gateway      = true
  single_nat_gateway      = true
  map_public_ip_on_launch = true

  tags = {
    Name        = local.env_vars.application_name
    Environment = local.env_vars.environment
  }
}