remote_state {
  backend = "local"
  // backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    // bucket =  "freddieentity-remote-state" # "coe-iac-remote-state"
    // key    = "${path_relative_to_include()}/terraform.tfstate"
    // region = "us-east-1"
    // // encrypt        = true
    // // dynamodb_table = "freddieentity-remote-state-lock-table"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      CreatedBy      = "Terraform"
      OrchestratedBy = "Terragrunt"
      // ProjectID   = "PJ001"
      // Application = "Spoke"
      // CostCenter  = "CC102"
      // CostPool = ""
      // BusinessUnit = ""
      // SystemTierClassification = ""
      ServiceOwner = "TinNT26"
      Creator = "TinNT26"
      ProjectID = "GHSPOC2019"
      Application = "IaC"
    }
  }

//   assume_role {
//     session_name = "terragrunt"
//     role_arn = "arn:aws:iam::158904540988:role/terraform"
//   }
}
EOF
}

locals {
  vars = yamldecode(file("common.yaml"))
}