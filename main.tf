module "ecs_deployment" {
  count              = var.deploy
  source             = "./ecs-deployment"
  availability_zones = var.availability_zones
  cluster_name       = var.cluster_name
  public_subnets     = var.public_subnets
  vpc_cidr_block     = var.vpc_cidr_block

  providers = {
    aws = aws
  }
}