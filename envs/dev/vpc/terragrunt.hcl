include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=4.0.1" # "../../../modules/terraform-aws-vpc"
  //   source = "git@github.com:freddieentity/terraform-modules.git//vpc?ref=vpc-v0.0.1"
}

# Acess this using syntax local.common.locals.tags
locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}


inputs = {
  name = "fredeks"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  // database_subnets  = ["10.0.151.0/24", "10.0.152.0/24", "10.0.153.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway = true
  single_nat_gateway = true

  // cidr = "10.0.0.0/16"
  // name = "my-eks-vpc"
  // public_subnets = {
  //   "public-subnet-1" = {
  //     "cidr" : "10.0.1.0/24",
  //     "az" : "us-east-1a",
  //     "tags" : {}
  //   },
  //   "public-subnet-2" = {
  //     "cidr" : "10.0.2.0/24",
  //     "az" : "us-east-1b",
  //     "tags" : {}
  //   },
  //   "public-subnet-3" = {
  //     "cidr" : "10.0.3.0/24",
  //     "az" : "us-east-1c",
  //     "tags" : {}
  //   }
  // }
  // private_subnets = {
  //   "private-subnet-1" = {
  //     "cidr" : "10.0.101.0/24",
  //     "az" : "us-east-1a",
  //     "tags" : {}
  //   },
  //   "private-subnet-2" = {
  //     "cidr" : "10.0.102.0/24",
  //     "az" : "us-east-1b",
  //     "tags" : {}
  //   },
  //   "private-subnet-3" = {
  //     "cidr" : "10.0.103.0/24",
  //     "az" : "us-east-1c",
  //     "tags" : {}
  //   }
  // }
  // public_subnet_tags = {
  //   "kubernetes.io/role/elb"                                        = "1"
  //   "kubernetes.io/cluster/${local.common.locals.eks_cluster_name}" = "owned"
  // }
  // private_subnet_tags = {
  //   "kubernetes.io/role/internal-elb"                               = "1"
  //   "kubernetes.io/cluster/${local.common.locals.eks_cluster_name}" = "owned"
  // }
  // single_nat_gateway = true
}