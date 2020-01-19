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

  backend_pools = {
    backend1 = {
      backend_pool_name = "fxbackendtest"
    }
  }

  lb_rules = {
    lb_rule1 = {
      backend_pool_key = "backend1"
      probe_name       = "testprobe"
      rule_name        = "testrule"
      frontend_port    = "80"
      backend_port     = "80"
      lb_rule_protocol = "Tcp"
      port_probe       = "80"
      protocol_probe   = "Http"
      request_path     = "/"
    }
  }

  nat_rules = {
    nat_rule1 = {
      nat_rule_name = "testlb"
      nat_protocol  = "Tcp"
      backend_port  = "22"
      frontend_port = "22"
    }
  }
}
