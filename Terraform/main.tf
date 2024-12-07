terraform {
  required_version = ">= 1.9.4"
  backend "s3" {
    bucket         = "ids-project-terraform-state"
    key            = "tf-state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ids-terraform-lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.50.0"
    }
  }
}

module "tf-state" {
  source      = "./modules/tf-state"
  bucket_name = local.bucket_name
  table_name  = local.table_name
}

module "vpc" {
  source = "./modules/vpc"
}
module "ecr" {
  source        = "./modules/ecr"
  ecr_repo_name = local.ecr_repo_name
}
module "ecs" {
  source          = "./modules/ecs"
  vpc_id          = module.vpc.vpc_id
  alb_sg          = module.alb.alb_security_group_id
  ids_ecs_cluster = local.ids_ecs_cluster
  ecr_uri         = module.ecr.repository_url
  alb_tg          = module.alb.alb_tg_arn
  container_name  = local.container_name
  subnets         = module.vpc.private_subnet_ids
  role_name       = local.role_name
  alb_listener    = module.alb.aws_lb_listener
  ecr_arn         = module.ecr.repository_arn
}
