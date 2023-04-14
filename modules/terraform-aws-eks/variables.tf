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
# ON DEMAND
variable "on_demand_instance_types" {
  default     = ["t3.medium", "t3.large"]
  description = "On Demand instance type"
}
variable "on_demand_min_size" {
  default     = 1
  description = "How many On Demand instances should be running at all times"
}
variable "on_demand_max_size" {
  default     = 1
  description = "How many On Demand instances should be running at all times"
}
variable "on_demand_desired_size" {
  default     = 1
  description = "How many On Demand instances should be running at all times"
}
# SPOT
variable "spot_instance_types" {
  default     = ["t3.medium", "t3.large"]
  description = "List of instance types for SPOT instance selection"
}
variable "spot_min_size" {
  default     = 1
  description = "How many SPOT instance can be created max"
}
variable "spot_max_size" {
  default     = 1
  description = "How many SPOT instance can be created max"
}
variable "spot_desired_size" {
  default     = 1
  description = "How many SPOT instance should be running at all times"
}
