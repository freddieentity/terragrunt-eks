include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/terraform-kubernetes-addons"
}

# Acess this using syntax local.common.locals.tags
locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  ingress-nginx-values = [ file("./values/ingress-nginx-values.yaml") ]
  cert-manager-values = [ file("./values/cert-manager-values.yaml") ]
  argocd-values = [ file("./values/argocd-values.yaml") ]
  flux2-values = [ file("./values/flux2-values.yaml") ]
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks_name            = "mock-cluster"
    openid_provider_arn = "arn:aws:iam::123456789012:mock-oidc-provider"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show"]
}

generate "helm_provider" {
  path      = "helm-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "aws_eks_cluster" "main" {
    name = var.eks_name
}

data "aws_eks_cluster_auth" "main" {
    name = var.eks_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.main.token
  }
}

// # For local module testing only
// provider "helm" { 
//   kubernetes {
//     config_path    = pathexpand("~/.kube/config")
//     config_context = "kind-platform"
//   }
// }
EOF
}

inputs = {
    eks_name = dependency.eks.outputs.eks_name
    openid_provider_arn = dependency.eks.outputs.openid_provider_arn
  helm_releases = {
    ingress-nginx = {
      name       = "ingress-nginx"
      repository = "https://kubernetes.github.io/ingress-nginx"
      chart      = "ingress-nginx"
      version    = "4.0.6"
      wait       = false
      timeout    = "1200"

      namespace        = "ingress-nginx"
      create_namespace = true

      values = local.ingress-nginx-values
    },
    cert-manager = {
      name       = "cert-manager"
      repository = "https://charts.jetstack.io"
      chart      = "cert-manager"
      version    = "1.6.0"
      wait       = false
      timeout    = "1200"

      namespace        = "cert-manager"
      create_namespace = true

      values = local.cert-manager-values
      #   override_values = {}
    },
    // argocd = {
    //   name       = "argocd"
    //   repository = "https://argoproj.github.io/argo-helm"
    //   chart      = "argo-cd"
    //   version    = "5.16.0"
    //   wait       = false
    //   timeout    = "1200"

    //   namespace        = "argocd"
    //   create_namespace = true

    //   values = local.argocd-values
    //   #   override_values = {}
    // },
    flux2 = {
      name       = "flux2"
      repository = "https://fluxcd-community.github.io/helm-charts"
      chart      = "flux2"
      version    = "2.7.0"
      wait       = false
      timeout    = "1200"

      namespace        = "flux2"
      create_namespace = true

      values = local.flux2-values
      #   override_values = {}
    }
  }
}