variable "eks_cluster_name" {
  type    = string
  default = ""
}

variable "openid_provider_arn" {
  type    = string
  default = ""
}

variable "helm_releases" {
  type    = map(any)
  default = {}
}