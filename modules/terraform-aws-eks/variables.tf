variable "cluster_name" {
  default     = "freddieentity"
  description = "EKS cluster"
}
variable "cluster_version" {
  default     = "1.26"
  description = "EKS cluster version"
}
variable "cluster_service_ipv4_cidr" {
  default = "172.20.0.0/16"
  type    = string
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
  default     = {}
  type        = map(any)
  description = "List of node groups which defines a set of workers"
}
variable "eks_node_group_role_arn" {
  default = ""
  type    = string
}
variable "eks_cluster_role_arn" {
  default = ""
  type    = string
}