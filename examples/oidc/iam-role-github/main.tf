################################################################################
# IAM Role for GitHub
################################################################################

resource "aws_iam_role" "this" {
  name = var.repository_name

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.aws_iam_openid_connect_provider_arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.org_or_user_name}/${var.repository_name}:pull_request",
        "repo:${var.org_or_user_name}/${var.repository_name}:ref:refs/heads/main"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.this.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}