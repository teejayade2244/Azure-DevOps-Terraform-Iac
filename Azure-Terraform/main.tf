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
  resource_group_name   = module.resource_group.name
  storage_account_name   = var.storage_account_name
  resource_group_location = var.resource_group_location
  common_tags            = var.common_tags
  account_tier           = var.account_tier
  account_replication_type = var.account_replication_type
  container_name         = var.container_name
  container_access_type  = var.container_access_type
}


resource "azurerm_subnet" "app_gateway_subnet" {
  name                 = "${local.resource_name_prefix}-app-gateway-subnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.vnet.vnet_name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_application_gateway" "web_app_gateway" {
  name                = "${local.resource_name_prefix}-app-gateway"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = local.common_tags

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgateway-ip-config"
    subnet_id = azurerm_subnet.app_gateway_subnet.id
  }

  frontend_ip_configuration {
    name                           = "frontend-private-ip"
    private_ip_address_allocation = "Dynamic" 
    subnet_id                     = azurerm_subnet.app_gateway_subnet.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  backend_address_pool {
    name        = "argocd-backend-pool"
    ip_addresses = ["10.0.1.11"]  # NGINX internal LoadBalancer IP
  }

  probe {
    name                = "health-probe"
    protocol            = "Http"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    port                = 80
  }

  backend_http_settings {
    name                  = "argocd-http-settings"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    request_timeout       = 60
    probe_name            = "health-probe"
  }

  http_listener {
    name                           = "argocd-http-listener"
    frontend_ip_configuration_name = "frontend-private-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
    host_names                     = ["*"]
  }

  request_routing_rule {
    name                       = "argocd-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "argocd-http-listener"
    backend_address_pool_name  = "argocd-backend-pool"
    backend_http_settings_name = "argocd-http-settings"
  }

  waf_configuration {
    enabled                     = true
    firewall_mode               = "Prevention"
    rule_set_type               = "OWASP"
    rule_set_version            = "3.2"
    file_upload_limit_mb        = 100
    max_request_body_size_kb    = 128
  }
}
