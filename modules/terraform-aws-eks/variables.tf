variable "cluster_name" {
  default     = "freddieentity"
  description = "EKS Lab cluster"
}
variable "public_subnet_ids" {
  default     = []
  description = "Public Subnets"
}
variable "private_subnet_ids" {
  default     = []
  description = "Private Subnets"
}
variable "node_groups" {
  default = []
  description = "List of worker node groups"
}
