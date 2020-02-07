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

module "private_lb" {
  source = "../.."

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard"
  loadbalancer_name   = "fxlb-private${random_string.this.result}"
  type                = "private"
  frontend_ip_configurations = [
    { name = "fxtest${random_string.this.result}", subnet_id = "${azurerm_subnet.example.id}", private_ip_address = "10.0.1.25", public_ip_address_id = "" },
    { name = "fxterra${random_string.this.result}", subnet_id = "${azurerm_subnet.test.id}", private_ip_address = "10.0.2.8", public_ip_address_id = "" },
  ]

  backend_pool_names     = ["fxbackendtest"]
  probe_names            = ["boo"]
  probe_protocols        = ["HTTPS"]
  probe_ports            = ["80"]
  request_paths          = ["/"]
  lb_rule_names          = ["fxtftest"]
  backend_pool_ids       = ["fxbackendtest"]
  lb_rule_protocols      = ["TCP"]
  lb_rule_frontend_ports = ["80"]
  lb_rule_backend_ports  = ["80"]
  nat_rule_names         = ["foo"]
  nat_protocols          = ["Tcp"]
  nat_frontend_ports     = ["22"]
  nat_backend_ports      = ["22"]
}
