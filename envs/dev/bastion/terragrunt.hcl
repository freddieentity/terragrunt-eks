include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/terraform-aws-bastion"
}

# Acess this using syntax local.common.locals.tags
locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {

  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show"]
}

inputs = {
  ec2_instance_type   = "t2.micro"
  vpc_id              = dependency.vpc.outputs.vpc_id
  public_subnet_id    = dependency.vpc.outputs.public_subnets[0]
  security_group_ids  = []
  ec2_public_key_name = "terragrunt-eks"
}