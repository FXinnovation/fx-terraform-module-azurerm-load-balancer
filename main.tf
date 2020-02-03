locals {
  create_private_load_balancer = var.enabled && var.type == "private"
  create_public_load_balancer  = var.enabled && var.type != "private"
  private_backend_pool_id      = var.type == "private" ? zipmap(var.backend_pool_names, compact(concat(azurerm_lb_backend_address_pool.this_private.*.id, [""]))) : {}
  public_backend_pool_id       = var.type != "private" ? zipmap(var.backend_pool_names, compact(concat(azurerm_lb_backend_address_pool.this_public.*.id, [""]))) : {}
}

###
# Private load balancer
###

resource "azurerm_lb" "this_private" {
  count               = local.create_private_load_balancer ? 1 : 0
  name                = var.loadbalancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = "${var.frontend_ip_configuration_name}-LBFG"
    subnet_id                     = var.subnet_id
    private_ip_address            = var.private_ip_address
    private_ip_address_allocation = var.private_ip_address == null ? "Dynamic" : "Static"
  }

  tags = merge(
    {
      "Terraform" = "true"
    },
    var.tags,
  )
}

resource "azurerm_lb_backend_address_pool" "this_private" {
  count               = local.create_private_load_balancer ? length(var.backend_pool_names) : 0
  name                = var.backend_pool_names[count.index]
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.this_private[0].id
}

###
# NAT pool
###

resource "azurerm_lb_nat_pool" "this_private" {
  count                          = var.nat_pool_enabled ? length(var.nat_pool_names) : 0
  name                           = element(var.nat_pool_names, count.index)
  protocol                       = element(var.nat_pool_protocols, count.index)
  backend_port                   = element(var.nat_pool_backend_ports, count.index)
  loadbalancer_id                = azurerm_lb.this_private[0].id
  resource_group_name            = var.resource_group_name
  frontend_port_start            = element(var.port_starts, count.index)
  frontend_port_end              = element(var.port_ends, count.index)
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
}

###
# NAT rules
###

resource "azurerm_lb_nat_rule" "this_nat_rule_private" {
  count                          = local.create_private_load_balancer ? length(var.nat_rule_names) : 0
  name                           = element(var.nat_rule_names, count.index)
  protocol                       = element(var.nat_protocols, count.index)
  loadbalancer_id                = azurerm_lb.this_private[0].id
  resource_group_name            = var.resource_group_name
  frontend_port                  = element(var.nat_frontend_ports, count.index)
  backend_port                   = element(var.nat_backend_ports, count.index)
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
}

resource "azurerm_lb_probe" "this_probe_private" {
  count               = local.create_private_load_balancer ? length(var.probe_names) : 0
  name                = element(var.probe_names, count.index)
  port                = element(var.probe_ports, count.index)
  protocol            = element(var.probe_protocols, count.index)
  loadbalancer_id     = azurerm_lb.this_private[0].id
  resource_group_name = var.resource_group_name
  interval_in_seconds = var.interval
  request_path        = element(var.request_paths, count.index)
}

###
# private load balancer rules
###

resource "azurerm_lb_rule" "this_lb_rule_private" {
  count                          = local.create_private_load_balancer ? length(var.lb_rule_names) : 0
  name                           = element(var.lb_rule_names, count.index)
  loadbalancer_id                = azurerm_lb.this_private[0].id
  resource_group_name            = var.resource_group_name
  protocol                       = element(var.lb_rule_protocols, count.index)
  frontend_port                  = element(var.lb_rule_frontend_ports, count.index)
  backend_port                   = element(var.lb_rule_backend_ports, count.index)
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
  backend_address_pool_id        = lookup(local.private_backend_pool_id, element(var.private_backend_pool_ids, count.index), null)
  probe_id                       = element(azurerm_lb_probe.this_probe_private.*.id, count.index)
  idle_timeout_in_minutes        = var.timeout_in_minutes
  enable_floating_ip             = var.enable_floating_ip
  depends_on                     = [azurerm_lb_probe.this_probe_private]
}

###
# public load balancer
###

resource "azurerm_public_ip" "this" {
  count               = var.type != "private" ? 1 : 0
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.method
  sku                 = var.sku
}

resource "azurerm_lb" "this_public" {
  count               = local.create_public_load_balancer ? 1 : 0
  name                = var.loadbalancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                 = "${var.frontend_ip_configuration_name}-LBFG"
    public_ip_address_id = join("", azurerm_public_ip.this.*.id)
  }

  tags = merge(
    {
      "Terraform" = "true"
    },
    var.tags,
  )
}

resource "azurerm_lb_backend_address_pool" "this_public" {
  count               = local.create_public_load_balancer ? length(var.backend_pool_names) : 0
  name                = var.backend_pool_names[count.index]
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.this_public[0].id
}

resource "azurerm_lb_nat_pool" "this_public" {
  count                          = var.nat_pool_enabled ? length(var.nat_pool_names) : 0
  name                           = element(var.nat_pool_names, count.index)
  protocol                       = element(var.nat_protocols, count.index)
  backend_port                   = element(var.nat_backend_ports, count.index)
  loadbalancer_id                = azurerm_lb.this_public[0].id
  resource_group_name            = var.resource_group_name
  frontend_port_start            = element(var.port_starts, count.index)
  frontend_port_end              = element(var.port_ends, count.index)
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
}

###
# NAT rules
###

resource "azurerm_lb_nat_rule" "this_nat_rule_public" {
  count                          = local.create_public_load_balancer ? length(var.nat_rule_names) : 0
  name                           = element(var.nat_rule_names, count.index)
  protocol                       = element(var.nat_protocols, count.index)
  loadbalancer_id                = azurerm_lb.this_public[0].id
  resource_group_name            = var.resource_group_name
  frontend_port                  = element(var.nat_frontend_ports, count.index)
  backend_port                   = element(var.nat_backend_ports, count.index)
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
}

resource "azurerm_lb_probe" "this_probe_public" {
  count               = local.create_public_load_balancer ? length(var.probe_names) : 0
  name                = element(var.probe_names, count.index)
  port                = element(var.probe_ports, count.index)
  protocol            = element(var.probe_protocols, count.index)
  loadbalancer_id     = azurerm_lb.this_public[0].id
  resource_group_name = var.resource_group_name
  interval_in_seconds = var.interval
  request_path        = element(var.request_paths, count.index)
}

###
# public load balancer rules
###

resource "azurerm_lb_rule" "this_lb_rule_public" {
  count                          = local.create_public_load_balancer ? length(var.lb_rule_names) : 0
  name                           = element(var.lb_rule_names, count.index)
  loadbalancer_id                = azurerm_lb.this_public[0].id
  resource_group_name            = var.resource_group_name
  protocol                       = element(var.lb_rule_protocols, count.index)
  frontend_port                  = element(var.lb_rule_frontend_ports, count.index)
  backend_port                   = element(var.lb_rule_backend_ports, count.index)
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
  backend_address_pool_id        = lookup(local.public_backend_pool_id, element(var.public_backend_pool_ids, count.index), null)
  probe_id                       = element(azurerm_lb_probe.this_probe_public.*.id, count.index)
  idle_timeout_in_minutes        = var.timeout_in_minutes
  enable_floating_ip             = var.enable_floating_ip
  depends_on                     = [azurerm_lb_probe.this_probe_public]
}
