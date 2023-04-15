data "aws_iam_policy_document" "autoscaler" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"] # SA cluster-autoscaler in kube-system is able to call AssumeRoleWithWebIdentity API to get STS
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.autoscaler.json # Grant EKS workers permission to access ASG to change size
  name               = "eks-cluster-autoscaler"
}

resource "aws_iam_policy" "autoscaler" {
  name = "eks-cluster-autoscaler"

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

resource "aws_iam_role_policy_attachment" "autoscaler_attach" {
  role       = aws_iam_role.autoscaler.name
  policy_arn = aws_iam_policy.autoscaler.arn
}

output "autoscaler_irsa_arn" {
  value = aws_iam_role.autoscaler.arn
}
