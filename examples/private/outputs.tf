output "load_balncer_id" {
  value = module.private_lb.load_balncer_id
}

output "backend_pool_id" {
  value = module.private_lb.backend_pool_id
}

output "nat_rule_ids" {
  value = module.private_lb.nat_rule_ids
}

output "lb_rule_ids" {
  value = module.private_lb.lb_rule_ids
}
