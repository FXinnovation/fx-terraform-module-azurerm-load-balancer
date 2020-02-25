output "load_balancer_ids" {
  value = module.private_lb.lb_ids
}

output "lb_backend_pool_ids" {
  value = module.private_lb.lb_backend_pool_ids
}

output "lb_nat_rule_ids" {
  value = module.private_lb.lb_nat_rule_ids
}

output "lb_rule_ids" {
  value = module.private_lb.lb_rule_ids
}

output "lb_backend_pool_ids_map" {
  value = module.private_lb.lb_backend_pool_ids_map
}
