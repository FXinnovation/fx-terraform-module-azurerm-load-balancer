module "rg_demo" {
  source   = "git::ssh://git@scm.dazzlingwrench.fxinnovation.com:2222/fxinnovation-public/terraform-module-azurerm-resource-group.git?ref=0.2.0"
  location = "francecentral"
  name     = "tftest-sa"
}

module "public_lb" {
  source                         = "../.."
  resource_group_name            = module.rg_demo.name
  location                       = "francecentral"
  loadbalancer_name              = "fxlb-public"
  method                         = "Dynamic"
  type                           = "public"
  public_ip_name                 = "testpublicip"
  sku                            = "Basic"
  frontend_ip_configuration_name = "teslb"

  backend_pools = {
    backend1 = {
      backend_pool_name = "fxpubbackend"
    }
  }

  lbrules = {
    lbrules1 = {
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
