output "load_balancer_ids" {
  value = module.example.lb_ids
}

output "backend_pool_ids" {
  value = module.example.backend_pool_ids
}

output "nat_rule_ids" {
  value = module.example.nat_rule_ids
}

output "lb_rule_ids" {
  value = module.example.lb_rule_ids
}

output "backend_pool_ids_map" {
  value = module.example.backend_pool_ids_map
}
