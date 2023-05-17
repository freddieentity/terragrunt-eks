output "access_cluster_command" {
  value = "To access the cluster, run 'aws eks --region us-east-1 update-kubeconfig --name ${aws_eks_cluster.main.name}'"
}

output "eks_name" {
  value = aws_eks_cluster.main.name
}

# output "openid_provider_arn" {
#   value = aws_iam_openid_connect_provider.eks.arn
# }
