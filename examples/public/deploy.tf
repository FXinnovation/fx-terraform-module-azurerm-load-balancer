resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "example" {
  name     = "tftest${random_string.this.result}"
  location = "West US"
}

module "public_lb" {
  source              = "../.."
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  loadbalancer_name   = "fxlb-public${random_string.this.result}"
  type                = "public"
  lb_sku              = "Basic"
  public_ip_names     = ["testip${random_string.this.result}", "fofo${random_string.this.result}"]
  public_ip_methods   = ["Dynamic"]
  public_ip_skus      = ["Basic"]
  lb_frontend_ip_configurations = [
    { name = "fxtest${random_string.this.result}", public_ip_address_id = "testip${random_string.this.result}", subnet_id = "", private_ip_address = "" },
    { name = "toto${random_string.this.result}", public_ip_address_id = "fofo${random_string.this.result}", subnet_id = "", private_ip_address = "" },
  ]

  lb_backend_pool_enabled                     = true
  lb_backend_pool_names                       = ["fxbackendtest"]
  lb_probe_names                              = ["toto"]
  lb_probe_protocols                          = ["HTTP"]
  lb_probe_ports                              = ["80"]
  lb_probe_request_paths                      = ["/"]
  lb_backend_pool_ids                         = ["fxbackendtest"]
  lb_rule_names                               = ["fxtftest"]
  lb_rule_protocols                           = ["TCP"]
  lb_rule_frontend_ports                      = ["80"]
  lb_rule_backend_ports                       = ["80"]
  lb_rule_frontend_ip_configuration_names     = ["toto${random_string.this.result}"]
  lb_nat_rule_enabled                         = true
  lb_nat_rule_names                           = ["boo"]
  lb_nat_rule_protocols                       = ["Tcp"]
  lb_nat_rule_frontend_ports                  = ["22"]
  lb_nat_rule_backend_ports                   = ["22"]
  lb_nat_rule_frontend_ip_configuration_names = ["toto${random_string.this.result}"]
}
