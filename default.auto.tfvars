# Common
aws_region  = "us-east-1"
environment = "dev"
project_id  = "pj001"
application = "mock"
cost_center = "cc101"
# VPC
cidr = "10.0.0.0/16"
name = "my-vpc"
public_subnets = [
  {
    "name" : "public-subnet-1",
    "cidr" : "10.0.1.0/24",
    "az" : "us-east-1a",
    "tags" : {}
  },
  {
    "name" : "public-subnet-2",
    "cidr" : "10.0.2.0/24",
    "az" : "us-east-1b",
    "tags" : {}
  },
  {
    "name" : "public-subnet-3",
    "cidr" : "10.0.3.0/24",
    "az" : "us-east-1c",
    "tags" : {}
  }
]
private_subnets = [
  {
    "name" : "private-subnet-1",
    "cidr" : "10.0.101.0/24",
    "az" : "us-east-1a",
    "tags" : {}
  },
  {
    "name" : "private-subnet-2",
    "cidr" : "10.0.102.0/24",
    "az" : "us-east-1b",
    "tags" : {}
  },
  {
    "name" : "private-subnet-3",
    "cidr" : "10.0.103.0/24",
    "az" : "us-east-1c",
    "tags" : {}
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
cluster_name = "freddieentity"
node_groups = [
  {
    "node_group_name" : "spot",
    "capacity_type" : "SPOT",
    "instance_types" : ["t3.medium"],
    "labels" : {
      type_of_nodegroup = "spot_untainted"
    },
    "min_size" : 1,
    "desired_size" : 1,
    "max_size" : 1
  },
  {
    "node_group_name" : "ondemand",
    "capacity_type" : "ON_DEMAND",
    "instance_types" : ["t3.medium"],
    "labels" : {
      type_of_nodegroup = "on_demand_untainted"
    },
    "min_size" : 1,
    "desired_size" : 1,
    "max_size" : 1
  }
]