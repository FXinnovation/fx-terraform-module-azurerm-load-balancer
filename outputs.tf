output "id_private" {
  value = element(
    concat(
      azurerm_lb.this_private.*.id,
      azurerm_lb.this_public.*.id,
      list("")
    ),
    0
  )
}

output "id_probe" {
  value = element(
    concat(
      azurerm_lb_probe.this_probe_private.*.id,
      azurerm_lb_probe.this_probe_public.*.id,
      list("")
    ),
    0
  )
}

output "id_nat_rule" {
  value = element(
    concat(
      azurerm_lb_nat_rule.this_nat_rule_private.*.id,
      azurerm_lb_nat_rule.this_nat_rule_public.*.id,
      list("")
    ),
    0
  )
}

output "lb_private_ip" {
  value = azurerm_lb.this_private.*.private_ip_address
}

output "public_ip_id" {
  description = "The id for the public_ip resource"
  value       = azurerm_public_ip.this.*.id
}

output "id_backend_pool" {
  value = element(
    concat(
      azurerm_lb_backend_address_pool.this_private.*.id,
      azurerm_lb_backend_address_pool.this_public.*.id,
      list("")
    ),
    0
  )
}
