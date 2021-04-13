output "alb_dns" {
  value = module.ecs_deployment[*].alb_dns
}
