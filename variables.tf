variable "enabled" {
  description = "Enable or disable module"
  default     = true
}

variable "resource_group_name" {
  description = "Resource group where the vnet resides."
  type        = string
}

variable "location" {
  description = "location of the load_balancer"
  type        = string
}

variable "type" {
  description = "Define if the loadbalancer is private or public."
  type        = string
  default     = "public"
}

variable "tags" {
  description = "Tags to add to the Load Balancer"
  default     = {}
}

###
# public ip
###

variable "public_ip_names" {
  description = "Name of the Public IP resource"
  type        = list(string)
  default     = [""]
}

variable "public_ip_methods" {
  description = "the allocation method for this ip address possible values are `Static` or `Dynamic`. "
  type        = list(string)
  default     = [""]
  #default     = "Static"
}

variable "public_ip_skus" {
  description = "The sku of the public ip, accepted values are `Basic` and `Standard` defaults to `Basic`"
  type        = list(string)
  default     = [""]
  #default     = "Basic"
}

###
# load balancer
###

variable "loadbalancer_name" {
  description = "load balancer resources names."
}

variable "sku" {
  description = "The SKU of the Load Balancer."
  default     = "Basic"
}

variable "frontend_ip_configurations" {
  description = "Name of the frontend ip configuration"
  type        = list(object({ name = string, subnet_id = string, private_ip_address = string, public_ip_address_id = string }))
}

variable "load_balancer_tags" {
  description = "Tags to add to the Load Balancer"
  default     = {}
}

###
# Backend Address pool
###

variable "backend_pool_names" {
  description = "Name of the backend pool which will be created"
  type        = list(string)
  default     = [""]
}

###
# NAT pool
###

variable "nat_pool_enabled" {
  description = "Boolean flag to enable nat pool"
  default     = false
}

variable "nat_pool_names" {
  description = "List of nat pool names for nat pool."
  type        = list(string)
  default     = [""]
}

variable "nat_pool_protocols" {
  description = "List of nat pool protocols."
  type        = list(string)
  default     = [""]
}

variable "nat_pool_backend_ports" {
  description = "List of back end ports for the NAT pool."
  type        = list(string)
  default     = [""]
}

variable "port_starts" {
  description = "List of frontend port start for NAT pool."
  type        = list(string)
  default     = [""]
}

variable "port_ends" {
  description = "List of the frontend port end for NAT pool."
  type        = list(string)
  default     = [""]
}

variable "nat_pool_frontend_ip_configuration_names" {
  description = "List of frotend ip configuration name to which the nat pool will be associated. Changing this will force to create new resource."
  type        = list(string)
  default     = [""]
}


###
# NAT rule
###

variable "nat_rule_names" {
  description = "List of name for the nat rule."
  type        = list(string)
  default     = [""]
}

variable "nat_protocols" {
  description = "List of nat protocol which are associated to the rule."
  type        = list(string)
  default     = [""]
}

variable "nat_frontend_ports" {
  description = "List of front end port which will be associated to the rule."
  type        = list(string)
  default     = [""]
}

variable "nat_backend_ports" {
  description = "List of back end port which will be associated to the rule."
  type        = list(string)
  default     = [""]
}

variable "nat_rule_frontend_ip_configuration_names" {
  description = "List of frontend ip configuration name to which nat rule will be associated. Changing tis will force to create new resource."
  type        = list(string)
  default     = [""]
}


###
# load balancer rules
###

variable "lb_rule_names" {
  description = "list of loadbalncer rule name that will be created. changing this will force to create new resource."
  default     = [""]
  type        = list(string)
}

variable "lb_rule_protocols" {
  description = "List of transport protocol for the external endpoint possible values are Udp, Tcp or All.changing this will force to create new resource.  "
  type        = list(string)
  default     = [""]
}

variable "lb_rule_frontend_ports" {
  description = "List of port for the external endpoint. Port numbers for each Rule must be unique within the load balancer. Possible values range between 1 and 65534, inclusive"
  type        = list(string)
  default     = [""]
}

variable "lb_rule_backend_ports" {
  description = "List of port used for internal connections on the endpoint. Possible values range between 1 and 65535, inclusive."
  type        = list(string)
  default     = [""]
}

variable "backend_pool_ids" {
  description = "List of backend pool ids to which the load balancer rule operates. Changing this will force to create new resource."
  type        = list(string)
  default     = [""]
}

variable "probe_ids" {
  description = "List of probe ids to which the load balancer rule is attached. Changing this will force to create new resource."
  type        = list(string)
  default     = [""]
}


variable "lb_rule_frontend_ip_configuration_names" {
  description = "List of frontend ip configuration name to whcih the load balancer rule will be associated. Changing this will force to create new rule."
  type        = list(string)
  default     = [""]
}

variable "interval" {
  description = "The interval, in seconds between probes to the backend endpoint for health status."
  default     = 5
}

variable "timeout_in_minutes" {
  description = "Specifies the timeout for the Tcp idle connection."
  default     = 5
}

variable "enable_floating_ip" {
  description = "Enables the Floating IP Capacity, required to configure a SQL AlwaysOn Availability Group."
  default     = false
}

###
# load balancer probe
###

variable "probe_names" {
  description = "list of loadbalncer probe name that will be created. changing this will force to create new resource."
  type        = list(string)
  default     = [""]
}

variable "probe_ports" {
  description = "List of ports on which the probe will queries the backend endpoint. possible values range from 1 to 65535, inclusive. "
  type        = list(string)
  default     = [""]
}

variable "probe_protocols" {
  description = "List of protocol of the end point. possible values are `Http`, `Https` or `Tcp`."
  type        = list(string)
  default     = [""]
}

variable "request_paths" {
  description = "List of URI used for requesting health status from the backend endpoint required if protocol is set to Http. Otherwise, it is not allowed. "
  type        = list(string)
  default     = [""]
}
