module "resource_group_demo" {
  source   = "git::https://scm.dazzlingwrench.fxinnovation.com/fxinnovation-public/terraform-module-azurerm-resource-group.git?ref=0.2.0"
  location = "francecentral"
  name     = "tftest-sa"
}

module "public_lb" {
  source                         = "../.."
  resource_group_name            = module.resource_group_demo.name
  location                       = "francecentral"
  loadbalancer_name              = "fxlb-public"
  method                         = "Dynamic"
  type                           = "public"
  public_ip_name                 = "testpublicip"
  sku                            = "Basic"
  frontend_ip_configuration_name = "teslb"

  backend_pool_names     = ["fxbackendtest"]
  probe_names            = ["toto"]
  probe_protocols        = ["HTTPS"]
  probe_ports            = ["80"]
  request_paths          = ["/"]
  lb_rule_names          = ["fxtftest"]
  lb_rule_protocols      = ["TCP"]
  lb_rule_frontend_ports = ["80"]
  lb_rule_backend_ports  = ["80"]
  nat_rule_names         = ["boo"]
  nat_protocols          = ["Tcp"]
  nat_frontend_ports     = ["22"]
  nat_backend_ports      = ["22"]

}
