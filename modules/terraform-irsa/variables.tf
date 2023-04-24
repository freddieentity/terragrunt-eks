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
