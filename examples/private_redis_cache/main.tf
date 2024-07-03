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

module "network_resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = {
    resource_group = {
      name       = "rg"
      max_length = 80
    }
    virtual_network = {
      name       = "vnet"
      max_length = 80
    }
  }

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.location
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  maximum_length          = each.value.max_length
}

module "network_resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.1"

  name     = module.network_resource_names["resource_group"].minimal_random_suffix
  location = var.location
  tags     = var.tags
}

module "virtual_network" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm"
  version = "~> 3.0"

  resource_group_name = module.network_resource_group.name

  vnet_name     = module.network_resource_names["virtual_network"].minimal_random_suffix
  vnet_location = var.location

  address_space = var.vnet_address_space
  subnets = {
    "private-endpoint-subnet" = {
      prefix = var.vnet_address_space[0]
    }
  }

  tags = var.tags

  depends_on = [module.network_resource_group]
}

module "redis_cache" {
  source = "../../"

  resource_names_map      = var.resource_names_map
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  location                = var.location
  class_env               = var.class_env
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource

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

  private_dns_zone_suffix = var.private_dns_zone_suffix
  additional_vnet_links   = var.additional_vnet_links

  private_endpoint_subnet_id = module.virtual_network.subnet_map["private-endpoint-subnet"].id

  tags = var.tags

  depends_on = [module.virtual_network]
}
