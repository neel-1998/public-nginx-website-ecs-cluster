output "alb_dns" {
  value = join("", aws_lb.ecs_lb.*.dns_name)
}
