locals {
  create_network_security_group = !var.public_network_access_enabled && length(var.network_security_rules) > 0
}
