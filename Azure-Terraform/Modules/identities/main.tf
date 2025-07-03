# # This Terraform configuration creates an Azure User Assigned Identity for AKS and assigns it the Contributor
# and AcrPull roles on a specified resource group.
resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = var.aks_identity_name
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
  location            = var.location
}

# Assign the User Assigned Identity to the specified resource group with Contributor and AcrPull roles
# This allows the AKS cluster to manage resources within the resource group and pull images from Azure
resource "azurerm_role_assignment" "aks_identity_rg_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

# Assign the User Assigned Identity the AcrPull role on the resource group
# This allows the AKS cluster to pull images from the Azure Container Registry (ACR)
resource "azurerm_role_assignment" "aks_identity_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}


# Get the node resource group data
data "azurerm_resource_group" "aks_node_rg" {
  name = "MC_ukwest-dev-demo-resource-group_demo-aks-cluster_ukwest"
}

# Assign Network Contributor role to the node resource group
resource "azurerm_role_assignment" "aks_identity_node_rg_network_contributor" {
  scope                = data.azurerm_resource_group.aks_node_rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}