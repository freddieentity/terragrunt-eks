include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/terraform-aws-eks"
}

# Acess this using syntax local.common.locals.tags
locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

dependency "vpc" {
  config_path = "../vpc"

  # Must have when execute plan due to variables deps. The variables must have a desired type in the module
  mock_outputs = {
    public_subnet_ids  = ["public-subnet-1234", "public-subnet-6789"]
    private_subnet_ids = ["private-subnet-1234", "private-subnet-6789"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show"]
}

dependency "base" {
  config_path = "../base"

  # Must have when execute plan due to variables deps. The variables must have a desired type in the module
  mock_outputs = {
    eks_cluster_role_arn    = ""
    eks_node_group_role_arn = ""
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show"]
}

inputs = {
  cluster_name            = "freddieentity"
  public_subnet_ids       = dependency.vpc.outputs.public_subnets
  private_subnet_ids      = dependency.vpc.outputs.private_subnets
  eks_cluster_role_arn    = dependency.base.outputs.eks_cluster_role_arn
  eks_node_group_role_arn = dependency.base.outputs.eks_node_group_role_arn

  node_groups = { # https://github.com/aws/amazon-vpc-cni-k8s/blob/master/misc/eni-max-pods.txt
    spot = {
      "is_private" : true,
      "capacity_type" : "SPOT",
      "instance_types" : ["t3.medium"],
      "labels" : {
        type_of_nodegroup = "spot_untainted"
      },
      "min_size" : 1,
      "desired_size" : 1,
      "max_size" : 1,
      "ec2_ssh_key" : "terragrunt-eks"
    },
    ondemand = {
      "is_private" : false,
      "capacity_type" : "ON_DEMAND",
      "instance_types" : ["t3.medium"],
      "labels" : {
        type_of_nodegroup = "on_demand_untainted"
      },
      "min_size" : 1,
      "desired_size" : 1,
      "max_size" : 1,
      "ec2_ssh_key" : "terragrunt-eks"
    }
  }
}