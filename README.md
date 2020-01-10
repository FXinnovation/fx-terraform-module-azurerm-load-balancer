# terraform-module-azurerm-load-balancer

## Usage
See `examples` folders for usage of this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| backend\_pools | Name of the backend pool which will be created | any | n/a | yes |
| frontend\_ip\_configuration\_name | Name of the frontend ip configuration | string | n/a | yes |
| lbrules | Protocols to be used for lb health probes and rules. | any | n/a | yes |
| loadbalancer\_name | load balancer resources names. | string | n/a | yes |
| location | location of the load\_balancer | string | n/a | yes |
| nat\_rules | Protocols to be used for remote vm access. | any | n/a | yes |
| resource\_group\_name | Resource group where the vnet resides. | string | n/a | yes |
| type | Define if the loadbalancer is private or public. | string | n/a | yes |
| enable\_floating\_ip | Enables the Floating IP Capacity, required to configure a SQL AlwaysOn Availability Group. | bool | `"false"` | no |
| enabled | Enable or disable module | string | `"true"` | no |
| interval | The interval, in seconds between probes to the backend endpoint for health status. | string | `"5"` | no |
| method | Defines the allocation method for this IP address. | string | `""` | no |
| nat\_pool\_enabled | Boolean flag to enable nat pool | bool | `"false"` | no |
| private\_ip\_address | Private ip address | string | `""` | no |
| public\_ip\_name | Name of the Public IP resource | string | `""` | no |
| sku | The SKU of the Load Balancer. | string | `"Basic"` | no |
| subnet\_id | ID os the subnet | string | `""` | no |
| subnet\_ids | Frontend subnet id to use when in private mode | string | `""` | no |
| tags | Tags to add to the Load Balancer | map | `{}` | no |
| timeout\_in\_minutes | Specifies the timeout for the Tcp idle connection. | string | `"5"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id\_backend\_pool |  |
| id\_nat\_rule |  |
| id\_private |  |
| id\_probe |  |
| lb\_private\_ip |  |
| public\_ip\_id | The id for the public\_ip resource |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->