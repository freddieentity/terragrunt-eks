variable "cluster_name" {
  default     = "freddieentity"
  description = "EKS Lab cluster"
}
variable "public_subnet_ids" {
  default     = []
  type        = list(string)
  description = "Public Subnets"
}
variable "private_subnet_ids" {
  default     = []
  type        = list(string)
  description = "Private Subnets"
}
variable "node_groups" {
  default     = []
  type        = list(any)
  description = "List of worker node groups"
}

variable "eks_cluster_iam_role_arn" {
  description = "IAM role attached to the EKS cluster"
  type        = string
}

variable "eks_node_group_iam_role_arn" {
  description = "IAM role attached to the EKS node group"
  type        = string
}
