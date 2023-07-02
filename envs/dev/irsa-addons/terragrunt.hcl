// include "root" {
//   path = find_in_parent_folders()
// }

// terraform {
//   source = "tfr://registry.terraform.io/terraform-aws-modules/iam/aws/modules/iam-role-for-service-accounts-eks?version=5.3.1"
// }

// locals {
//   // inputs   = yamldecode(file("inputs.yaml"))
//   env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
// }

// skip = local.env_vars.modules.irsa.skip

// dependency "eks" {
//   config_path = "../eks"

//   # Must have when execute plan due to variables deps. The variables must have a desired type in the module
//   mock_outputs = {
//     eks_cluster_name      = "freddieentity"
//     eks_oidc_provider_url = "https://oidc.eks.us-east-1.amazonaws.com/id/XXXXXXXXXXXXXXXXXXXXX"
//     eks_oidc_provider_arn = "eks_oidc_provider_arn"
//   }
//   mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show"]
// }

// // for_each = {
// //   aws-load-balancer-controller = {
// //     attach_load_balancer_controller_policy = true
// //     namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
// //   }
// // }

// inputs = {
//   eks_cluster_name      = dependency.eks.outputs.eks_cluster_name
//   eks_oidc_provider_url = dependency.eks.outputs.eks_oidc_provider_url
//   eks_oidc_provider_arn = dependency.eks.outputs.eks_oidc_provider_arn
//   role_name = "aws-load-balancer-controller"

//   attach_load_balancer_controller_policy = true

//   oidc_providers = {
//     ex = {
//       provider_arn               = module.eks.oidc_provider_arn
//       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
//     }
//   }
// }