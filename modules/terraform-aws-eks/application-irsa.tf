# IAM roles will leverage on OIDC to manage SA permissions

data "aws_iam_policy_document" "irsa" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:application"] # Pod's SA mapped to IAM role. This SA will call AssumeRoleWithWebIdentity API to get STS
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "irsa" {
  assume_role_policy = data.aws_iam_policy_document.irsa.json
  name               = "application-irsa"
}

resource "aws_iam_policy" "irsa" {
  name = "application-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "irsa" {
  role       = aws_iam_role.irsa.name
  policy_arn = aws_iam_policy.irsa.arn
}

output "test_policy_irsa_arn" {
  value = aws_iam_role.irsa.arn
}