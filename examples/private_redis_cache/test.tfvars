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
  network_security_group = {
    name       = "nsg"
    max_length = 80
  }
}
instance_env            = 2
instance_resource       = 1
logical_product_family  = "launch"
logical_product_service = "redis"
class_env               = "gotest"
location                = "eastus"

vnet_address_space = ["10.1.0.0/24"]
network_security_rules = [
  {
    name                       = "allow-vnet-addresses"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.1.0.0/24"
    destination_address_prefix = "*"
  }
]
