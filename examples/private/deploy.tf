module "resource_group_demo" {
  source   = "git::https://scm.dazzlingwrench.fxinnovation.com/fxinnovation-public/terraform-module-azurerm-resource-group.git?ref=0.2.0"
  location = "francecentral"
  name     = "tftest-sa"
}

module "vnet_demo" {
  source              = "git::https://scm.dazzlingwrench.fxinnovation.com/fxinnovation-public/terraform-module-azurerm-virtualnetwork.git?ref=v0.2"
  resource_group_name = module.resource_group_demo.name
  vnet_name           = "fxcozca1dgenvn001"
  vnet_address_space  = ["10.0.0.0/16"]
  vnet_dns_servers    = ["8.8.8.8", "8.8.4.4"]
}

module "subnets" {
  source               = "git::https://scm.dazzlingwrench.fxinnovation.com/fxinnovation-public/terraform-module-azurerm-virtualnetwork-subnet.git?ref=0.2.1"
  resource_group_name  = module.resource_group_demo.name
  virtual_network_name = module.vnet_demo.virtual_network_name
  subnets_config = {
    GatewaySubnet = {
      name           = "GatewaySubnet"
      address_prefix = "10.0.0.0/24"
    }

    Subnet1 = {
      name              = "Subnet1"
      address_prefix    = "10.0.1.0/24"
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
    }
  }
}

module "private_lb" {
  source                         = "../.."
  resource_group_name            = module.resource_group_demo.name
  location                       = "francecentral"
  sku                            = "standard"
  loadbalancer_name              = "fxlb-private"
  private_ip_address             = "10.0.1.6"
  type                           = "private"
  subnet_id                      = lookup(module.subnets.subnets_ids_map, "Subnet1")
  frontend_ip_configuration_name = "testlb"

  backend_pool_names     = ["fxbackendtest"]
  probe_names            = ["boo"]
  probe_protocols        = ["HTTPS"]
  probe_ports            = ["80"]
  lb_rule_names          = ["fxtftest"]
  lb_rule_protocols      = ["TCP"]
  lb_rule_frontend_ports = ["80"]
  lb_rule_backend_ports  = ["80"]
  nat_rule_names         = ["foo"]
  nat_protocols          = ["Tcp"]
  nat_front_end_ports    = ["22"]
  nat_backend_ports      = ["22"]
}
