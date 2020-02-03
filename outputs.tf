output "lb_ids" {
  value = element(
    concat(
      azurerm_lb.this_private.*.id,
      azurerm_lb.this_public.*.id,
      list("")
    ),
    0
  )
}

output "lb_probe_ids" {
  value = element(
    concat(
      azurerm_lb_probe.this_probe_private.*.id,
      azurerm_lb_probe.this_probe_public.*.id,
      list("")
    ),
    0
  )
}

output "nat_rule_ids" {
  value = element(
    concat(
      azurerm_lb_nat_rule.this_nat_rule_private.*.id,
      azurerm_lb_nat_rule.this_nat_rule_public.*.id,
      list("")
    ),
    0
  )
}

output "nat_pool_ids" {
  value = element(
    concat(
      azurerm_lb_nat_pool.this_private.*.id,
      azurerm_lb_nat_pool.this_public.*.id,
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

output "backend_pool_ids" {
  value = element(
    concat(
      azurerm_lb_backend_address_pool.this_private.*.id,
      azurerm_lb_backend_address_pool.this_public.*.id,
      list("")
    ),
    0
  )
}
