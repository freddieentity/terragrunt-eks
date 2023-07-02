output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "eks_node_group_role_arn" {
  value = aws_iam_role.eks_worker.arn
}

output "eks_fargate_profile_role_arn" {
  value = aws_iam_role.eks_fargate_profile.arn
}