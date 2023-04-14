# Common
aws_region  = "us-east-1"
environment = "dev"
project_id  = "pj001"
application = "mock"
cost_center = "cc101"
# VPC
cidr = "10.0.0.0/16"
azs  = ["us-east-1a", "us-east-1b", "us-east-1c"]
name = "my-vpc"
public_subnets = [
  {
    "name" : "",
    "cidr" : "10.0.1.0/24",
    "az" : "",
    "tags" : []
  },
  {
    "name" : "",
    "cidr" : "10.0.2.0/24",
    "az" : "",
    "tags" : []
  },
  {
    "name" : "",
    "cidr" : "10.0.3.0/24",
    "az" : "",
    "tags" : []
  }
]
private_subnets = [
  {
    "name" : "",
    "cidr" : "10.0.101.0/24",
    "az" : "",
    "tags" : []
  },
  {
    "name" : "",
    "cidr" : "10.0.102.0/24",
    "az" : "",
    "tags" : []
  },
  {
    "name" : "",
    "cidr" : "10.0.103.0/24",
    "az" : "",
    "tags" : []
  }
]
public_subnet_tags = {
  "kubernetes.io/role/elb"                    = "1"
  "kubernetes.io/cluster/my-eks-cluster-name" = "owned"
}
private_subnet_tags = {
  "kubernetes.io/role/internal-elb"           = "1"
  "kubernetes.io/cluster/my-eks-cluster-name" = "owned"
}
single_nat_gateway = true
# EKS