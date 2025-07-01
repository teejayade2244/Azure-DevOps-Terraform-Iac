# modules/vnet/outputs.tf

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.my_vnet.id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.my_vnet.name
}

output "aks_subnet_id" {
  value = azurerm_subnet.AKS_subnet.id
}

output "aks_subnet_name" {
  value = azurerm_subnet.AKS_subnet.name
}