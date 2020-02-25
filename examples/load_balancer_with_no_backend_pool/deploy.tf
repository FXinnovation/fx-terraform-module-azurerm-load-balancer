resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "example" {
  name     = "tftest${random_string.this.result}"
  location = "West US"
}

resource "azurerm_virtual_network" "example" {
  name                = "tftest${random_string.this.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "tftest${random_string.this.result}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "test" {
  name                 = "fxterra${random_string.this.result}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefix       = "10.0.2.0/24"
}

module "example" {
  source = "../.."

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  lb_sku              = "standard"
  loadbalancer_name   = "fxlb${random_string.this.result}"
  type                = "private"
  lb_frontend_ip_configurations = [
    { name = "fxtest${random_string.this.result}", subnet_id = "${azurerm_subnet.example.id}", private_ip_address = "10.0.1.25", public_ip_address_id = "" },
    { name = "fxterra${random_string.this.result}", subnet_id = "${azurerm_subnet.test.id}", private_ip_address = "10.0.2.8", public_ip_address_id = "" },
  ]

  lb_backend_pool_enabled                     = false
  lb_probe_names                              = ["boo"]
  lb_probe_protocols                          = ["HTTPS"]
  lb_probe_ports                              = ["80"]
  lb_probe_request_paths                      = ["/"]
  lb_rule_names                               = ["fxtftest"]
  lb_rule_protocols                           = ["TCP"]
  lb_rule_frontend_ports                      = ["80"]
  lb_rule_backend_ports                       = ["80"]
  lb_probe_ids                                = ["boo"]
  lb_rule_frontend_ip_configuration_names     = ["fxterra${random_string.this.result}"]
  lb_nat_rule_enabled                         = true
  lb_nat_rule_names                           = ["foo"]
  lb_nat_rule_protocols                       = ["Tcp"]
  lb_nat_rule_frontend_ports                  = ["22"]
  lb_nat_rule_backend_ports                   = ["22"]
  lb_nat_rule_frontend_ip_configuration_names = ["fxterra${random_string.this.result}"]
}
