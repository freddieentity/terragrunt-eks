include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/terraform-aws-vpc"
  //   source = "git@github.com:freddieentity/terraform-modules.git//vpc?ref=vpc-v0.0.1"
}

# Acess this using syntax local.common.locals.tags
locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}


inputs = {
  cidr = "10.0.0.0/16"
  name = "my-vpc"
  public_subnets = [
    {
      "name" : "public-subnet-1",
      "cidr" : "10.0.1.0/24",
      "az" : "us-east-1a",
      "tags" : {}
    },
    {
      "name" : "public-subnet-2",
      "cidr" : "10.0.2.0/24",
      "az" : "us-east-1b",
      "tags" : {}
    },
    {
      "name" : "public-subnet-3",
      "cidr" : "10.0.3.0/24",
      "az" : "us-east-1c",
      "tags" : {}
    }
  ]
  private_subnets = [
    {
      "name" : "private-subnet-1",
      "cidr" : "10.0.101.0/24",
      "az" : "us-east-1a",
      "tags" : {}
    },
    {
      "name" : "private-subnet-2",
      "cidr" : "10.0.102.0/24",
      "az" : "us-east-1b",
      "tags" : {}
    },
    {
      "name" : "private-subnet-3",
      "cidr" : "10.0.103.0/24",
      "az" : "us-east-1c",
      "tags" : {}
    }
  ]
  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/my-eks-cluster-name" = "owned"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/my-eks-cluster-name" = "owned"
  }
  single_nat_gateway = true
}