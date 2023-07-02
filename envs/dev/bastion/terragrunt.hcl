// include "root" {
//   path = find_in_parent_folders()
// }

// terraform {
//   source = "../../../modules/terraform-aws-bastion"
// }

// locals {
//   // inputs   = yamldecode(file("inputs.yaml"))
//   env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
// }

// skip = local.env_vars.modules.bastion.skip

// dependency "vpc" {
//   config_path = "../vpc"

//   mock_outputs = {
//     vpc_id           = "id-00000000"
//     public_subnet_id = "id-00000000"
//   }
//   mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show"]
// }

// inputs = {
//   ec2_instance_type   = "t2.micro"
//   vpc_id              = dependency.vpc.outputs.vpc_id
//   public_subnet_id    = dependency.vpc.outputs.public_subnets[0]
//   security_group_ids  = []
//   ec2_public_key_name = "terragrunt-eks"
// }