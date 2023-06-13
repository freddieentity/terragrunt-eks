include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/base"
}

# Acess this using syntax local.common.locals.tags
locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

inputs = {
  eks_cluster_name = local.common.locals.eks_cluster_name
}