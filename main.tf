locals {
  backend_pool_ids = zipmap(var.backend_pool_names, compact(concat(azurerm_lb_backend_address_pool.this.*.id, [""])))
}

###
# public IP
###

resource "azurerm_public_ip" "this" {
  count = var.type != "private" ? 1 : 0

  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_method
  sku                 = var.public_ip_sku
}

###
# load balancer
###

resource "azurerm_lb" "this" {
  count = var.enabled ? 1 : 0

  name                = var.loadbalancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = var.frontend_ip_configuration_name
    subnet_id                     = var.frontend_subnet_id
    private_ip_address            = var.frontend_private_ip_address
    private_ip_address_allocation = var.frontend_private_ip_address_allocation
    public_ip_address_id          = var.type != "private" ? join("", azurerm_public_ip.this.*.id) : ""
  }

  tags = merge(
    var.tags,
    var.load_balancer_tags,
    {
      "Terraform" = "true"
    },
  )
}

resource "azurerm_lb_backend_address_pool" "this" {
  count = var.enabled ? length(var.backend_pool_names) : 0

  name                = var.backend_pool_names[count.index]
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.this[0].id
}

###
# NAT pool
###

resource "azurerm_lb_nat_pool" "this" {
  count = var.nat_pool_enabled ? length(var.nat_pool_names) : 0

  name                           = element(var.nat_pool_names, count.index)
  protocol                       = element(var.nat_pool_protocols, count.index)
  backend_port                   = element(var.nat_pool_backend_ports, count.index)
  loadbalancer_id                = azurerm_lb.this[0].id
  resource_group_name            = var.resource_group_name
  frontend_port_start            = element(var.port_starts, count.index)
  frontend_port_end              = element(var.port_ends, count.index)
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
}

###
# NAT rules
###

resource "azurerm_lb_nat_rule" "this" {
  count = var.enabled ? length(var.nat_rule_names) : 0

  name                           = element(var.nat_rule_names, count.index)
  protocol                       = element(var.nat_protocols, count.index)
  loadbalancer_id                = azurerm_lb.this[0].id
  resource_group_name            = var.resource_group_name
  frontend_port                  = element(var.nat_frontend_ports, count.index)
  backend_port                   = element(var.nat_backend_ports, count.index)
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
}

resource "azurerm_lb_probe" "this" {
  count = var.enabled ? length(var.probe_names) : 0

  name                = element(var.probe_names, count.index)
  port                = element(var.probe_ports, count.index)
  protocol            = element(var.probe_protocols, count.index)
  loadbalancer_id     = azurerm_lb.this[0].id
  resource_group_name = var.resource_group_name
  interval_in_seconds = var.interval
  request_path        = element(var.request_paths, count.index)
}

###
# load balancer rules
###

resource "azurerm_lb_rule" "this" {
  count = var.enabled ? length(var.lb_rule_names) : 0

  name                           = element(var.lb_rule_names, count.index)
  loadbalancer_id                = azurerm_lb.this[0].id
  resource_group_name            = var.resource_group_name
  protocol                       = element(var.lb_rule_protocols, count.index)
  frontend_port                  = element(var.lb_rule_frontend_ports, count.index)
  backend_port                   = element(var.lb_rule_backend_ports, count.index)
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  backend_address_pool_id        = lookup(local.backend_pool_ids, element(var.backend_pool_ids, count.index), null)
  probe_id                       = element(azurerm_lb_probe.this.*.id, count.index)
  idle_timeout_in_minutes        = var.timeout_in_minutes
  enable_floating_ip             = var.enable_floating_ip
  depends_on                     = [azurerm_lb_probe.this]
}
