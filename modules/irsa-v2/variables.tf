variable "eks_cluster_name" {
  type    = string
  default = ""
}

variable "eks_oidc_provider_url" {
  type    = string
  default = ""
}

variable "eks_oidc_provider_arn" {
  type    = string
  default = ""
}
variable "service_accounts" {
  type    = map(any)
  default = {}
}