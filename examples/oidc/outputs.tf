output "iam_role_github_arns" {
  value = values(module.iam-role-github)[*].iam_role_github_arn
}