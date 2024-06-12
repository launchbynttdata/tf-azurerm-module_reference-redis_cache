# tf-azurerm-module_reference-redis_cache

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terraform module provisions an Azure Redis Cache with all its dependencies.

This reference module is built as a wrapper around the primitive module tf-azurerm-module_primitive-redis_cache

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
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
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name.git | 1.0.1 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-resource_group.git | 1.0.0 |
| <a name="module_redis_cache"></a> [redis\_cache](#module\_redis\_cache) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-redis_cache.git | 1.0.0 |
| <a name="module_private_dns_zone"></a> [private\_dns\_zone](#module\_private\_dns\_zone) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-private_dns_zone.git | 1.0.0 |
| <a name="module_vnet_link"></a> [vnet\_link](#module\_vnet\_link) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-private_dns_vnet_link.git | 1.0.0 |
| <a name="module_additional_vnet_links"></a> [additional\_vnet\_links](#module\_additional\_vnet\_links) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-private_dns_vnet_link.git | 1.0.0 |
| <a name="module_private_endpoint"></a> [private\_endpoint](#module\_private\_endpoint) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-private_endpoint.git | 1.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br>    name       = string<br>    max_length = optional(number, 60)<br>  }))</pre> | <pre>{<br>  "private_endpoint": {<br>    "max_length": 80,<br>    "name": "pe"<br>  },<br>  "private_service_connection": {<br>    "max_length": 80,<br>    "name": "pesc"<br>  },<br>  "redis_cache": {<br>    "max_length": 80,<br>    "name": "redis"<br>  },<br>  "resource_group": {<br>    "max_length": 80,<br>    "name": "rg"<br>  }<br>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"redis"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group where the resources will be created | `string` | `null` | no |
| <a name="input_use_azure_region_abbr"></a> [use\_azure\_region\_abbr](#input\_use\_azure\_region\_abbr) | Whether to use the Azure region abbreviation in the resource name. e.g. eastus -> eus | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | target resource group resource mask | `string` | `"eastus"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom tags for the Redis cache | `map(string)` | `{}` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | The size of the Redis cache | `number` | `1` | no |
| <a name="input_family"></a> [family](#input\_family) | The SKU family/pricing group to use | `string` | `"C"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The type of SKU to use | `string` | `"Basic"` | no |
| <a name="input_enable_non_ssl_port"></a> [enable\_non\_ssl\_port](#input\_enable\_non\_ssl\_port) | Enable the non-SSL port (6379) | `bool` | `false` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of user managed identity ids to be assigned. | `list(string)` | `null` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | The minimum TLS version. Defaults to 1.2 | `string` | `"1.2"` | no |
| <a name="input_patch_schedule"></a> [patch\_schedule](#input\_patch\_schedule) | Window of time when the Redis cache can be patched | <pre>list(object({<br>    day_of_week        = string<br>    start_hour_utc     = optional(string)<br>    maintenance_window = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Allow public network access to the redis cache | `bool` | `true` | no |
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
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | ID of the subnet where the private endpoint should be deployed<br>    Required when `public_network_access_enabled` is set to false | `string` | `null` | no |

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
