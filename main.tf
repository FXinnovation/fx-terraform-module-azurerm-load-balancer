locals {
  backend_pool_ids      = var.lb_backend_pool_enabled ? zipmap(var.lb_backend_pool_names, compact(concat(azurerm_lb_backend_address_pool.this.*.id, [""]))) : {}
  public_ip_address_ids = var.type == "public" ? zipmap(var.public_ip_names, compact(concat(azurerm_public_ip.this.*.id, [""]))) : {}
  probe_ids             = zipmap(var.lb_probe_names, compact(concat(azurerm_lb_probe.this.*.id, [""])))
}

###
# public IP
###

resource "azurerm_public_ip" "this" {
  count = var.type == "public" ? length(var.lb_frontend_ip_configurations) : 0

  name                = element(var.public_ip_names, count.index)
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = element(var.public_ip_methods, count.index)
  sku                 = element(var.public_ip_skus, count.index)
}

###
# load balancer
###

resource "azurerm_lb" "this" {
  count = var.enabled ? 1 : 0

  name                = var.loadbalancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.lb_sku

  dynamic "frontend_ip_configuration" {
    for_each = var.lb_frontend_ip_configurations
    content {
      name                          = frontend_ip_configuration.value.name
      public_ip_address_id          = var.type == "public" ? lookup(local.public_ip_address_ids, frontend_ip_configuration.value.public_ip_address_id, null) : ""
      subnet_id                     = var.type == "private" ? frontend_ip_configuration.value.subnet_id : ""
      private_ip_address            = var.type == "private" ? frontend_ip_configuration.value.private_ip_address : ""
      private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address == "" ? "Dynamic" : "Static"
    }
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
  count = var.enabled && var.lb_backend_pool_enabled ? length(var.lb_backend_pool_names) : 0

  name                = var.lb_backend_pool_names[count.index]
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.this[0].id
}

###
# NAT pool
###

resource "azurerm_lb_nat_pool" "this" {
  count = var.lb_nat_pool_enabled ? length(var.lb_nat_pool_names) : 0

  name                           = element(var.lb_nat_pool_names, count.index)
  protocol                       = element(var.lb_nat_pool_protocols, count.index)
  backend_port                   = element(var.lb_nat_pool_backend_ports, count.index)
  loadbalancer_id                = azurerm_lb.this[0].id
  resource_group_name            = var.resource_group_name
  frontend_port_start            = element(var.lb_nat_pool_frontend_port_starts, count.index)
  frontend_port_end              = element(var.lb_nat_pool_frontend_port_ends, count.index)
  frontend_ip_configuration_name = element(var.lb_nat_pool_frontend_ip_configuration_names, count.index)
}

###
# NAT rules
###

resource "azurerm_lb_nat_rule" "this" {
  count = var.enabled && var.lb_nat_rule_enabled ? length(var.lb_nat_rule_names) : 0

  name                           = element(var.lb_nat_rule_names, count.index)
  protocol                       = element(var.lb_nat_rule_protocols, count.index)
  loadbalancer_id                = azurerm_lb.this[0].id
  resource_group_name            = var.resource_group_name
  frontend_port                  = element(var.lb_nat_rule_frontend_ports, count.index)
  backend_port                   = element(var.lb_nat_rule_backend_ports, count.index)
  frontend_ip_configuration_name = element(var.lb_nat_rule_frontend_ip_configuration_names, count.index)
}

resource "azurerm_lb_probe" "this" {
  count = var.enabled ? length(var.lb_probe_names) : 0

  name                = element(var.lb_probe_names, count.index)
  port                = element(var.lb_probe_ports, count.index)
  protocol            = element(var.lb_probe_protocols, count.index)
  loadbalancer_id     = azurerm_lb.this[0].id
  resource_group_name = var.resource_group_name
  interval_in_seconds = element(var.lb_probe_interval_in_seconds, count.index)
  request_path        = element(var.lb_probe_request_paths, count.index)
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
  frontend_ip_configuration_name = element(var.lb_rule_frontend_ip_configuration_names, count.index)
  backend_address_pool_id        = lookup(local.backend_pool_ids, element(var.lb_backend_pool_ids, count.index), null)
  probe_id                       = lookup(local.probe_ids, element(var.lb_probe_ids, count.index), null)
  idle_timeout_in_minutes        = element(var.lb_rule_idle_timeout_in_minutes, count.index)
  load_distribution              = element(var.lb_rule_load_distributions, count.index)
  enable_floating_ip             = var.lb_rule_enable_floating_ip
  depends_on                     = [azurerm_lb_probe.this]
}
