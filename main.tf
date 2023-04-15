module "networking" {
  source = "./modules/terraform-aws-vpc"

  name                = var.name
  cidr                = var.cidr
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags

  single_nat_gateway = var.single_nat_gateway
}

module "eks" {
  source = "./modules/terraform-aws-eks"

  cluster_name = "fredeks"
  public_subnet_ids = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  # ON DEMAND
  on_demand_instance_types = ["t3.medium"]
  on_demand_min_size = 1
  on_demand_max_size = 1
  on_demand_desired_size = 1
  # SPOT
  spot_instance_types = ["t3.medium"]
  spot_min_size = 1
  spot_max_size = 1
  spot_desired_size = 1
}