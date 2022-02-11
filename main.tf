module "ec2" {
  source = "./modules/vpc"

  name            = "container-nw"
  zones           = ["${"ap-northeast-1"}a", "${"ap-northeast-1"}c"]
  tags            = local.tags
  vpc_cidr        = local.vpc_cidr
  public_cidr     = local.public_cidr
  private_cidr    = local.private_cidr
  db_cidr         = local.db_cidr
  management_cidr = local.management_cidr
}

module "ecr" {
  source = "./modules/ecr"
  name   = "frontend"
}

# module "ecs_cluster" {
#   source       = "./modules/ecs"
#   cluster_name = "mycluster"
#   region = local.region
#   tags = local.tags

# }

# module "db" {

# }
