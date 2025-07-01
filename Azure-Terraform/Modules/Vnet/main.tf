resource "azurerm_virtual_network" "my_vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.common_tags
}

resource "azurerm_subnet" "AKS_subnet" {
  name                 = var.AKS_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.my_vnet.name  
  address_prefixes     = var.AKS_subnet_address_prefix
}
