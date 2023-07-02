# data "aws_iam_policy_document" "irsa" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:default:${local.prefix}-application"] 
#     }

#     principals {
#       identifiers = [var.eks_oidc_provider_arn]
#       type        = "Federated"
#     }
#   }
# }

resource "aws_iam_role" "irsa" {
  for_each = var.service_accounts
  name     = each.key
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${var.eks_oidc_provider_url}:sub" = "system:serviceaccount:${each.value.namespace}:${each.key}"
          }
        }
        Effect = "Allow"
        Principal = {
          Federated = "${var.eks_oidc_provider_arn}"
        }
      },
    ]
  })
  dynamic "inline_policy" {
    for_each = each.value.statements
    content {
      name = "policy-${inline_policy.key}"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Action   = inline_policy.value.Action
          Effect   = inline_policy.value.Effect
          Resource = inline_policy.value.Resource
        }]
      })
    }
  }
}

# resource "aws_iam_policy" "irsa" {
#   name = "${local.prefix}-application"

#   policy = jsonencode({
#     Statement = [{
#       Action = [
#         "s3:ListAllMyBuckets",
#         "s3:GetBucketLocation"
#       ]
#       Effect   = "Allow"
#       Resource = "arn:aws:s3:::*"
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "irsa" {
#   role       = aws_iam_role.irsa.name
#   policy_arn = aws_iam_policy.irsa.arn
# }

output "irsa_arn" {
  value = values(aws_iam_role.irsa.arn)[*]
}