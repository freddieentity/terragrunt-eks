# IAM roles will leverage on OIDC to manage SA permissions
data "aws_iam_policy_document" "irsa_cert_manager" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:cert-manager:${local.prefix}-cert-manager"]
    }

    principals {
      identifiers = [var.eks_oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "irsa_cert_manager" {
  assume_role_policy = data.aws_iam_policy_document.irsa_cert_manager.json
  name               = "${local.prefix}-cert-manager"
}

resource "aws_iam_policy" "irsa_cert_manager" {
  name = "${local.prefix}-cert-manager"

  policy = jsonencode({
    Statement = [{
      Action = [
        "route53:*"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:route53:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "irsa_cert_manager" {
  role       = aws_iam_role.irsa_cert_manager.name
  policy_arn = aws_iam_policy.irsa_cert_manager.arn
}

output "irsa_cert_manager_policy_arn" {
  value = aws_iam_role.irsa_cert_manager.arn
}