// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.location
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  use_azure_region_abbr   = var.use_azure_region_abbr
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  count = var.resource_group_name != null ? 0 : 1

  name     = module.resource_names["resource_group"].standard
  location = var.location

  tags = merge(var.tags, { resource_name = module.resource_names["resource_group"].standard })
}

module "redis_cache" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/redis_cache/azurerm"
  version = "~> 1.0"

  name                          = module.resource_names["redis_cache"].standard
  resource_group_name           = var.resource_group_name != null ? var.resource_group_name : module.resource_group[0].name
  location                      = var.location
  capacity                      = var.capacity
  family                        = var.family
  sku_name                      = var.sku_name
  enable_non_ssl_port           = var.enable_non_ssl_port
  identity_ids                  = var.identity_ids
  minimum_tls_version           = var.minimum_tls_version
  patch_schedule                = var.patch_schedule
  private_static_ip_address     = var.private_static_ip_address
  public_network_access_enabled = var.public_network_access_enabled
  redis_configuration           = var.redis_configuration
  redis_version                 = var.redis_version
  replicas_per_master           = var.replicas_per_master
  replicas_per_primary          = var.replicas_per_primary
  shard_count                   = var.shard_count
  subnet_id                     = var.subnet_id
  zones                         = var.zones

  tags = merge(var.tags, { resource_name = module.resource_names["redis_cache"].standard })

  depends_on = [module.resource_group]
}

module "private_dns_zone" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/private_dns_zone/azurerm"
  version = "~> 1.0"

  count = var.public_network_access_enabled ? 0 : 1

  zone_name           = var.private_dns_zone_suffix
  resource_group_name = var.resource_group_name != null ? var.resource_group_name : module.resource_group[0].name

  tags = var.tags

  depends_on = [module.resource_group]
}

module "vnet_link" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/private_dns_vnet_link/azurerm"
  version = "~> 1.0"

  count = var.public_network_access_enabled ? 0 : 1

  link_name             = "redis-private-endpoint-vnet-link"
  resource_group_name   = var.resource_group_name != null ? var.resource_group_name : module.resource_group[0].name
  private_dns_zone_name = module.private_dns_zone[0].zone_name
  virtual_network_id    = join("/", slice(split("/", var.private_endpoint_subnet_id), 0, 9))
  registration_enabled  = false

  tags = var.tags

  depends_on = [module.private_dns_zone, module.resource_group]
}

module "additional_vnet_links" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/private_dns_vnet_link/azurerm"
  version = "~> 1.0"

  for_each = var.public_network_access_enabled ? {} : var.additional_vnet_links

  link_name             = each.key
  resource_group_name   = var.resource_group_name != null ? var.resource_group_name : module.resource_group[0].name
  private_dns_zone_name = module.private_dns_zone[0].zone_name
  virtual_network_id    = each.value
  registration_enabled  = false

  tags = var.tags

  depends_on = [module.private_dns_zone, module.resource_group]
}

module "private_endpoint" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/private_endpoint/azurerm"
  version = "~> 1.0"

  count = var.public_network_access_enabled ? 0 : 1

  region                          = var.location
  endpoint_name                   = module.resource_names["private_endpoint"].standard
  is_manual_connection            = false
  resource_group_name             = var.resource_group_name != null ? var.resource_group_name : module.resource_group[0].name
  private_service_connection_name = module.resource_names["private_service_connection"].standard
  private_connection_resource_id  = module.redis_cache.redis_cache_id
  subresource_names               = ["redisCache"]
  subnet_id                       = var.private_endpoint_subnet_id
  private_dns_zone_ids            = [module.private_dns_zone[0].id]
  private_dns_zone_group_name     = "redisCache"

  tags = merge(var.tags, { resource_name = module.resource_names["private_endpoint"].standard })

  depends_on = [module.resource_group, module.redis_cache, module.private_dns_zone]
}
