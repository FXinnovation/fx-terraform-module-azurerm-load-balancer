output "lb_ids" {
  description = "The IDs of the Load Balancers"
  value       = compact(concat(azurerm_lb.this.*.id, [""]))
}

output "lb_probe_ids" {
  description = "the IDs of the Load Balncer probes."
  value       = compact(concat(azurerm_lb_probe.this.*.id, [""]))
}

output "nat_rule_ids" {
  description = "The IDs of the Load Balncer NAT rules."
  value       = compact(concat(azurerm_lb_nat_rule.this.*.id, [""]))
}

output "nat_pool_ids" {
  description = "The IDs of the Load Balncer NAT pools."
  value       = compact(concat(azurerm_lb_nat_pool.this.*.id, [""]))
}

output "lb_rule_ids" {
  description = "The IDs of the Load Balancer Rules. "
  value       = compact(concat(azurerm_lb_rule.this.*.id, [""]))
}

output "public_ip_ids" {
  description = "The IDs for the public_ip resource"
  value       = azurerm_public_ip.this.*.id
}

output "backend_pool_ids" {
  description = "The IDs of the backend address pools."
  value       = compact(concat(azurerm_lb_backend_address_pool.this.*.id, [""]))
}

output "backend_pool_ids_map" {
  description = "Map with names and IDs of created backend pools."
  value       = zipmap(var.backend_pool_names, compact(concat(azurerm_lb_backend_address_pool.this.*.id, [""])))
}

output "frontend_ip_configuartion_addresses" {
  description = "The list of private ip address assigned to the load balancer in `frontend_ip_configuration blocks`, if any."
  value       = compact(concat(azurerm_lb.this.*.private_ip_address, [""]))
}
