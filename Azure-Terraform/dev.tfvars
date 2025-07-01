resource_group_name  = "demo-resource-group"
resource_group_location = "ukwest"
environment          = "dev"
vnet_name            = "demo-vnet"
vnet_address_space   = ["10.0.0.0/16"]
AKS_subnet_name      = "AKS-subnet"
AKS_subnet_address_prefix  = ["10.0.1.0/24"]
acr_name             = "demoacr423432"
aks_identity_name    = "demo-aks-identity"
aks_cluster_name     = "demo-aks-cluster"
common_tags = {
  environment = "dev"
  region      = "ukwest"
}
dns_prefix_name     = "demo-aks"
kubernetes_version  = "1.32.2"
location            = "ukwest"
log_analytics_workspace_name = "demo-aks-law"
nat_gateway_name = "demo-nat-gateway"
nat_gateway_pip_name = "demo-nat-gateway-pip"
storage_account_name = "demostorageaccount4125"  
container_name      = "demo-tfstate"  


