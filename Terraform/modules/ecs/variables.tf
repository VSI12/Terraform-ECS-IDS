variable "ids_ecs_cluster" {
  description = "ecs cluster name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "alb_sg" {
  description = "ALB security"
  type        = string
}
variable "alb_tg" {
  description = "ALB target group"
  type        = string
}
variable "alb_listener" {
  description = "ALB listener"
  type        = string
}
variable "container_name" {
  description = "container name"
  type        = string
}
variable "ecr_uri" {
  description = "ECR URI"
  type        = string
}
variable "ecr_arn" {
  description = "ECR ARN"
  type        = string
}

variable "subnets" {
  description = "The private subnet IDs"
  type        = list(string)
}

variable "role_name" {
  description = "ECS service role name"
  type        = string
}