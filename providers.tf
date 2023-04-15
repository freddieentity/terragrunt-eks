provider "aws" {
  region = var.aws_region
  #   profile = var.aws_profile

  default_tags {
    tags = {
      Environment = var.environment
      ProjectID   = var.project_id
      Application = var.application
      CostCenter  = var.cost_center
    }
  }

  # assume_role {
  #   role_arn = var.aws_destination_account_assume_role_arn
  # }
}