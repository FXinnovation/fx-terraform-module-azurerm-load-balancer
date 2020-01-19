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
}

variable "public_ip_name" {
  description = "Name of the Public IP resource"
  default     = ""
}

variable "method" {
  description = "Defines the allocation method for this IP address."
  default     = ""
}

variable "loadbalancer_name" {
  description = "load balancer resources names."
}

variable "sku" {
  description = "The SKU of the Load Balancer."
  default     = "Basic"
}

variable "subnet_ids" {
  description = "Frontend subnet id to use when in private mode"
  default     = ""
}

variable "nat_rules" {
  description = "Protocols to be used for remote vm access."
  type        = map
}

variable "enable_floating_ip" {
  description = "Enables the Floating IP Capacity, required to configure a SQL AlwaysOn Availability Group."
  type        = bool
  default     = false
}

variable "lb_rules" {
  description = "Protocols to be used for lb health probes and rules."
  type        = map
}

variable "interval" {
  description = "The interval, in seconds between probes to the backend endpoint for health status."
  default     = 5
}

variable "timeout_in_minutes" {
  description = "Specifies the timeout for the Tcp idle connection."
  default     = 5
}

variable "frontend_ip_configuration_name" {
  description = "Name of the frontend ip configuration"
  type        = string
}

variable "private_ip_address" {
  description = "Private ip address"
  default     = ""
}

variable "subnet_id" {
  description = "ID os the subnet"
  default     = ""
}

variable "nat_pool_enabled" {
  description = "Boolean flag to enable nat pool"
  default     = false
}

variable "backend_pools" {
  description = "Name of the backend pool which will be created"
  type        = map
}

variable "tags" {
  description = "Tags to add to the Load Balancer"
  default     = {}
}
