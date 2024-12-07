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
