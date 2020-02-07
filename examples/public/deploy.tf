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
  sku                 = "Basic"
  public_ip_names     = ["testip${random_string.this.result}", "fofo${random_string.this.result}"]
  public_ip_methods   = ["Dynamic"]
  public_ip_skus      = ["Basic"]
  frontend_ip_configurations = [
    { name = "fxtest${random_string.this.result}", public_ip_address_id = "testip${random_string.this.result}", subnet_id = "", private_ip_address = "" },
    { name = "toto${random_string.this.result}", public_ip_address_id = "fofo${random_string.this.result}", subnet_id = "", private_ip_address = "" },
  ]

  backend_pool_names     = ["fxbackendtest"]
  probe_names            = ["toto"]
  probe_protocols        = ["HTTP"]
  probe_ports            = ["80"]
  request_paths          = ["/"]
  backend_pool_ids       = ["fxbackendtest"]
  lb_rule_names          = ["fxtftest"]
  lb_rule_protocols      = ["TCP"]
  lb_rule_frontend_ports = ["80"]
  lb_rule_backend_ports  = ["80"]
  nat_rule_names         = ["boo"]
  nat_protocols          = ["Tcp"]
  nat_frontend_ports     = ["22"]
  nat_backend_ports      = ["22"]

}
