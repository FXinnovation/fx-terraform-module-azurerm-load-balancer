output "load_balancer_ids" {
  value = module.example.lb_ids
}

output "lb_backend_pool_ids" {
  value = module.example.lb_backend_pool_ids
}

output "lb_nat_rule_ids" {
  value = module.example.lb_nat_rule_ids
}

output "lb_rule_ids" {
  value = module.example.lb_rule_ids
}

output "lb_backend_pool_ids_map" {
  value = module.example.lb_backend_pool_ids_map
}
