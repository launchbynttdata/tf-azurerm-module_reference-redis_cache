resource_names_map = {
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
instance_env            = 2
instance_resource       = 1
logical_product_family  = "launch"
logical_product_service = "redis"
class_env               = "gotest"
location                = "eastus"
