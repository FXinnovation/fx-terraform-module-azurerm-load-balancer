output "lb_ids" {
  description = "The ids of the load balancer"
  value       = compact(concat(azurerm_lb.this.*.id, [""]))
}

output "lb_probe_ids" {
  description = "the ids of the load balncer probes."
  value       = compact(concat(azurerm_lb_probe.this.*.id, [""]))
}

output "nat_rule_ids" {
  description = "The ids of the load balncer nat rules."
  value       = compact(concat(azurerm_lb_nat_rule.this.*.id, [""]))
}

output "nat_pool_ids" {
  description = "The ids of the load balncer nat pools."
  value       = compact(concat(azurerm_lb_nat_pool.this.*.id, [""]))
}

output "lb_private_ip" {
  description = "The first private IP address assigned to the load balancer in frontend_ip_configuration."
  value       = azurerm_lb.this.*.private_ip_address
}

output "public_ip_id" {
  description = "The id for the public_ip resource"
  value       = azurerm_public_ip.this.*.id
}

output "backend_pool_ids" {
  description = "The ids of the backend address pools."
  value       = compact(concat(azurerm_lb_backend_address_pool.this.*.id, [""]))
}
