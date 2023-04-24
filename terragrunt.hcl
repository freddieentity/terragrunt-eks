remote_state {
  //   backend = "local"
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    // path = "${path_relative_to_include()}/terraform.tfstate"
    bucket = "freddieentity-remote-state"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-1"
    // encrypt        = true
    // dynamodb_table = "freddieentity-remote-state-lock-table"
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
    //   Environment = var.environment
      ProjectID   = "pj001"
      Application = "mock"
      CostCenter  = "cc101"
    }
  }
//   region = var.aws_region
//   profile = var.aws_profile

//   assume_role {
//     session_name = "terragrunt"
//     role_arn = "arn:aws:iam::158904540988:role/terraform"
//   }
}
EOF
}