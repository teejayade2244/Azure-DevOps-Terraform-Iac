resource "azurerm_container_registry" "aks_acr" {
  name                = var.acr_name
  location            = var.location
  tags                = var.common_tags
  resource_group_name = var.resource_group_name
  sku                 = "Standard"                              
  admin_enabled       = false                                          
}

# resource "azurerm_private_endpoint" "acr_private_endpoint" {
#   name                = var.acr_private_endpoint_name
#   location            = var.location
#   tags                = var.common_tags
#   resource_group_name = var.resource_group_name
#   subnet_id           = azurerm_subnet.acr_subnet.id

#   private_service_connection {
#     name                           = "acr-psc"
#     private_connection_resource_id = azurerm_container_registry.aks_acr.id
#     is_manual_connection           = false
#     subresource_names              = ["registry"] # Specify the subresource for ACR
#   }

#   # Private DNS Zone Group for ACR
#   # Purpose: Ensures that DNS resolution for the ACR's private endpoint happens within your VNet,
#   # resolving to its private IP address instead of its public IP. This is crucial for private connectivity.
#   private_dns_zone_group {
#     name                 = "default"
#     private_dns_zone_ids = [azurerm_private_dns_zone.acr_private_dns_zone.id]
#   }
# }

