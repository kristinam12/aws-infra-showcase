module "vpc" {
  source       = "./vpc"
  aws_region   = var.aws_region
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  aws_zone     = var.aws_zone
}

module "eks" {
  source       = "./eks"
  aws_region   = var.aws_region
  project_name = var.project_name
  subnet_ids   = [module.vpc.public_subnet_id]  # <-- this must match your VPC output
}
