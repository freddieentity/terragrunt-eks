# resource "aws_ecr_repository" "main" {
#   name                 = var.eks_cluster_name
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }