#APPLICATION LOAD BALANCER
resource "aws_lb" "ids-alb" {
  name               = "ids-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = var.subnets

  tags = {
    name = "ecs-alb"
  }
}

#APPLICATION LOAD BALANCER LISTENER
resource "aws_lb_listener" "ids-alb-listener" {
  load_balancer_arn = aws_lb.ids-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ids-alb-tg.arn
  }
}

#TARGET GROUP
resource "aws_lb_target_group" "ids-alb-tg" {
  name        = "ids-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}