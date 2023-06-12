include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/irsa"
}

# Acess this using syntax local.common.locals.tags
locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

dependency "eks" {
  config_path = "../eks"

  # Must have when execute plan due to variables deps. The variables must have a desired type in the module
  mock_outputs = {
    eks_cluster_name      = "freddieentity"
    eks_oidc_provider_url = "https://oidc.eks.us-east-1.amazonaws.com/id/XXXXXXXXXXXXXXXXXXXXX"
    eks_oidc_provider_arn = "eks_oidc_provider_arn"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show"]
}

generate "kubernetes_provider" {
  path      = "kubernetes-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
// data "aws_eks_cluster" "main" {
//     name = var.eks_cluster_name
// }

// data "aws_eks_cluster_auth" "main" {
//     name = var.eks_cluster_name
// }

// provider "kubernetes" {
//   host                   = data.aws_eks_cluster.main.endpoint
//   cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
//   token                  = data.aws_eks_cluster_auth.main.token
// }
EOF
}

inputs = {
  eks_cluster_name      = dependency.eks.outputs.eks_cluster_name
  eks_oidc_provider_url = dependency.eks.outputs.eks_oidc_provider_url
  eks_oidc_provider_arn = dependency.eks.outputs.eks_oidc_provider_arn
}