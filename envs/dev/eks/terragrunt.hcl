include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/terraform-aws-eks"
}

locals {
  // inputs   = yamldecode(file("inputs.yaml"))
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
}

skip = local.env_vars.modules.eks.skip

dependency "vpc" {
  config_path = "../vpc"

  # Must have when execute plan due to variables deps. The variables must have a desired type in the module
  mock_outputs = {
    public_subnet_ids            = ["public-subnet-1234", "public-subnet-6789"]
    private_subnet_ids           = ["private-subnet-1234", "private-subnet-6789"]
    eks_cluster_role_arn         = ""
    eks_node_group_role_arn      = ""
    eks_fargate_profile_role_arn = ""
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show"]
}

dependency "base" {
  config_path = "../base"
}

inputs = {
  cluster_name                 = local.env_vars.application_name
  public_subnet_ids            = dependency.vpc.outputs.public_subnets
  private_subnet_ids           = dependency.vpc.outputs.private_subnets
  eks_cluster_role_arn         = dependency.base.outputs.eks_cluster_role_arn
  eks_node_group_role_arn      = dependency.base.outputs.eks_node_group_role_arn
  eks_fargate_profile_role_arn = dependency.base.outputs.eks_fargate_profile_role_arn

  fargate_profiles = {
    default = {
      selectors = [
        { namespace = "default" }
      ]
    }
  }

  node_groups = { # https://github.com/aws/amazon-vpc-cni-k8s/blob/master/misc/eni-max-pods.txt
    // spot = {
    //   "is_private" : true,
    //   "capacity_type" : "SPOT",
    //   "instance_types" : ["t3.medium"],
    //   "ami_type": "AL2_x86_64"
    //   "labels" : {
    //     type_of_nodegroup = "spot_untainted"
    //   },
    //   "min_size" : 1,
    //   "desired_size" : 1,
    //   "max_size" : 1,
    //   "ec2_ssh_key" : "terragrunt-eks"
    // },
    // graviton_spot = {
    //   "is_private" : true,
    //   "capacity_type" : "SPOT",
    //   "instance_types" : ["m6g.medium"],
    //   "ami_type" : "AL2_ARM_64"
    //   "labels" : {
    //     type_of_nodegroup = "graviton_spot_untainted"
    //   },
    //   "min_size" : 1,
    //   "desired_size" : 1,
    //   "max_size" : 1,
    //   "ec2_ssh_key" : "terragrunt-eks"
    // },
    // graviton_ondemand = {
    //   "is_private" : false,
    //   "capacity_type" : "ON_DEMAND",
    //   "instance_types" : ["m6g.medium"],
    //   "ami_type" : "AL2_ARM_64"
    //   "labels" : {
    //     type_of_nodegroup = "graviton_ondemand_untainted"
    //   },
    //   "min_size" : 1,
    //   "desired_size" : 1,
    //   "max_size" : 1,
    //   "ec2_ssh_key" : "terragrunt-eks"
    // },
    // ondemand = {
    //   "is_private" : false,
    //   "capacity_type" : "ON_DEMAND",
    //   "instance_types" : ["t3.medium"],
    //   "ami_type": "AL2_x86_64"
    //   "labels" : {
    //     type_of_nodegroup = "ondemand_untainted"
    //   },
    //   "min_size" : 1,
    //   "desired_size" : 1,
    //   "max_size" : 1,
    //   "ec2_ssh_key" : "terragrunt-eks"
    // }
  }
}