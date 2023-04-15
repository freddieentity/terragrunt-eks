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

  cluster_name       = var.cluster_name
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids

  node_groups        = var.node_groups
}