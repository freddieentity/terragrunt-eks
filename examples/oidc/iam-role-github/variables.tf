variable "aws_iam_openid_connect_provider_arn" {
  type    = string
  default = "value"
}
variable "org_or_user_name" {
  description = "Name of GitHub Org or User that can assume IAM role"
  type        = string
  default     = "freddieentity"
}

## The name of the repository MUST be a name that you currently DO NOT possess! The repository will be created using Terraform.

variable "repository_name" {
  description = "Name of GitHub repository that can assume IAM role"
  type        = string
  default     = "gh-actions-oidc"
}
