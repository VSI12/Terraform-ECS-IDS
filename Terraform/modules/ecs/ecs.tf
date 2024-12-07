resource "aws_ecs_cluster" "ids-cluster" {
  name = var.ids_ecs_cluster
}


resource "aws_ecs_task_definition" "ids-task-definitions" {
  family                   = "my-task-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn  # Reference the execution role

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${var.ecr_uri}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol= "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ids-service" {
  name            = "ids-service"
  cluster         = aws_ecs_cluster.ids-cluster.id
  task_definition = aws_ecs_task_definition.ids-task-definitions.arn
  desired_count   = 1
  health_check_grace_period_seconds = 60  # Set grace period to 60 seconds
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets 
    security_groups  = [aws_security_group.ecs_sg.id]                 # Replace with your security group ID                                        # Change based on your setup
  }
  load_balancer {
    target_group_arn = var.alb_tg
    container_name   = var.container_name
    container_port   = 8080
  }

  depends_on = [var.alb_listener]
}

# Define IAM Role for ECS Service
resource "aws_iam_role" "ecs_service_role" {
  name               = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

# Attach IAM Role Policy to ECS Service Role
resource "aws_iam_role_policy" "ecs_service_policy" {
  name = "ecs-service-policy"
  role = aws_iam_role.ecs_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = "${var.ecr_arn}"  # Correctly reference the full ECR URI
      },
      {
        Effect   = "Allow"
        Action   = "ecs:UpdateService"
        Resource = "*"
      }
    ]
  })
}

# Define the execution role for ECS Task Definition
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

# Attach necessary policies to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
