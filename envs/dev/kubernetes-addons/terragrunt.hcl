include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/kubernetes-addons"
}

# Acess this using syntax local.common.locals.tags
locals {
  // inputs   = yamldecode(file("inputs.yaml"))
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))

  ingress-nginx-values = [file("./values/ingress-nginx-values.yaml")]
  aws-load-balancer-controller-values = [file("./values/aws-load-balancer-controller-values.yaml")]
  cert-manager-values  = [file("./values/cert-manager-values.yaml")]
  argocd-values        = [file("./values/argocd-values.yaml")]
}

skip = local.env_vars.modules.kubernetes-addons.skip

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks_cluster_name = "mock-cluster"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "show"]
}

generate "helm_provider" {
  path      = "helm-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "aws_eks_cluster" "main" {
    name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "main" {
    name = var.eks_cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.main.id]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.main.id]
    command     = "aws"
  }
}
EOF
}

inputs = {
  eks_cluster_name = dependency.eks.outputs.eks_cluster_name
  helm_releases = {
    // ingress-nginx = {
    //   name       = "ingress-nginx"
    //   repository = "https://kubernetes.github.io/ingress-nginx"
    //   chart      = "ingress-nginx"
    //   version    = "4.0.6"
    //   wait       = false
    //   timeout    = "1200"

    //   namespace        = "ingress-nginx"
    //   create_namespace = true

    //   values = local.ingress-nginx-values
    // },
    aws-load-balancer-controller = {
      name       = "aws-load-balancer-controller"
      repository = "https://aws.github.io/eks-charts"
      chart      = "aws-load-balancer-controller"
      version    = "1.4.4"
      wait       = false
      timeout    = "1200"

      namespace        = "kube-system"
      create_namespace = true

      values = local.aws-load-balancer-controller-values
    },
    // cert-manager = {
    //   name       = "cert-manager"
    //   repository = "https://charts.jetstack.io"
    //   chart      = "cert-manager"
    //   version    = "1.6.0"
    //   wait       = false
    //   timeout    = "1200"

    //   namespace        = "cert-manager"
    //   create_namespace = true

    //   values = local.cert-manager-values
    //   #   override_values = {}
    // },
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
    // }
  }
}