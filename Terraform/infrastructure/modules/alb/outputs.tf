output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb-sg.id
}
output "alb_arn" {
  description = "ALB Security Group ID"
  value       = aws_lb.ids-alb.arn
}
output "alb_tg_arn" {
  description = "ALB Security Group ID"
  value       = aws_lb_target_group.ids-alb-tg.arn
}
output "aws_lb_listener" {
  description = "ALB listener"
  value       = aws_lb_listener.ids-alb-listener.arn
}