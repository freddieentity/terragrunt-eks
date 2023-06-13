variable "vpc_id" {
  default = ""
}

variable "public_subnet_id" {
  default = ""
}

variable "security_group_ids" {
  default = []
}

variable "ec2_public_key_name" {
  default     = "terragrunt-eks"
  description = "Key pair for connecting to launched EC2 instances"
}

variable "ec2_instance_type" {
  description = "EC2 Instance type to launch"
  default     = "t2.micro"
}