# terraform-module-azurerm-load-balancer

## Usage
See `examples` folders for usage of this module.

## Limitation
- Only one freont configuration is possible for now.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| backend\_pool\_ids | List of backend pool ids to which the load balancer rule operates. Changing this will force to create new resource. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| backend\_pool\_names | Name of the backend pool which will be created | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| enable\_floating\_ip | Enables the Floating IP Capacity, required to configure a SQL AlwaysOn Availability Group. | `bool` | `false` | no |
| enabled | Enable or disable module | `bool` | `true` | no |
| frontend\_ip\_configuration\_name | Name of the frontend ip configuration. | `string` | n/a | yes |
| frontend\_private\_ip\_address | Private ip address | `string` | `""` | no |
| frontend\_private\_ip\_address\_allocation | The allocation method for the irivate ip address used by this load balancer. Possible values as `Dynamic` and `Static`. | `string` | `"Dynamic"` | no |
| frontend\_subnet\_id | Frontend subnet id to use when in private mode | `string` | `""` | no |
| interval | The interval, in seconds between probes to the backend endpoint for health status. | `number` | `5` | no |
| lb\_rule\_backend\_ports | List of port used for internal connections on the endpoint. Possible values range between 1 and 65535, inclusive. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| lb\_rule\_frontend\_ports | List of port for the external endpoint. Port numbers for each Rule must be unique within the load balancer. Possible values range between 1 and 65534, inclusive | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| lb\_rule\_names | list of loadbalncer rule name that will be created. changing this will force to create new resource. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| lb\_rule\_protocols | List of transport protocol for the external endpoint possible values are Udp, Tcp or All.changing this will force to create new resource. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| load\_balancer\_tags | Tags to add to the Load Balancer | `map` | `{}` | no |
| loadbalancer\_name | load balancer resources names. | `any` | n/a | yes |
| location | location of the load\_balancer | `string` | n/a | yes |
| nat\_backend\_ports | List of back end port which will be associated to the rule. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| nat\_frontend\_ports | List of front end port which will be associated to the rule. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| nat\_pool\_backend\_ports | List of back end ports for the NAT pool. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| nat\_pool\_enabled | Boolean flag to enable nat pool | `bool` | `false` | no |
| nat\_pool\_names | List of nat pool names for nat pool. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| nat\_pool\_protocols | List of nat pool protocols. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| nat\_protocols | List of nat protocol which are associated to the rule. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| nat\_rule\_names | List of name for the nat rule. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| port\_ends | List of the frontend port end for NAT pool. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| port\_starts | List of frontend port start for NAT pool. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| probe\_names | list of loadbalncer probe name that will be created. changing this will force to create new resource. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| probe\_ports | List of ports on which the probe will queries the backend endpoint. possible values range from 1 to 65535, inclusive. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| probe\_protocols | List of protocol of the end point. possible values are `Http`, `Https` or `Tcp`. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| public\_ip\_method | the allocation method for this ip address possible values are `Static` or `Dynamic`. | `string` | `"Static"` | no |
| public\_ip\_name | Name of the Public IP resource | `string` | `""` | no |
| public\_ip\_sku | The sku of the public ip, accepted values are `Basic` and `Standard` defaults to `Basic` | `string` | `"Basic"` | no |
| request\_paths | List of URI used for requesting health status from the backend endpoint required if protocol is set to Http. Otherwise, it is not allowed. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| resource\_group\_name | Resource group where the vnet resides. | `string` | n/a | yes |
| sku | The SKU of the Load Balancer. | `string` | `"Basic"` | no |
| tags | Tags to add to the Load Balancer | `map` | `{}` | no |
| timeout\_in\_minutes | Specifies the timeout for the Tcp idle connection. | `number` | `5` | no |
| type | Define if the loadbalancer is private or public. | `string` | `"public"` | no |

## Outputs

| Name | Description |
|------|-------------|
| backend\_pool\_ids | The ids of the backend address pools. |
| lb\_ids | The ids of the load balancer |
| lb\_private\_ip | The first private IP address assigned to the load balancer in frontend\_ip\_configuration. |
| lb\_probe\_ids | the ids of the load balncer probes. |
| nat\_pool\_ids | The ids of the load balncer nat pools. |
| nat\_rule\_ids | The ids of the load balncer nat rules. |
| public\_ip\_id | The id for the public\_ip resource |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
