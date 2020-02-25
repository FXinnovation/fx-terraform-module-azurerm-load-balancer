# Public Load Balancer example
## Usage
```
terraform init
terraform plan
terraform apply
terraform destroy
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | ~>1.40.0 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| client\_id | n/a | `string` | n/a | yes |
| client\_secret | n/a | `string` | n/a | yes |
| subscription\_id | n/a | `string` | n/a | yes |
| tenant\_id | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lb\_backend\_pool\_id | n/a |
| lb\_backend\_pool\_ids\_map | n/a |
| lb\_nat\_rule\_ids | n/a |
| lb\_rule\_ids | n/a |
| load\_balancer\_id | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
