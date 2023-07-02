include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/irsa-v2"
}

locals {
  // inputs   = yamldecode(file("inputs.yaml"))
  env_vars = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
}

skip = local.env_vars.modules.irsa.skip

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

inputs = {
  eks_cluster_name      = dependency.eks.outputs.eks_cluster_name
  eks_oidc_provider_url = dependency.eks.outputs.eks_oidc_provider_url
  eks_oidc_provider_arn = dependency.eks.outputs.eks_oidc_provider_arn
  service_accounts = {
    cert-manager = {
      namespace = "cert-manager"
      statements = [
        {
          Action = [
            "route53:GetChange"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    },
    karpenter = {
      namespace = "karpenter" # graviton + spot
      statements = [
        {
          Action = [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeScalingActivities",
            "autoscaling:DescribeTags",
            "ec2:DescribeLaunchTemplateVersions",
            "ec2:DescribeInstanceTypes",
            "eks:DescribeNodegroup",
            "ec2:DescribeImages",
            "ec2:GetInstanceTypesFromInstanceRequirements"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    },
    ebs-csi = {
      namespace = "ebs-csi"
      statements = [
        {
          Action = [
            "ec2:CreateSnapshot",
            "ec2:AttachVolume",
            "ec2:DetachVolume",
            "ec2:ModifyVolume",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeInstances",
            "ec2:DescribeSnapshots",
            "ec2:DescribeTags",
            "ec2:DescribeVolumes",
            "ec2:DescribeVolumesModifications",
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    }
  }
}