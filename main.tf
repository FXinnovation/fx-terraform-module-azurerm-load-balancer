###
# Private-LB
###

resource "azurerm_lb" "this_private" {
  count               = var.enabled && var.type == "private" ? 1 : 0
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
  for_each            = var.enabled && var.type == "private" ? var.backend_pools : {}
  name                = each.value["backend_pool_name"]
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.this_private[0].id
}

resource "azurerm_lb_nat_pool" "this_private" {
  for_each                       = var.nat_pool_enabled ? var.nat_rules : {}
  name                           = each.value["nat_pool_name"]
  protocol                       = each.value["nat_protocol"]
  backend_port                   = each.value["nat_backend_port"]
  loadbalancer_id                = azurerm_lb.this_private[0].id
  resource_group_name            = var.resource_group_name
  frontend_port_start            = each.value["port_start"]
  frontend_port_end              = each.value["port_end"]
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
}

###
# NAT rules
###

resource "azurerm_lb_nat_rule" "this_nat_rule_private" {
  for_each                       = var.enabled && var.type == "private" ? var.nat_rules : {}
  name                           = each.value["nat_rule_name"]
  protocol                       = each.value["nat_protocol"]
  loadbalancer_id                = azurerm_lb.this_private[0].id
  resource_group_name            = var.resource_group_name
  frontend_port                  = each.value["frontend_port"]
  backend_port                   = each.value["backend_port"]
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
}

resource "azurerm_lb_probe" "this_probe_private" {
  for_each            = var.enabled && var.type == "private" ? var.lbrules : {}
  name                = each.value["probe_name"]
  port                = each.value["port_probe"]
  protocol            = each.value["protocol_probe"]
  request_path        = each.value["protocol_probe"] == "Tcp" ? "" : each.value["request_path"]
  loadbalancer_id     = azurerm_lb.this_private[0].id
  resource_group_name = var.resource_group_name
  interval_in_seconds = var.interval
}

###
# LB Rules
###

resource "azurerm_lb_rule" "this_lb_rule_private" {
  for_each                       = var.enabled && var.type == "private" ? var.lbrules : {}
  name                           = each.value["rule_name"]
  loadbalancer_id                = azurerm_lb.this_private[0].id
  resource_group_name            = var.resource_group_name
  protocol                       = each.value["lb_rule_protocol"]
  frontend_port                  = each.value["frontend_port"]
  backend_port                   = each.value["backend_port"]
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
  backend_address_pool_id        = lookup(azurerm_lb_backend_address_pool.this_private, each.value["backend_pool_key"], )["id"]
  probe_id                       = lookup(azurerm_lb_probe.this_probe_private, each.key)["id"]
  idle_timeout_in_minutes        = var.timeout_in_minutes
  depends_on                     = [azurerm_lb_probe.this_probe_private]
}

###
# Public-LB
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
  count               = var.enabled && var.type != "private" ? 1 : 0
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
  for_each            = var.enabled && var.type != "private" ? var.backend_pools : {}
  name                = each.value["backend_pool_name"]
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.this_public[0].id
}

resource "azurerm_lb_nat_pool" "this_public" {
  for_each                       = var.nat_pool_enabled && var.type != "private" ? var.nat_rules : {}
  name                           = each.value["nat_pool_name"]
  protocol                       = each.value["nat_protocol"]
  backend_port                   = each.value["nat_backend_port"]
  loadbalancer_id                = azurerm_lb.this_public[0].id
  resource_group_name            = var.resource_group_name
  frontend_port_start            = each.value["port_start"]
  frontend_port_end              = each.value["port_end"]
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
}

###
# NAT rules
###

resource "azurerm_lb_nat_rule" "this_nat_rule_public" {
  for_each                       = var.enabled && var.type != "private" ? var.nat_rules : {}
  name                           = each.value["nat_rule_name"]
  protocol                       = each.value["nat_protocol"]
  loadbalancer_id                = azurerm_lb.this_public[0].id
  resource_group_name            = var.resource_group_name
  frontend_port                  = each.value["frontend_port"]
  backend_port                   = each.value["backend_port"]
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
}

resource "azurerm_lb_probe" "this_probe_public" {
  for_each            = var.enabled && var.type != "private" ? var.lbrules : {}
  name                = each.value["probe_name"]
  port                = each.value["port_probe"]
  protocol            = each.value["protocol_probe"]
  request_path        = each.value["protocol_probe"] == "Tcp" ? "" : each.value["request_path"]
  loadbalancer_id     = azurerm_lb.this_public[0].id
  resource_group_name = var.resource_group_name
  interval_in_seconds = var.interval
}

###
# LB Rules
###

resource "azurerm_lb_rule" "this_lb_rule_public" {
  for_each                       = var.enabled && var.type != "private" ? var.lbrules : {}
  name                           = each.value["rule_name"]
  loadbalancer_id                = azurerm_lb.this_public[0].id
  resource_group_name            = var.resource_group_name
  protocol                       = each.value["lb_rule_protocol"]
  frontend_port                  = each.value["frontend_port"]
  backend_port                   = each.value["backend_port"]
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}-LBFG"
  backend_address_pool_id        = lookup(azurerm_lb_backend_address_pool.this_public, each.value["backend_pool_key"], )["id"]
  probe_id                       = lookup(azurerm_lb_probe.this_probe_public, each.key)["id"]
  idle_timeout_in_minutes        = var.timeout_in_minutes
  depends_on                     = [azurerm_lb_probe.this_probe_public]
}
