// include "root" {
//   path = find_in_parent_folders()
// }

// terraform {
//   source = "../../../modules/terraform-aws-bastion"
// }

// # Acess this using syntax local.common.locals.tags
// locals {
//   common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
// }

// dependency "vpc" {
//   config_path = "../vpc"

//   mock_outputs = {

//   }
//   mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show"]
// }

// inputs = {
// }