resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    endpoint_private_access = false # Enable when having a VPN
    endpoint_public_access  = true
    subnet_ids              = var.public_subnet_ids # EKS creates ENI across these subnets to enable communication between EKS workers and EKS controlplane
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  # Config network for service ip assignment
  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  # Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # depends_on = [
  #   aws_iam_role_policy_attachment.eks_cluster,
  #   aws_cloudwatch_log_group.main
  # ]
}

resource "aws_eks_node_group" "main" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = var.eks_node_group_role_arn
  instance_types  = each.value.instance_types
  ami_type        = each.value.ami_type
  subnet_ids      = each.value.is_private ? var.private_subnet_ids : var.public_subnet_ids
  capacity_type   = each.value.capacity_type

  labels = each.value.labels # Control via affinity

  remote_access {
    ec2_ssh_key = each.value.ec2_ssh_key
  }

  scaling_config {
    min_size     = each.value.min_size
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    # aws_iam_role_policy_attachment.eks_worker
    aws_eks_cluster.main
  ]

  tags = {
    Name = each.key
  }
}

resource "aws_eks_fargate_profile" "main" {
  for_each = var.fargate_profiles

  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = each.key
  pod_execution_role_arn = var.eks_fargate_profile_role_arn

  # These subnets must have the following resource tag: 
  # kubernetes.io/cluster/<CLUSTER_NAME>.
  subnet_ids = var.private_subnet_ids # Pods run on Fargate must be in private subnets

  dynamic "selector" {
    for_each = each.value.selectors

    content {
      namespace = selector.value.namespace
      labels    = lookup(selector.value, "labels", {})
    }
  }
}
