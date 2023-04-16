resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    endpoint_private_access = false # Enable when having a VPN
    endpoint_public_access  = true
    subnet_ids              = var.private_subnet_ids # EKS creates ENI across these subnets to enable communication between EKS workers and EKS controlplane
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster,
  ]
}

resource "aws_eks_node_group" "main" {
  for_each = { for index, value in var.node_groups : value.node_group_name => value }

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.value.node_group_name
  node_role_arn   = aws_iam_role.eks_cluster.arn
  instance_types  = each.value.instance_types
  subnet_ids      = var.private_subnet_ids
  capacity_type   = each.value.capacity_type

  labels = each.value.labels # Control via affinity

  scaling_config {
    min_size     = each.value.min_size
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker
  ]
}
