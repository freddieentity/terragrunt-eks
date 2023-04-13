module "networking" {
  source = "./modules/terraform-aws-vpc"

  name                = var.name
  cidr                = var.cidr
  azs                 = var.azs
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags

  single_nat_gateway = var.single_nat_gateway
}

module "eks" {
  source = "./modules/terraform-aws-eks"
}