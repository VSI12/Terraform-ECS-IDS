locals {
  bucket_name     = "ids-project-terraform-state"
  table_name      = "ids-terraform-lock"
  ecr_repo_name   = "ids-repo"
  ids_ecs_cluster = "ids-cluster"
  container_name  = "ids-container"
  role_name       = "ecs-service-role"
}