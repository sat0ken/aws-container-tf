locals {
  region          = "ap-northeast-1"
  vpc_cidr        = "10.0.0.0/16"
  public_cidr     = cidrsubnets(local.vpc_cidr, 8, 8)
  private_cidr    = [cidrsubnet(local.vpc_cidr, 8, 9), cidrsubnet(local.vpc_cidr, 8, 10)]
  db_cidr         = [cidrsubnet(local.vpc_cidr, 8, 16), cidrsubnet(local.vpc_cidr, 8, 17)]
  management_cidr = [cidrsubnet(local.vpc_cidr, 8, 240), cidrsubnet(local.vpc_cidr, 8, 241)]

  tags = {
    User        = "sat0ken"
    Terraform   = "true"
    Environment = "dev"
  }
}