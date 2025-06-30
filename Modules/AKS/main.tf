resource "azurerm_log_analytics_workspace" "aks_log_workspace" {
  name                = var.log_analytics_workspace_name
  tags                = var.common_tags
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018" 
  retention_in_days   = 30          
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name 
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix_name 
  tags                = var.common_tags
  kubernetes_version  = var.kubernetes_version 

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  default_node_pool {
    name                 = "systempool" 
    vm_size              = "Standard_DS2_v2" 
    os_disk_size_gb      = 128               
    node_count           = 2                
    vnet_subnet_id       = var.aks_subnet_id
    min_count            = 2               
    max_count            = 5               
    enable_auto_scaling  = true  
    node_labels = {
      "kubernetes.azure.com/mode" = "system"
    }
  }

  private_cluster_enabled = true
  

  # For modern AzureRM provider versions, use oms_agent block directly
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_log_workspace.id
  }

  # Azure Policy Add-on
  # Purpose: Extends Gatekeeper v3 to apply and enforce Azure Policy definitions on your AKS clusters.
  # This helps ensure compliance with organizational standards and regulatory requirements.
  azure_policy_enabled = true

}