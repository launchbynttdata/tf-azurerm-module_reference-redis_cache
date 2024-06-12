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

# COMMON

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
  }))

  default = {
    resource_group = {
      name       = "rg"
      max_length = 80
    }
    redis_cache = {
      name       = "redis"
      max_length = 80
    }
    private_endpoint = {
      name       = "pe"
      max_length = 80
    }
    private_service_connection = {
      name       = "pesc"
      max_length = 80
    }
  }
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 0 to 999."
  }
}

variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 0 to 100."
  }
}

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "redis"
}

variable "class_env" {
  type        = string
  description = "(Required) Environment where resource is going to be deployed. For example. dev, qa, uat"
  nullable    = false
  default     = "dev"

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group where the resources will be created"
  type        = string
  default     = null
}

variable "use_azure_region_abbr" {
  description = "Whether to use the Azure region abbreviation in the resource name. e.g. eastus -> eus"
  type        = bool
  default     = true
}

variable "location" {
  description = "target resource group resource mask"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Custom tags for the Redis cache"
  type        = map(string)
  default     = {}
}

// variables to configure redis cache

variable "capacity" {
  description = "The size of the Redis cache"
  type        = number
  default     = 1
}

variable "family" {
  description = "The SKU family/pricing group to use"
  type        = string
  default     = "C"
}

variable "sku_name" {
  description = "The type of SKU to use"
  type        = string
  default     = "Basic"
}

variable "enable_non_ssl_port" {
  description = "Enable the non-SSL port (6379)"
  type        = bool
  default     = false
}

variable "identity_ids" {
  description = <<EOT
    Specifies a list of user managed identity ids to be assigned.
  EOT
  type        = list(string)
  default     = null
}

variable "minimum_tls_version" {
  description = "The minimum TLS version. Defaults to 1.2"
  type        = string
  default     = "1.2"
}

variable "patch_schedule" {
  description = "Window of time when the Redis cache can be patched"
  type = list(object({
    day_of_week        = string
    start_hour_utc     = optional(string)
    maintenance_window = optional(string)
  }))
  default = null
}

variable "public_network_access_enabled" {
  description = "Allow public network access to the redis cache"
  type        = bool
  default     = true
}

variable "redis_configuration" {
  description = "Additional options for the Redis cache"
  type = object({
    aof_backup_enabled                      = optional(bool)
    aof_storage_connection_string_0         = optional(string)
    aof_storage_connection_string_1         = optional(string)
    enable_authentication                   = optional(bool)
    active_directory_authentication_enabled = optional(bool)
    maxmemory_reserved                      = optional(number)
    maxmemory_delta                         = optional(number)
    maxmemory_policy                        = optional(string)
    data_persistence_authentication_method  = optional(string)
    maxfragmentationmemory_reserved         = optional(number)
    rdb_backup_enabled                      = optional(bool)
    rdb_backup_frequency                    = optional(number)
    rdb_backup_max_snapshot_count           = optional(number)
    rdb_storage_connection_string           = optional(string)
    storage_account_subscription_id         = optional(string)
  })
  default = null
}

variable "redis_version" {
  description = "Major version of redis to use. Defaults to 6"
  type        = string
  default     = "6"
}

variable "subnet_id" {
  description = "ID of the subnet where the Redis cache should be deployed. Requires `sku_name` to be `Premium`"
  type        = string
  default     = null
}

variable "private_static_ip_address" {
  description = "The private IP address to use when `subnet_id` is set"
  type        = string
  default     = null
}

variable "replicas_per_master" {
  description = "Number of replicas to create per master"
  type        = number
  default     = null
}

variable "replicas_per_primary" {
  description = "Number of replicas to create per primary"
  type        = number
  default     = null
}

variable "shard_count" {
  description = "The number of shards to create on the cluster"
  type        = number
  default     = null
}

variable "zones" {
  description = "List of availability zones where the Redis cache should be located"
  type        = list(string)
  default     = null
}

// variables to configure private DNS zone

variable "private_dns_zone_suffix" {
  description = <<EOT
    The DNS Zone suffix for Azure Redis cache. Default is `privatelink.redis.cache.windows.net` for Public Cloud
    For US gov cloud it should be `privatelink.redis.cache.usgovcloudapi.net`
  EOT
  type        = string
  default     = "privatelink.redis.cache.windows.net"
}

variable "additional_vnet_links" {
  description = <<EOF
    A map of names to VNET IDs to create links with the private redis cache DNS Zone
    Applicable only when `public_network_access_enabled` is set to false
  EOF
  type        = map(string)
  default     = {}
}

// variables to configure private endpoint

variable "private_endpoint_subnet_id" {
  description = <<EOF
    ID of the subnet where the private endpoint should be deployed
    Required when `public_network_access_enabled` is set to false
  EOF
  type        = string
  default     = null
}
