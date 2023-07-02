include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/base"
}

locals {
  // inputs   = yamldecode(file("inputs.yaml"))
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
}

skip = local.env_vars.modules.base.skip

inputs = {
  eks_cluster_name = local.env_vars.application_name
}