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
  vnet_subnet_id       = var.aks_subnet_id
  node_count           = 2
  node_labels = {
    "kubernetes.azure.com/mode" = "system"
  }
}
  private_cluster_enabled = true
  
    network_profile {
    network_plugin     = "azure"                     
    network_policy     = "azure"                                                        
    dns_service_ip     = "10.0.0.10"         
    service_cidr       = "10.0.0.0/16"       
    load_balancer_sku  = "standard"         

    outbound_type      = "loadBalancer"      
  }
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_log_workspace.id
  }

  azure_policy_enabled = true

}

