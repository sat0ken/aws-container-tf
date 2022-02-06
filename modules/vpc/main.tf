module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.vpc_cidr

  azs              = var.zones
  private_subnets  = var.private_cidr
  public_subnets   = concat(var.public_cidr, var.management_cidr)
  database_subnets = var.db_cidr

  enable_nat_gateway   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = var.name })
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}