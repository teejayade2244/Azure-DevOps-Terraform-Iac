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
  vm_size              = "standard_a2_v2" 
  os_disk_size_gb      = 128
  vnet_subnet_id       = var.aks_subnet_id
  node_count           = 1
  node_labels = {
    "mode" = "system"
  }
  
}
  private_cluster_enabled = true
  oidc_issuer_enabled = true
  azure_policy_enabled = true
  workload_identity_enabled = true
network_profile {
  network_plugin     = "azure"
  network_policy     = "azure"
  dns_service_ip     = "10.1.0.10"
  service_cidr       = "10.1.0.0/16"
  load_balancer_sku  = "standard"
  outbound_type      = "loadBalancer"
}


  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_log_workspace.id
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "user_nodepool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = "Standard_D2s_v3" 
  os_disk_size_gb       = 128
  node_count            = 1                
  vnet_subnet_id        = var.aks_subnet_id
  auto_scaling_enabled = true
  min_count             = 1
  max_count             = 3      
  node_labels = {
  "workload" = "app"
}

  node_taints = [
    "workload=app:NoSchedule"
  ]
}