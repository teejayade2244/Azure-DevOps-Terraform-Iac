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
  acr_id              = module.acr.acr_id
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


# resource "azurerm_subnet" "app_gateway_subnet" {
#   name                 = "${local.resource_name_prefix}-app-gateway-subnet"
#   resource_group_name  = module.resource_group.name
#   virtual_network_name = module.vnet.vnet_name
#   address_prefixes     = ["10.0.3.0/24"]
# }

# resource "azurerm_private_dns_zone" "internal_aks_zone" {
#   name                = "aks.internal"
#   resource_group_name = module.resource_group.name
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "aks_vnet_link" {
#   name                  = "link-aks-vnet-to-internal-dns"
#   resource_group_name   = module.resource_group.name
#   private_dns_zone_name = azurerm_private_dns_zone.internal_aks_zone.name
#   virtual_network_id    = module.vnet.vnet_id
#   registration_enabled  = false
# }

# resource "azurerm_private_dns_a_record" "argocd_ui_a_record" {
#   name                = "argocd"
#   zone_name           = azurerm_private_dns_zone.internal_aks_zone.name
#   resource_group_name = module.resource_group.name
#   ttl                 = 300
#   records             = [azurerm_application_gateway.web_app_gateway.frontend_ip_configuration[0].private_ip_address]
# }

# resource "azurerm_public_ip" "app_gateway_public_ip" {
#   name                = "${local.resource_name_prefix}-app-gateway-pip"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   tags                = var.common_tags
# }

# resource "azurerm_application_gateway" "web_app_gateway" {
#   name                = "${local.resource_name_prefix}-app-gateway"
#   resource_group_name = module.resource_group.name
#   location            = module.resource_group.location
#   tags                = local.common_tags # Ensure tags are included as per your original code


#  sku {
#     name     = "Standard_v2"
#     tier     = "Standard_v2"
#     capacity = 1
#   }

#   gateway_ip_configuration {
#     name      = "appgateway-ip-config"
#     subnet_id = azurerm_subnet.app_gateway_subnet.id
#   }

#   frontend_ip_configuration {
#     name                 = "frontend-private-ip"
#     private_ip_address   = " 10.0.1.11 " 
#     subnet_id            = azurerm_subnet.app_gateway_subnet.id
#   }

#     frontend_ip_configuration {
#     name                 = "frontend-public-ip"
#     public_ip_address_id = azurerm_public_ip.app_gateway_public_ip.id
#   }

#   frontend_port {
#     name = "https-port"
#     port = 443
#   }

#   backend_address_pool {
#     name  = "argocd-backend-pool"
#     fqdns = ["argocd-server.argocd.svc.cluster.local"] # Point to ArgoCD service
#   }

#   backend_http_settings {
#     name                                = "argocd-https-settings"
#     port                                = 443
#     protocol                            = "Https"
#     cookie_based_affinity               = "Disabled"
#     request_timeout                     = 60
#     probe_name                          = "argocd-health-probe"
#     pick_host_name_from_backend_address = true
#   }

#   probe {
#     name                = "argocd-health-probe"
#     protocol            = "Https"
#     host                = "argocd-server.argocd.svc.cluster.local"
#     path                = "/healthz"
#     interval            = 30
#     timeout             = 30
#     unhealthy_threshold = 3
#   }

#   ssl_certificate {
#     name     = "argocd-cert"
#     data     = filebase64("./certs/argocd.pfx")
#     password = "tope" # Replace with your actual certificate password
#   }

#   http_listener {
#     name                           = "argocd-https-listener"
#     frontend_ip_configuration_name = "frontend-private-ip"
#     frontend_port_name             = "https-port"
#     protocol                       = "Https"
#     ssl_certificate_name           = "argocd-cert"
#     host_names                     = ["argocd.aks.internal"] # Match your DNS record
#   }

#   request_routing_rule {
#     name                       = "argocd-routing-rule"
#     rule_type                  = "Basic"
#     http_listener_name         = "argocd-https-listener"
#     backend_address_pool_name  = "argocd-backend-pool"
#     backend_http_settings_name = "argocd-https-settings"
#     priority                   = 100
#   }

#   # WAF configuration is fully supported and enabled with WAF_v2
#   waf_configuration {
#     enabled            = true
#     firewall_mode      = "Prevention"
#     rule_set_type      = "OWASP"
#     rule_set_version   = "3.2" # Use the latest stable OWASP CRS version
#     file_upload_limit_mb = 100
#     max_request_body_size_kb = 128
#   }
# }
