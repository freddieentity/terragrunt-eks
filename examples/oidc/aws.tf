
################################################################################
# Get GitHub TLS cert
################################################################################

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}


################################################################################
# IAM OpenID Connect for GitHub
################################################################################

resource "aws_iam_openid_connect_provider" "this" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

module "iam-role-github" {
  for_each = {
    dev = {
      organization = "freddieentity"
      repository   = "gh-actions-dev"
    }
    prod = {
      organization = "freddieentity"
      repository   = "gh-actions-prod"
    }
  }
  source = "./iam-role-github"

  aws_iam_openid_connect_provider_arn = aws_iam_openid_connect_provider.this.arn
  repository_name                     = each.value.repository
  org_or_user_name                    = each.value.organization
}