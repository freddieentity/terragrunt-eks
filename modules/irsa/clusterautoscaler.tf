data "aws_iam_policy_document" "clusterautoscaler" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:clusterautoscaler"] # SA clusterautoscaler in kube-system is able to call AssumeRoleWithWebIdentity API to get STS
    }

    principals {
      identifiers = [var.eks_oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "clusterautoscaler" {
  assume_role_policy = data.aws_iam_policy_document.clusterautoscaler.json # Grant EKS workers permission to access ASG to change size
  name               = "${local.prefix}-clusterautoscaler"
}

resource "aws_iam_policy" "clusterautoscaler" {
  name = "${local.prefix}-clusterautoscaler"

  policy = jsonencode({
    Statement = [{
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "clusterautoscaler" {
  role       = aws_iam_role.clusterautoscaler.name
  policy_arn = aws_iam_policy.clusterautoscaler.arn
}

output "irsa_clusterautoscaler_policy_arn" {
  value = aws_iam_role.clusterautoscaler.arn
}
