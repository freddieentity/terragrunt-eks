variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}

variable "application_subnets" {
  default = []
}

variable "security_group_ids" {
  default = []
}

variable "ec2_key_pair_name" {
  default     = "docker"
  description = "Key pair for connecting to launched EC2 instances"
}

variable "ec2_instance_type" {
  description = "EC2 Instance type to launch"
  default     = "t2.micro"
}