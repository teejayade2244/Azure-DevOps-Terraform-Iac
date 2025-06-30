module "resource_group" {
  source   = "./Modules/ResourceGroup"
  name     = "${local.resource_name_prefix}-${var.resource_group_name}"
  location = var.resource_group_location
  tags     = var.common_tags
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
  source              = "./Modules/Identity"
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