# IAM roles will leverage on OIDC to manage SA permissions

data "aws_iam_policy_document" "irsa" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:application"] # Pod's SA mapped to IAM role. This SA will call AssumeRoleWithWebIdentity API to get STS
    }

    principals {
      identifiers = [var.eks_oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "irsa" {
  assume_role_policy = data.aws_iam_policy_document.irsa.json
  name               = "${local.prefix}-application"
}

resource "aws_iam_policy" "irsa" {
  name = "${local.prefix}-application"

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

# Resource: Kubernetes Service Account
resource "kubernetes_service_account_v1" "irsa" {
  depends_on = [aws_iam_role_policy_attachment.irsa]
  metadata {
    name = "${local.prefix}-application"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa.arn
    }
  }
} # Create pod using this SA to test aws cli API calls

# Resource: Kubernetes Job # For testing IRSA
resource "kubernetes_job_v1" "irsa" {
  metadata {
    name = "${local.prefix}-application"
  }
  spec {
    template {
      metadata {
        labels = {
          app = "${local.prefix}-application"
        }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.irsa.metadata.0.name
        container {
          name    = "${local.prefix}-application"
          image   = "amazon/aws-cli:latest"
          command = ["/bin/bash", "-c", "--"]
          args    = ["while true; do sleep 30; done;"]
        }
        restart_policy = "Never"
      }
    }
  }
}