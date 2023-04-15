## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_networking"></a> [networking](#module\_networking) | ./modules/terraform-aws-vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application Name | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region to deploy the infrastructure | `string` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR of the VPC | `string` | n/a | yes |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center sponsors for the infrastructure expenses | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The infrastructure environment (dev, qa, staging, prod) | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The common name of the VPC | `string` | n/a | yes |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Common tag for private subnets | `map(any)` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | An List of Objects containing configuration about subnet | `list(any)` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `string` | n/a | yes |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Common tag for public subnets | `map(any)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | An List of Objects containing configuration about subnet | `list(any)` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Enable a single NAT Gateway for private subnets | `bool` | n/a | yes |

## Outputs

No outputs.
