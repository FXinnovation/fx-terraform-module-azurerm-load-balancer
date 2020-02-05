output "lb_ids" {
  value = compact(concat(azurerm_lb.this.*.id, [""]))
}

output "lb_probe_ids" {
  value = compact(concat(azurerm_lb_probe.this.*.id, [""]))
}

output "nat_rule_ids" {
  value = compact(concat(azurerm_lb_nat_rule.this.*.id, [""]))
}

output "nat_pool_ids" {
  value = compact(concat(azurerm_lb_nat_pool.this.*.id, [""]))

}

output "lb_private_ip" {
  value = azurerm_lb.this.*.private_ip_address
}

output "public_ip_id" {
  description = "The id for the public_ip resource"
  value       = azurerm_public_ip.this.*.id
}

output "backend_pool_ids" {
  value = compact(concat(azurerm_lb_backend_address_pool.this.*.id, [""]))
}
