# private_redis_cache

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.67.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network_resource_names"></a> [network\_resource\_names](#module\_network\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 1.0 |
| <a name="module_network_resource_group"></a> [network\_resource\_group](#module\_network\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.1 |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm | ~> 3.0 |
| <a name="module_redis_cache"></a> [redis\_cache](#module\_redis\_cache) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br>    name       = string<br>    max_length = optional(number, 60)<br>  }))</pre> | <pre>{<br>  "private_endpoint": {<br>    "max_length": 80,<br>    "name": "pe"<br>  },<br>  "private_service_connection": {<br>    "max_length": 80,<br>    "name": "pesc"<br>  },<br>  "redis_cache": {<br>    "max_length": 80,<br>    "name": "redis"<br>  },<br>  "resource_group": {<br>    "max_length": 80,<br>    "name": "rg"<br>  },<br>  "virtual_network": {<br>    "max_length": 80,<br>    "name": "vnet"<br>  }<br>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"redis"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | target resource group resource mask | `string` | `"eastus"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom tags for the deployment | `map(string)` | `{}` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space to deploy a virtual network with | `list(string)` | <pre>[<br>  "10.1.0.0/24"<br>]</pre> | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | The size of the Redis cache | `number` | `1` | no |
| <a name="input_family"></a> [family](#input\_family) | The SKU family/pricing group to use | `string` | `"C"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The type of SKU to use | `string` | `"Basic"` | no |
| <a name="input_enable_non_ssl_port"></a> [enable\_non\_ssl\_port](#input\_enable\_non\_ssl\_port) | Enable the non-SSL port (6379) | `bool` | `false` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of user managed identity ids to be assigned. | `list(string)` | `null` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | The minimum TLS version. Defaults to 1.2 | `string` | `"1.2"` | no |
| <a name="input_patch_schedule"></a> [patch\_schedule](#input\_patch\_schedule) | Window of time when the Redis cache can be patched | <pre>list(object({<br>    day_of_week        = string<br>    start_hour_utc     = optional(string)<br>    maintenance_window = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Allow public network access to the redis cache | `bool` | `false` | no |
| <a name="input_redis_configuration"></a> [redis\_configuration](#input\_redis\_configuration) | Additional options for the Redis cache | <pre>object({<br>    aof_backup_enabled                      = optional(bool)<br>    aof_storage_connection_string_0         = optional(string)<br>    aof_storage_connection_string_1         = optional(string)<br>    enable_authentication                   = optional(bool)<br>    active_directory_authentication_enabled = optional(bool)<br>    maxmemory_reserved                      = optional(number)<br>    maxmemory_delta                         = optional(number)<br>    maxmemory_policy                        = optional(string)<br>    data_persistence_authentication_method  = optional(string)<br>    maxfragmentationmemory_reserved         = optional(number)<br>    rdb_backup_enabled                      = optional(bool)<br>    rdb_backup_frequency                    = optional(number)<br>    rdb_backup_max_snapshot_count           = optional(number)<br>    rdb_storage_connection_string           = optional(string)<br>    storage_account_subscription_id         = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | Major version of redis to use. Defaults to 6 | `string` | `"6"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet where the Redis cache should be deployed. Requires `sku_name` to be `Premium` | `string` | `null` | no |
| <a name="input_private_static_ip_address"></a> [private\_static\_ip\_address](#input\_private\_static\_ip\_address) | The private IP address to use when `subnet_id` is set | `string` | `null` | no |
| <a name="input_replicas_per_master"></a> [replicas\_per\_master](#input\_replicas\_per\_master) | Number of replicas to create per master | `number` | `null` | no |
| <a name="input_replicas_per_primary"></a> [replicas\_per\_primary](#input\_replicas\_per\_primary) | Number of replicas to create per primary | `number` | `null` | no |
| <a name="input_shard_count"></a> [shard\_count](#input\_shard\_count) | The number of shards to create on the cluster | `number` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | List of availability zones where the Redis cache should be located | `list(string)` | `null` | no |
| <a name="input_private_dns_zone_suffix"></a> [private\_dns\_zone\_suffix](#input\_private\_dns\_zone\_suffix) | The DNS Zone suffix for Azure Redis cache. Default is `privatelink.redis.cache.windows.net` for Public Cloud<br>    For US gov cloud it should be `privatelink.redis.cache.usgovcloudapi.net` | `string` | `"privatelink.redis.cache.windows.net"` | no |
| <a name="input_additional_vnet_links"></a> [additional\_vnet\_links](#input\_additional\_vnet\_links) | A map of names to VNET IDs to create links with the private redis cache DNS Zone<br>    Applicable only when `public_network_access_enabled` is set to false | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_redis_cache_id"></a> [redis\_cache\_id](#output\_redis\_cache\_id) | n/a |
| <a name="output_redis_cache_hostname"></a> [redis\_cache\_hostname](#output\_redis\_cache\_hostname) | n/a |
| <a name="output_redis_cache_primary_access_key"></a> [redis\_cache\_primary\_access\_key](#output\_redis\_cache\_primary\_access\_key) | n/a |
| <a name="output_redis_cache_secondary_access_key"></a> [redis\_cache\_secondary\_access\_key](#output\_redis\_cache\_secondary\_access\_key) | n/a |
| <a name="output_redis_cache_primary_connection_string"></a> [redis\_cache\_primary\_connection\_string](#output\_redis\_cache\_primary\_connection\_string) | n/a |
| <a name="output_redis_cache_secondary_connection_string"></a> [redis\_cache\_secondary\_connection\_string](#output\_redis\_cache\_secondary\_connection\_string) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
