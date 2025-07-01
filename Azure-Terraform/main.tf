module "resource_group" {
  source   = "./Modules/Resource-group"
  resource_group_name = "${local.resource_name_prefix}-${var.resource_group_name}"
  resource_group_location = var.resource_group_location
  common_tags  = local.common_tags
}

module "vnet" {
  source                    = "./Modules/Vnet"
  vnet_name                 = "${local.resource_name_prefix}-${var.vnet_name}"
  vnet_address_space        = var.vnet_address_space
  location                  = module.resource_group.location
  resource_group_name       = module.resource_group.name
  common_tags               = local.common_tags
  AKS_subnet_name           = "${local.resource_name_prefix}-${var.AKS_subnet_name}"
  AKS_subnet_address_prefix = var.AKS_subnet_address_prefix
  depends_on = [module.resource_group]
}

module "identity" {
  source              = "./Modules/identities"
  aks_identity_name   = "${local.resource_name_prefix}-${var.aks_identity_name}"
  resource_group_name = module.resource_group.name
  resource_group_id   = module.resource_group.id  
  location            = module.resource_group.location
  common_tags         = var.common_tags
}

module "acr" {
  source              = "./Modules/ACR"
  acr_name            = var.acr_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  common_tags         = var.common_tags
}

module "aks" {
  source                        = "./Modules/AKS"
  aks_cluster_name              = var.aks_cluster_name
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  dns_prefix_name               = var.dns_prefix_name
  kubernetes_version            = var.kubernetes_version
  common_tags                   = var.common_tags
  log_analytics_workspace_name  = var.log_analytics_workspace_name
  user_assigned_identity_id     = module.identity.identity_id
  azurerm_user_assigned_identity_aks_identity_id = module.identity.identity_id
  aks_subnet_id                 = module.vnet.aks_subnet_id
}

module "nat_gateway" {
  source                = "./Modules/NAT"
  nat_gateway_name      = var.nat_gateway_name
  nat_gateway_pip_name  = var.nat_gateway_pip_name
  location              = module.resource_group.location
  resource_group_name   = module.resource_group.name
  common_tags           = var.common_tags
  aks_subnet_id         = module.vnet.aks_subnet_id
}

module "storage_account" {
  source                 = "./Modules/storage-account"
  resource_group_name    = var.resource_group_name
  storage_account_name   = var.storage_account_name
  account_tier           = var.account_tier
  account_replication_type = var.account_replication_type
  container_name         = var.container_name
  container_access_type  = var.container_access_type
}